package objects.game.interactables;

import flixel.group.FlxGroup;
import backend.save.PlayerSaveStateUtil;
import backend.save.GameSave;
import backend.level.rfl.RFLParser.RFLAssets;
import backend.save.SaveState;
import objects.game.interactables.items.*;

enum abstract ItemType(String) from String to String
{
    //health
    var _HEALTHPACK = '_HEALTHPACK'; //full health refill
    var _STIMPACK = '_STIMPACK'; //refil a determinate ammount of health depending on current health value
    //ammo stuff
    var _BOXOFBUCKSHELL = '_BOXOFBUCKSHELL'; //full buckshell refill
    var _BUCKSHELL = '_BUCKSHELL'; //gives + 25 buckshell
    var _BOXOF9MM = '_BOXOF9MM'; //full 9MM refill
    var _9MMMAG = '_9MMMAG'; //gives +25 9MM
    var _RIFLEROUNDSBOX = '_RIFLEROUNDSBOX'; //full 7.62x51mm NATO refill
    var _RIFLEROUNDSMAG = '_RIFLEROUNDSMAG'; //gives +25 7.62x51MM NATO
    //misc
    var _OXYGENTANK = '_OXYGENTANK'; //gives oxygen (FOR THE HULL BREACH AREAS ONLY.)
    var _SUITBATTERY = '_SUITBATTERY'; //gives +15% armor battery
    //other
    var _SUIT = '_SUIT'; //gives players access to sprint, weapons, and hud.
    //guns >:)
    var _PISTOL = '_PISTOL'; //gives the player a pistol
    var _SHOTGUN = '_SHOTGUN'; //gives the player a shotgun
    var _RIFLE = '_RIFLE'; //gives the player a rifle
    var _SMG = '_SMG'; //gives the player a submachine gun

    //* fallbacks (for if SOMEONE forgot to implement an item type [YOU FORGOT THE SMG AMMO, SOLAR --ChickenSwimmer2020])
    var _NULL = '_NULL'; // for missing item behaviors
}

class Item extends FlxGroup{
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

    function typeToClass(type:ItemType):BaseItem
        return type == _HEALTHPACK ? new HealthPack(this) : type == _STIMPACK ? new Stimpack(this) : type == _BOXOFBUCKSHELL ? new BoxOfBuckShells(this) : type == _BUCKSHELL ? new Buckshell(this) : type == _BOXOF9MM ? new BoxOf9MM(this) : type == _9MMMAG ? new NineMMMag(this) : type == _RIFLEROUNDSBOX ? new RifleRoundsBox(this) : type == _RIFLEROUNDSMAG ? new RifleRoundsMag(this) : type == _OXYGENTANK ? new OxygenTank(this) : type == _SUITBATTERY ? new SuitBattery(this) : type == _SUIT ? new Suit(this) : type == _PISTOL ? new Pistol(this) : type == _SHOTGUN ? new Shotgun(this) : type == _RIFLE ? new Rifle(this) : type == _SMG ? new SMG(this) : null;

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
            if (!item.returnCondition){
                item.remove();
                item = null;
                return 1;
            }
            ps.items.push(item);
            if (Std.isOfType(item, BaseWeapon))
                ps.onWeaponPickup();
            if (item.customPickupCallback != null) 
                item.customPickupCallback(); 
            else
                item.onPickup();
            if (item.statusMessage != '')
                ps.Hud.StatMSGContainer.CreateStatusMessage(item.statusMessage, _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
        }
        return 0;
    }
}