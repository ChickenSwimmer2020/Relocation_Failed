package objects.game.interactables;

import flixel.group.FlxGroup;

enum ItemType 
{
    //health
    _HEALTHPACK; //full health refill
    _STIMPACK; //refil a determinate ammount of health depending on current health value
    //ammo stuff
    _BOXOFBUCKSHELL; //full buckshell refill
    _BUCKSHELL; //gives + 25 buckshell
    _BOXOF9MM; //full 9MM refill
    _9MMMAG; //gives +25 9MM
    _RIFLEROUNDSBOX; //full 7.62x51mm NATO refill
    _RIFLEROUNDSMAG; //gives +25 7.62x51MM NATO
    //misc
    _OXYGENTANK; //gives oxygen (FOR THE HULL BREACH AREAS ONLY.)
    _SUITBATTERY; //gives +15% armor battery
    //other
    _SUIT; //gives players access to sprint, weapons, and hud.
    //guns >:)
    _PISTOL; //gives the player a pistol
    _SHOTGUN; //gives the player a shotgun
    _RIFLE; //gives the player a rifle
    _SMG; //gives the player a submachine gun
}

class Item extends FlxSpriteGroup{
    public var whatdoido:ItemType;
    public var DaItem:FlxSprite;

    public var EditorMode:Bool = false;

    public var _STATMSGTWEENTIME:Float = 1;
    public var _STATMSGWAITTIME:Float = 1;
    public var _STATMSGFINISHYPOS:Float = 10;

    public function new(X:Float, Y:Float, texture:FlxGraphic, itemType:ItemType, ?Editor:Bool = false) {
        super();    
        whatdoido = itemType;
        EditorMode = Editor;
        DaItem = new FlxSprite(X, Y, texture);
        add(DaItem);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        for(DaItem in this) {
            var item:FlxSprite = cast DaItem;
            if(!EditorMode) {
                if(item.overlaps(Playstate.instance.Player)) {
                    try{
                        doItemShtuff(whatdoido);
                        this.kill();
                    } catch(e) {
                        trace('error was caught, be more careful!');
                    }
                }
            }
        }
    }

    function doItemShtuff(WhatToDo:ItemType) {
        if(!EditorMode) {
            switch(WhatToDo) {
                case _HEALTHPACK:
                    Playstate.instance.Player.health = Playstate.instance.Player.maxHealth;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('administering medical assistance...', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    wait(_STATMSGWAITTIME, ()->{
                        Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Health Restored!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    });
                case _STIMPACK:
                    Playstate.instance.Player.health += 25; //TODO: make it change the value depending on player health and suit
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('administering medical assistance...', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    wait(_STATMSGWAITTIME, ()->{
                        Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Health Restored By [CHANGABLE VALUE]%!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    });
                case _BOXOFBUCKSHELL:
                    Playstate.instance.Player.ShotgunAmmoRemaining = Playstate.instance.Player.ShotgunAmmoCap;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Shotgun Ammo Refilled!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _BUCKSHELL:
                    Playstate.instance.Player.ShotgunAmmoRemaining += 25;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Shotgun Ammo +25!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _BOXOF9MM:
                    Playstate.instance.Player.PistolAmmoRemaining = Playstate.instance.Player.PistolAmmoCap;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Pistol Ammo Refilled!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _9MMMAG:
                    Playstate.instance.Player.PistolAmmoRemaining += 25;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Pistol Ammo +25!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _RIFLEROUNDSBOX:
                    Playstate.instance.Player.RifleAmmoRemaining = Playstate.instance.Player.RifleAmmoCap;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Rifle Ammo Refilled!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _RIFLEROUNDSMAG:
                    Playstate.instance.Player.RifleAmmoRemaining += 25;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Rifle Ammo +25!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _SUIT:
                    //do something here, implement soon.
                    //Playstate.instance.Hud.StatMSGContainer.doCoolSuitIntro(TODO: vars);
                case _SUITBATTERY:
                    Playstate.instance.Player.battery += 15;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Battery Recharged By 15%!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _PISTOL:
                    Playstate.instance.Player.hasPistol = true;
                    Playstate.instance.Player.CurWeaponChoice = PISTOLROUNDS;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Pistol Acquired!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    if(Playstate.instance.Player.gun.theGunTexture.alpha == 0)
                        Playstate.instance.Player.gun.theGunTexture.alpha = 1;
                case _SHOTGUN:
                    Playstate.instance.Player.hasShotgun = true;
                    Playstate.instance.Player.CurWeaponChoice = SHOTGUNSHELL;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Shotgun Acquired!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _RIFLE:
                    Playstate.instance.Player.hasRifle = true;
                    Playstate.instance.Player.CurWeaponChoice = RIFLEROUNDS;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Rifle Acquired!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _SMG:
                    Playstate.instance.Player.hasSMG = true;
                    Playstate.instance.Player.CurWeaponChoice = SMGROUNDS;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Submachine Gun Acquired!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                default:
                    trace('error doing item thingy');
            }
        }
    }
}