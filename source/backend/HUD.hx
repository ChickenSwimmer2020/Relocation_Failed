package backend;

import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
using flixel.util.FlxSpriteUtil;

#if mobile
import flixel.ui.FlxVirtualPad;
#end

class HUD extends FlxSpriteGroup {
    public var HUDBG:FlxSprite;
    public var FACEBG:FlxSprite;

    public var HPTXT:FlxText;
    public var SMTXT:FlxText;
    public var OXTXT:FlxText;

    public var stamBar:FlxBar;
    public var healthBar:FlxBar;
    public var oxyBar:FlxBar;

    public var playstate:Playstate;

    public var ammocounter_AMMOTEXT:FlxText;
    public var ammocounter_LINE:FlxSprite;
    public var CurAmmoName:String;
    public var CurAmmoCap:Int;
    public var CurAmmoNum:Int;
    public var ammocounter_AMMONUMONE:FlxText; //current ammo ammount
    public var ammocounter_AMMOSLASH:FlxText; //the middle slash
    public var ammocounter_AMMONUMTWO:FlxText; //max ammo ammount
    //public var ammocounter_AMMOSPR:FlxSprite;

    #if mobile
    public static var virtualPad:FlxVirtualPad;
    #end

    #if debug
    public var debugControls:FlxText;
    public static var pressforcontrols:FlxText;
    public var FPS:FlxText;
    #end
    
    public function new(playstate:Playstate) {
        super();
        this.playstate = playstate;

        scrollFactor.set(0, 0);

        createHud(); //i dont wanna clutter the new function, so imma just move all that to a seperate function
        
        #if mobile
        virtualPad = new FlxVirtualPad(FULL, NONE);
        add(virtualPad);
        #end

        #if debug
        pressforcontrols = new FlxText(0, 700, 0, "Press HOME For Debug Controls", 12, false);
        add(pressforcontrols);
        debugControls = new FlxText(0, 0, 0, "", 24, false);
        debugControls.text = "Press ONE to toggle hitboxes view\nPress TWO to dump save file to console";
        debugControls.screenCenter(XY);
        debugControls.alpha = 0;
        add(debugControls);
        FPS = new FlxText(1220, 60, 0, '', 12, false);
        add(FPS);
        #end
    }

    override public function update(elapsed:Float) {
        super.update(elapsed); //we forgot this-

        healthBar.setRange(0, playstate.Player.maxHealth);
        stamBar.setRange(0, playstate.Player.maxStamina);
        oxyBar.setRange(0, playstate.Player.maxOxygen);
        healthBar.value = playstate.Player.health;
        stamBar.value = playstate.Player.stamina;
        oxyBar.value = playstate.Player.oxygen;

        switch(Playstate.instance.Player.CurWeaponChoice) {
            case SHOTGUNSHELL:
                CurAmmoName = '12 Gauge BuckShells';
                ammocounter_AMMOTEXT.x = 980;
                CurAmmoCap = Playstate.instance.Player.ShotgunAmmoCap;
                CurAmmoNum = Playstate.instance.Player.ShotgunAmmoRemaining;
            case PISTOLROUNDS:
                CurAmmoName = '9MM';
                ammocounter_AMMOTEXT.x = 980;
                CurAmmoCap = Playstate.instance.Player.PistolAmmoCap;
                CurAmmoNum = Playstate.instance.Player.PistolAmmoRemaining;
            case RIFLEROUNDS:
                CurAmmoName = '7.62x51MM NATO';
                ammocounter_AMMOTEXT.x = 980;
                CurAmmoCap = Playstate.instance.Player.RifleAmmoCap;
                CurAmmoNum = Playstate.instance.Player.RifleAmmoRemaining;
            default:
                ammocounter_AMMOTEXT.x = 0;
                CurAmmoName = 'FIX ME!';
                CurAmmoCap = 0;
                CurAmmoNum = 0;
        };

        ammocounter_AMMOTEXT.text = CurAmmoName;
        ammocounter_AMMONUMONE.text = '' + CurAmmoNum;
        ammocounter_AMMONUMTWO.text = '' + CurAmmoCap;

        ammocounter_AMMOSLASH.x = ammocounter_AMMONUMONE.frameWidth + 1050 - 20;
        ammocounter_AMMONUMTWO.x = ammocounter_AMMONUMONE.frameWidth + 1065 - 20;

        #if debug
        var fps:Float = elapsed;
        FPS.text = '$fps :FPS';
        if(FlxG.keys.anyJustPressed([HOME])) {
            debugControls.alpha = 1;
            FlxTween.tween(debugControls, {"alpha": 0}, 2, { ease: FlxEase.expoIn});
        }
        #end
    }

    function createHud():Void {
        healthBar = new FlxBar(50, 5, LEFT_TO_RIGHT, 250, 25, playstate.Player, 'health');
        healthBar.createFilledBar(0xFF830000, 0xFFFF0000);
        

        HPTXT = new FlxText(52, healthBar.y + 14);
        HPTXT.scale.set(1.2,1.2);
        HPTXT.alignment = LEFT;
        HPTXT.text = "Health";
        

        stamBar = new FlxBar(healthBar.x, healthBar.y + 25, LEFT_TO_RIGHT, 200, 25, playstate.Player, 'stamina');
        stamBar.createFilledBar(0xFF0083A0, 0xFF00B7FF);
        

        SMTXT = new FlxText(HPTXT.x, HPTXT.y + 25);
        SMTXT.scale.set(1.2,1.2);
        SMTXT.alignment = LEFT;
        SMTXT.text = "Stamina";

        OXTXT = new FlxText(620, -1.5);
        OXTXT.alignment = CENTER;
        OXTXT.text = "OXYGEN";

        oxyBar = new FlxBar(0, 2.5, HORIZONTAL_INSIDE_OUT, 570, 5, playstate.Player, 'oxygen');
        oxyBar.createFilledBar(0xFF003DA0, 0xFF001AFF);
        oxyBar.screenCenter(X);
        

        HUDBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, 60, FlxColor.TRANSPARENT);
        var HUDBGPOINTS:Array<FlxPoint> = 
        [
            new FlxPoint(0, 0),
            new FlxPoint(1280, 0),
            new FlxPoint(1280, 60),
            new FlxPoint(1032, 60),
            new FlxPoint(932, 10),
            new FlxPoint(350, 10),
            new FlxPoint(250, 60),
            new FlxPoint(0, 60),
            new FlxPoint(0, 0)
        ];
        HUDBG.drawPolygon(HUDBGPOINTS, FlxColor.BLACK);
        

        ammocounter_LINE = new FlxSprite(980, 28).makeGraphic(250, 5, FlxColor.WHITE);
        ammocounter_AMMOTEXT = new FlxText(1050, 0, 0, '', 24, true);
        ammocounter_AMMOTEXT.alignment = CENTER;


        ammocounter_AMMONUMONE = new FlxText(1032, 30, '', 24, true);
        ammocounter_AMMOSLASH = new FlxText(0, 30, 0, '/', 24, true);
        ammocounter_AMMONUMTWO = new FlxText(0, 30, 0, '', 24, true);
        

        FACEBG = new FlxSprite(0,5).makeGraphic(50, 50, FlxColor.WHITE);
        

        add(HUDBG);
        add(healthBar);
        add(HPTXT);
        add(stamBar);
        add(SMTXT);
        add(oxyBar);
        add(OXTXT);
        add(FACEBG);
        add(ammocounter_LINE);
        add(ammocounter_AMMOTEXT);
        add(ammocounter_AMMONUMONE);
        add(ammocounter_AMMOSLASH);
        add(ammocounter_AMMONUMTWO);
    }

}