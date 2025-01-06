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
}

class Item extends FlxSpriteGroup{
    public var whatdoido:ItemType;
    public var DaItem:FlxSprite;

    public var EditorMode:Bool = false;

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
                case _STIMPACK:
                    Playstate.instance.Player.health += 25; //TODO: make it change the value depending on player health and suit
                case _BOXOFBUCKSHELL:
                    Playstate.instance.Player.ShotgunAmmoRemaining = Playstate.instance.Player.ShotgunAmmoCap;
                case _BUCKSHELL:
                    Playstate.instance.Player.ShotgunAmmoRemaining += 25;
                case _BOXOF9MM:
                    Playstate.instance.Player.PistolAmmoRemaining = Playstate.instance.Player.PistolAmmoCap;
                case _9MMMAG:
                    Playstate.instance.Player.PistolAmmoRemaining += 25;
                case _RIFLEROUNDSBOX:
                    Playstate.instance.Player.RifleAmmoRemaining = Playstate.instance.Player.RifleAmmoCap;
                case _RIFLEROUNDSMAG:
                    Playstate.instance.Player.RifleAmmoRemaining += 25;
                case _SUIT:
                    //do something here, implement soon.
                default:
                    trace('error doing item thingy');
            }
        }
    }
}