package backend;

import flixel.math.FlxPoint;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxSpriteGroup {
    public var HUDBG:FlxSprite;
    public var HPTXT:FlxText;
    public var SMTXT:FlxText;
    public var FACEBG:FlxSprite;

    public var stamBar:FlxBar;
    public var healthBar:FlxBar;

    public var playstate:Playstate;

    public var ammocounter_AMMOTEXT:FlxText;
    public var ammocounter_LINE:FlxSprite;
    //public var ammocounter_AMMOSPR:FlxSprite;

    public function new(playstate:Playstate) {
        super();
        this.playstate = playstate;

        scrollFactor.set(0, 0);

        HUDBG = new FlxSprite(0, 0).makeGraphic(500, 60, FlxColor.TRANSPARENT);
        HUDBG.drawPolygon([new FlxPoint(0, 0), new FlxPoint(300, 0), new FlxPoint(250, 60), new FlxPoint(0, 60), new FlxPoint(0,0)], FlxColor.BLACK);
        add(HUDBG);

        ammocounter_LINE = new FlxSprite(205, 42).makeGraphic(40, 1, FlxColor.WHITE);
        add(ammocounter_LINE);

        ammocounter_AMMOTEXT = new FlxText(210, 30, 0, "AMMO", 8, true);
        add(ammocounter_AMMOTEXT);

        FACEBG = new FlxSprite(0,5).makeGraphic(50, 50, FlxColor.WHITE);
        add(FACEBG);
        
        healthBar = new FlxBar(50, 5, LEFT_TO_RIGHT, 200, 25, playstate.Player, 'health');
        healthBar.createFilledBar(0xFF830000, 0xFFFF0000);
        add(healthBar);

        HPTXT = new FlxText(52, healthBar.y + 14);
        HPTXT.scale.set(1.2,1.2);
        HPTXT.alignment = LEFT;
        HPTXT.text = "Health";
        add(HPTXT);

        stamBar = new FlxBar(healthBar.x, healthBar.y + 25, LEFT_TO_RIGHT, 150, 25, playstate.Player, 'stamina');
        stamBar.createFilledBar(0xFF0083A0, 0xFF00B7FF);
        add(stamBar);

        SMTXT = new FlxText(HPTXT.x, HPTXT.y + 25);
        SMTXT.scale.set(1.2,1.2);
        SMTXT.alignment = LEFT;
        SMTXT.text = "Stamina";
        add(SMTXT);
    }

    override public function update(elapsed:Float) {
        healthBar.setRange(0, playstate.Player.maxHealth);
        stamBar.setRange(0, playstate.Player.maxStamina);
        healthBar.value = playstate.Player.health;
        stamBar.value = playstate.Player.stamina;
    }

}