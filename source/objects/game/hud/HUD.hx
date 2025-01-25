package objects.game.hud;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import objects.game.hud.StatusMessage;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxSpriteGroup {
    public var HUDBG:FlxSprite;
    public var FACEBG:FlxSprite;

    public var HPTXT:FlxText;
    public var SMTXT:FlxText;
    public var OXTXT:FlxText;
    public var BTRTXT:FlxText;

    public var stamBar:FlxBar;
    public var healthBar:FlxBar;
    public var oxyBar:FlxBar;
    public var btrBar:FlxBar;

    public var playstate:Playstate;

    public var StatMSGContainer:StatusMessageHolder;
    public var ammocounter_AMMOTEXT:FlxText;
    public var ammocounter_LINE:FlxSprite;
    public var CurAmmoName:String;
    public var CurAmmoCap:Int;
    public var CurAmmoNum:Int;
    public var ammocounter_AMMONUMONE:FlxText; //current ammo ammount
    public var ammocounter_AMMOSLASH:FlxText; //the middle slash
    public var ammocounter_AMMONUMTWO:FlxText; //max ammo ammount
    public var ammocounter_AMMOSPR1:FlxSprite;
    public var ammocounter_AMMOSPR2:FlxSprite;
    public var ammocounter_AMMOSPR3:FlxSprite;
    public var ammocounter_AMMOSPR4:FlxSprite;

    public var damageind:FlxSprite;

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
        btrBar.value = playstate.Player.battery;

        switch(Playstate.instance.Player.CurWeaponChoice) {
            case SHOTGUNSHELL:
                CurAmmoName = '12 Gauge BuckShells';
                ammocounter_AMMOTEXT.x = 980;
                CurAmmoCap = Playstate.instance.Player.ShotgunAmmoCap;
                CurAmmoNum = Playstate.instance.Player.ShotgunAmmoRemaining;
                ammocounter_AMMOSPR1.animation.play('BS');
                ammocounter_AMMOSPR2.animation.play('BS');
                ammocounter_AMMOSPR3.animation.play('BS');
                ammocounter_AMMOSPR4.animation.play('BS');
            case PISTOLROUNDS:
                CurAmmoName = '9MM';
                ammocounter_AMMOTEXT.x = 980;
                CurAmmoCap = Playstate.instance.Player.PistolAmmoCap;
                CurAmmoNum = Playstate.instance.Player.PistolAmmoRemaining;
                ammocounter_AMMOSPR1.animation.play('9MM');
                ammocounter_AMMOSPR2.animation.play('9MM');
                ammocounter_AMMOSPR3.animation.play('9MM');
                ammocounter_AMMOSPR4.animation.play('9MM');
            case RIFLEROUNDS:
                CurAmmoName = '7.62x51MM NATO';
                ammocounter_AMMOTEXT.x = 980;
                CurAmmoCap = Playstate.instance.Player.RifleAmmoCap;
                CurAmmoNum = Playstate.instance.Player.RifleAmmoRemaining;
                ammocounter_AMMOSPR1.animation.play('NATO');
                ammocounter_AMMOSPR2.animation.play('NATO');
                ammocounter_AMMOSPR3.animation.play('NATO');
                ammocounter_AMMOSPR4.animation.play('NATO');
            case SMGROUNDS:
                CurAmmoName = '10MM AUTO';
                ammocounter_AMMOTEXT.x = 980;
                CurAmmoCap = Playstate.instance.Player.SMGAmmoCap;
                CurAmmoNum = Playstate.instance.Player.SMGAmmoRemaining;
                ammocounter_AMMOSPR1.animation.play('10MM');
                ammocounter_AMMOSPR2.animation.play('10MM');
                ammocounter_AMMOSPR3.animation.play('10MM');
                ammocounter_AMMOSPR4.animation.play('10MM');
            default:
                ammocounter_AMMOTEXT.x = 980;
                CurAmmoName = 'None';
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
        if(FlxG.keys.anyJustPressed([NUMPADONE, NUMPADTWO, NUMPADTHREE, NUMPADFOUR, NUMPADFIVE])) {
            
            if(FlxG.keys.anyJustPressed([NUMPADONE])) {
                Playstate.instance.Player.health = 100;
            }
            if(FlxG.keys.anyJustPressed([NUMPADTWO])) {
                Playstate.instance.Player.health = 75;
            }
            if(FlxG.keys.anyJustPressed([NUMPADTHREE])) {
                Playstate.instance.Player.health = 50;
            }
            if(FlxG.keys.anyJustPressed([NUMPADFOUR])) {
                Playstate.instance.Player.health = 25;
            }
            if(FlxG.keys.anyJustPressed([NUMPADFIVE])) {
                Playstate.instance.Player.health = 0;
            }

        }
        #end
    }

    function createHud():Void {
        StatMSGContainer = new StatusMessageHolder(200, 300, #if debug true #else false #end);

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

        OXTXT = new FlxText(350, -1.5);
        OXTXT.alignment = CENTER;
        OXTXT.text = "OXYGEN";

        BTRTXT = new FlxText(885, -1.5);
        BTRTXT.alignment = CENTER;
        BTRTXT.text = "BATTERY";

        oxyBar = new FlxBar(350, 2.5, LEFT_TO_RIGHT, 300, 5, playstate.Player, 'oxygen');
        oxyBar.createFilledBar(0xFF003DA0, 0xFF001AFF);
        
        btrBar = new FlxBar(650, 2.5, RIGHT_TO_LEFT, 280, 5, playstate.Player, 'battery');
        btrBar.createFilledBar(0xFF007816, 0xFF07D700);
        

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


        ammocounter_AMMOSPR1 = new FlxSprite(1241, 25).loadGraphic(Assets.image('HUD_Bullets'), true, 9, 31);
        ammocounter_AMMOSPR1.animation.add('9MM', [0], 1, false, false, false);
        ammocounter_AMMOSPR1.animation.add('10MM', [1], 1, false, false, false);
        ammocounter_AMMOSPR1.animation.add('BS', [2], 1, false, false, false);
        ammocounter_AMMOSPR1.animation.add('NATO', [3], 1, false, false, false);
        ammocounter_AMMOSPR1.animation.play('9MM');
        ammocounter_AMMOSPR2 = new FlxSprite(1250, 25).loadGraphic(Assets.image('HUD_Bullets'), true, 9, 31);
        ammocounter_AMMOSPR2.animation.add('9MM', [0], 1, false, false, false);
        ammocounter_AMMOSPR2.animation.add('10MM', [1], 1, false, false, false);
        ammocounter_AMMOSPR2.animation.add('BS', [2], 1, false, false, false);
        ammocounter_AMMOSPR2.animation.add('NATO', [3], 1, false, false, false);
        ammocounter_AMMOSPR2.animation.play('9MM');
        ammocounter_AMMOSPR3 = new FlxSprite(1259, 25).loadGraphic(Assets.image('HUD_Bullets'), true, 9, 31);
        ammocounter_AMMOSPR3.animation.add('9MM', [0], 1, false, false, false);
        ammocounter_AMMOSPR3.animation.add('10MM', [1], 1, false, false, false);
        ammocounter_AMMOSPR3.animation.add('BS', [2], 1, false, false, false);
        ammocounter_AMMOSPR3.animation.add('NATO', [3], 1, false, false, false);
        ammocounter_AMMOSPR3.animation.play('9MM');
        ammocounter_AMMOSPR4 = new FlxSprite(1268, 25).loadGraphic(Assets.image('HUD_Bullets'), true, 9, 31);
        ammocounter_AMMOSPR4.animation.add('9MM', [0], 1, false, false, false);
        ammocounter_AMMOSPR4.animation.add('10MM', [1], 1, false, false, false);
        ammocounter_AMMOSPR4.animation.add('BS', [2], 1, false, false, false);
        ammocounter_AMMOSPR4.animation.add('NATO', [3], 1, false, false, false);
        ammocounter_AMMOSPR4.animation.play('9MM');


        FACEBG = new FlxSprite(0,5).makeGraphic(50, 50, FlxColor.WHITE);

        damageind = new FlxSprite(0, 60).loadGraphic(Assets.image('HUD_DMGINDC')); //TODO: implement when damage works.
        

        add(HUDBG);
        add(healthBar);
        add(HPTXT);
        add(stamBar);
        add(SMTXT);
        add(oxyBar);
        add(OXTXT);
        add(btrBar);
        add(BTRTXT);
        add(FACEBG);
        add(ammocounter_LINE);
        add(ammocounter_AMMOTEXT);
        add(ammocounter_AMMONUMONE);
        add(ammocounter_AMMOSLASH);
        add(ammocounter_AMMONUMTWO);
        add(ammocounter_AMMOSPR1);
        add(ammocounter_AMMOSPR2);
        add(ammocounter_AMMOSPR3);
        add(ammocounter_AMMOSPR4);
        add(damageind);
        add(StatMSGContainer);
    }

}