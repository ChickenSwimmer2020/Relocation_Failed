package objects.game.interactables;

import flixel.group.FlxGroup;
import backend.save.PlayerSaveStateUtil;
import backend.save.GameSave;
import backend.level.rfl.RFLParser.RFLAssets;
import backend.save.SaveState;
import objects.game.interactables.items.BoxOf9MM;
import objects.game.interactables.items.BoxOfBuckShells;
import objects.game.interactables.items.Buckshell;
import objects.game.interactables.items.HealthPack;
import objects.game.interactables.items.NineMMMag;
import objects.game.interactables.items.OxygenTank;
import objects.game.interactables.items.RifleRoundsBox;
import objects.game.interactables.items.RifleRoundsMag;
import objects.game.interactables.items.SMG;
import objects.game.interactables.items.Suit;
import objects.game.interactables.items.SuitBattery;
import objects.game.interactables.items.Stimpack;
import objects.game.interactables.items.Shotgun;
import objects.game.interactables.items.Pistol;
import objects.game.interactables.items.Rifle;
import objects.game.interactables.items.BaseItem;
import objects.game.interactables.items.BaseWeapon;
using StringTools;

enum abstract ItemType(String) from String to String {
    //health
    var _HealthPack = '_HealthPack'; //full health refill
    var _Stimpack = '_Stimpack'; //refil a determinate ammount of health depending on current health value
    //ammo stuff
    var _BoxOfBuckShells = '_BoxOfBuckShells'; //full buckshell refill
    var _Buckshell = '_Buckshell'; //gives + 25 buckshell
    var _BoxOf9MM = '_BoxOf9MM'; //full 9MM refill
    var _NineMMMag = '_NineMMMag'; //gives +25 9MM
    var _RifleRoundsBox = '_RifleRoundsBox'; //full 7.62x51mm NATO refill
    var _RifleRoundsMag = '_RifleRoundsMag'; //gives +25 7.62x51MM NATO
    var _SMGAmmoBox = '_SMGAmmoBox'; //full SMG refill
    //misc
    var _OxygenTank = '_OxygenTank'; //gives oxygen (FOR THE HULL BREACH AREAS ONLY.)
    var _SuitBattery = '_SuitBattery'; //gives +15% armor battery
    //other
    var _Suit = '_Suit'; //gives players access to sprint, weapons, and hud.
    //guns >:)
    var _Pistol = '_Pistol'; //gives the player a pistol
    var _Shotgun = '_Shotgun'; //gives the player a shotgun
    var _Rifle = '_Rifle'; //gives the player a rifle
    var _SMG = '_SMG'; //gives the player a submachine gun

    //* fallbacks (for if SOMEONE forgot to implement an item type [YOU FORGOT THE SMG AMMO, SOLAR --ChickenSwimmer2020] im so sorryyyyyy 😭 -ZSolarDev)
    var _NULL = '_NULL'; // for missing item behaviors
}

class Item extends FlxGroup{

    public static var itemClasses:Array<Class<Dynamic>> = [
        HealthPack,
        Stimpack,
        BoxOfBuckShells,
        Buckshell,
        BoxOf9MM,
        NineMMMag,
        RifleRoundsBox,
        RifleRoundsMag,
        OxygenTank,
        SuitBattery,
        Suit,
        Pistol,
        Shotgun,
        Rifle,
        objects.game.interactables.items.SMG
    ];

    public var curItemType:ItemType;
    public var itemTex:RFTriAxisSprite;
    public var ps:Playstate;
    public var groupParent:FlxTypedGroup<RFTriAxisSprite>;
    public var directParent:FlxGroup;

    public var EditorMode:Bool = false;

    public var _STATMSGTWEENTIME:Float = 1;
    public var _STATMSGWAITTIME:Float = 1;
    public var _STATMSGFINISHYPOS:Float = 10;

    public function new(assets:RFLAssets, X:Float, Y:Float, Z:Float, texture:String, itemType:ItemType, ps:Playstate, directParent:FlxGroup, groupParent:FlxTypedGroup<RFTriAxisSprite>, ?Editor:Bool = false) {
        super();    
        curItemType = itemType;
        this.ps = ps;
        EditorMode = Editor;
        itemTex = new RFTriAxisSprite(X, Y, Z, Level.getGraphicFromRFLAssets(texture, assets));
        this.groupParent = groupParent;
        this.directParent = directParent;
        groupParent.add(itemTex);
    }

    function typeToClass(type:ItemType):BaseItem{
        var buff:StringBuf = new StringBuf();
        buff.add('objects.game.interactables.items.');
        var str:String = type;
        buff.add(str.substr(1));
        var className:String = buff.toString();
        var cls = Type.resolveClass(className);
        var instance = cls != null ? Type.createInstance(cls, [this]) : null;
        if (instance == null)
            throw 'Item type ' + type + ' not implemented/incorrect!';
        return instance;
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(!EditorMode) {
            if(itemTex.overlaps(ps.Player)) {
                if(processItem(curItemType) == 0){
                    groupParent.remove(itemTex);
                    directParent.remove(this);
                    itemTex.destroy();
                    destroy();
                }
            }
        }
    }

    function processItem(itemType:ItemType):Int {
        if(!EditorMode) {
            var item:BaseItem = typeToClass(itemType);
            try{
                if (!item.returnCondition){
                    item.remove();
                    item = null;
                    return 1;
                }
            }catch(e){
                trace('Item return condition failed: ' + e.message);
            }
            ps.items.push(item);
            if (Std.isOfType(item, BaseWeapon))
                ps.onWeaponPickup();
            if (item.customPickupCallback != null) {
                try{
                    item.RunCustomCallBackFunction(); 
                }catch(e){
                    trace('Item custom pickup callback failed: ' + e.message);
                }
            }else{
                item.onPickup();
            }
            if (item.statusMessage != '')
                ps.Hud.StatMSGContainer.CreateStatusMessage(item.statusMessage, _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
        }
        return 0;
    }
}