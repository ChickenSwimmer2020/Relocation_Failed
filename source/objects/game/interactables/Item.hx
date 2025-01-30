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
                    if(doItemShtuff(whatdoido) == 0)
                        this.kill();
                }
            }
        }
    }

    function doItemShtuff(WhatToDo:ItemType):Int {
        if(!EditorMode) {
            switch(WhatToDo) {
                case _HEALTHPACK:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Health Pack', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.health = Playstate.instance.Player.maxHealth;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('administering medical assistance...', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    wait(_STATMSGWAITTIME, ()->{
                        Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Health Restored!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    });
                case _STIMPACK:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('stimpack', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.health += 25; //TODO: make it change the value depending on player health and suit
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('administering medical assistance...', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    wait(_STATMSGWAITTIME, ()->{
                        Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Health Restored By [CHANGABLE VALUE]%!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    });
                case _BOXOFBUCKSHELL:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Box Of Buckshell', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.ShotgunAmmoRemaining = Playstate.instance.Player.ShotgunAmmoCap;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Shotgun Ammo Refilled!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _BUCKSHELL:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Buckshells', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.ShotgunAmmoRemaining += 25;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Shotgun Ammo +25!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _BOXOF9MM:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Box of 9MM', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.PistolAmmoRemaining = Playstate.instance.Player.PistolAmmoCap;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Pistol Ammo Refilled!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _9MMMAG:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('9MM Mag', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.PistolAmmoRemaining += 25;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Pistol Ammo +25!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _RIFLEROUNDSBOX:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Box of Rifle Rounds', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.RifleAmmoRemaining = Playstate.instance.Player.RifleAmmoCap;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Rifle Ammo Refilled!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _RIFLEROUNDSMAG:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Rifle Mag', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.RifleAmmoRemaining += 25;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Rifle Ammo +25!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _SUIT:
                    Playstate.instance.Player.GotSuitFirstTime = true;
                    wait(4, ()->{ Playstate.instance.Player.hasSuit = true; Playstate.instance.Player.GotSuitFirstTime = false; });
                case _SUITBATTERY:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Battery', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.battery += 15;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Battery Recharged By 15%!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _PISTOL:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Pistol', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.hasPistol = true;
                    Playstate.instance.Player.CurWeaponChoice = PISTOLROUNDS;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Pistol Acquired!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    if(Playstate.instance.Player.gun.theGunTexture.alpha == 0)
                        Playstate.instance.Player.gun.theGunTexture.alpha = 1;
                    Playstate.instance.Player.updateWeapon();
                case _SHOTGUN:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Shotgun', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.hasShotgun = true;
                    Playstate.instance.Player.CurWeaponChoice = SHOTGUNSHELL;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Shotgun Acquired!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                    if(Playstate.instance.Player.gun.theGunTexture.alpha == 0)
                        Playstate.instance.Player.gun.theGunTexture.alpha = 1;
                    Playstate.instance.Player.CurWeaponChoice = SHOTGUNSHELL;
                    Playstate.instance.Player.updateWeapon();
                case _RIFLE:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Rifle', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.hasRifle = true;
                    Playstate.instance.Player.CurWeaponChoice = RIFLEROUNDS;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Rifle Acquired!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                case _SMG:
                    if (!Playstate.instance.Player.hasSuit) return 1;
                    Playstate.instance.onItemPickup('Smg', null, () -> { GameState.saveState([Playstate.instance.Player.health, Playstate.instance.Player.oxygen, Playstate.instance.Player.battery, Playstate.instance.Player.stamina, Playstate.instance.Player.PistolAmmoRemaining, Playstate.instance.Player.ShotgunAmmoRemaining, Playstate.instance.Player.RifleAmmoRemaining, Playstate.instance.Player.SMGAmmoRemaining, null, Playstate.instance.Player.hasPistol, Playstate.instance.Player.hasShotgun, Playstate.instance.Player.hasRifle, Playstate.instance.Player.hasSMG]); });
                    Playstate.instance.Player.hasSMG = true;
                    Playstate.instance.Player.CurWeaponChoice = SMGROUNDS;
                    Playstate.instance.Hud.StatMSGContainer.CreateStatusMessage('Submachine Gun Acquired!', _STATMSGTWEENTIME, _STATMSGWAITTIME, _STATMSGFINISHYPOS);
                default:
                    trace('Unknown item type aquired!');
            }
        }
        return 0;
    }
}