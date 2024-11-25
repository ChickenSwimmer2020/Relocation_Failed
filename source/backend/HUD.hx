package backend;

import flixel.math.FlxPoint;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxSpriteGroup {
    private var HUDBG:FlxSprite;

    private var HPTXT:FlxText;
    private var SMTXT:FlxText;
    private var stamBar:FlxBar;
    private var healthBar:FlxBar;

    private var faceBG:FlxSprite;

    public static var HEALTH:Int;
    private static var maxHEALTH:Int;

    public static var STAMINA:Int;
    private static var maxSTAMINA:Int;

    public function new() {
        super();

        scrollFactor.set(0, 0);

        HUDBG = new FlxSprite(0, 0).makeGraphic(500, 60, FlxColor.TRANSPARENT);
        HUDBG.drawPolygon([new FlxPoint(0, 0), new FlxPoint(300, 0), new FlxPoint(250, 60), new FlxPoint(0, 60), new FlxPoint(0,0)], FlxColor.BLACK);
        add(HUDBG);

        faceBG = new FlxSprite(0,5).makeGraphic(50, 50, FlxColor.WHITE);
        add(faceBG);
        
        maxHEALTH = 100;
        HEALTH = 100;
        healthBar = new FlxBar(50, 5, LEFT_TO_RIGHT, 200, 25);
        healthBar.createFilledBar(0xFF830000, 0xFFFF0000);
        add(healthBar);

        HPTXT = new FlxText(52, healthBar.y + 14);
        HPTXT.scale.set(1.2,1.2);
        HPTXT.alignment = LEFT;
        HPTXT.text = "Health";
        add(HPTXT);

        maxSTAMINA = 100;
        STAMINA = 100;
        stamBar = new FlxBar(healthBar.x, healthBar.y + 25, LEFT_TO_RIGHT, 150, 25);
        stamBar.createFilledBar(0xFF0083A0, 0xFF00B7FF);
        add(stamBar);

        SMTXT = new FlxText(HPTXT.x, HPTXT.y + 25);
        SMTXT.scale.set(1.2,1.2);
        SMTXT.alignment = LEFT;
        SMTXT.text = "Stamina";
        add(SMTXT);
    }

    override public function update(elapsed:Float) {

        healthBar.value = HEALTH;
        healthBar.setRange(0, maxHEALTH);

        stamBar.value = STAMINA;
        stamBar.setRange(0, maxSTAMINA);
    }

}