package backend;

class HUD extends FlxSpriteGroup {
    private var HPTXT:FlxText;
    private var SMTXT:FlxText;

    private var stamBar:FlxBar;
    private var healthBar:FlxBar;

    public static var HEALTH:Int;
    private static var maxHEALTH:Int;

    public static var STAMINA:Int;
    private static var maxSTAMINA:Int;

    public function new() {
        super();

        scrollFactor.set(0, 0);
        
        maxHEALTH = 100;
        HEALTH = 100;
        healthBar = new FlxBar(50, 0, LEFT_TO_RIGHT, 100, 15);
        healthBar.createFilledBar(0xFF830000, 0xFFFF0000);
        add(healthBar);

        HPTXT = new FlxText(50, 2);
        HPTXT.scale.set(2,2);
        HPTXT.alignment = LEFT;
        HPTXT.text = "Health";
        add(HPTXT);

        maxSTAMINA = 100;
        STAMINA = 100;
        stamBar = new FlxBar(healthBar.x + 15, healthBar.y + 15, LEFT_TO_RIGHT, 100, 4);
        stamBar.createFilledBar(0xFF0083A0, 0xFF00B7FF);
        add(stamBar);

        SMTXT = new FlxText(HPTXT.x + 15, HPTXT.y + 15);
        SMTXT.scale.set(2,2);
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