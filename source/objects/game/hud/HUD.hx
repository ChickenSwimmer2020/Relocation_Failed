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

	public var ps:Playstate;

	public var StatMSGContainer:StatusMessageHolder;
	public var ammocounter_AMMOTEXT:FlxText;
	public var ammocounter_LINE:FlxSprite;
	public var CurAmmoName:String;
	public var CurAmmoCap:Int;
	public var CurAmmoNum:Int;
	public var ammocounter_AMMONUMONE:FlxText; // current ammo ammount
	public var ammocounter_AMMOSLASH:FlxText; // the middle slash
	public var ammocounter_AMMONUMTWO:FlxText; // max ammo ammount
	public var ammocounter_AMMOSPR1:FlxSprite;
	public var ammocounter_AMMOSPR2:FlxSprite;
	public var ammocounter_AMMOSPR3:FlxSprite;
	public var ammocounter_AMMOSPR4:FlxSprite;

	public var damageind:FlxSprite;

	public var hudCreateAnimRunning:Bool = false;
	public var healthTweening:Bool = false;
	public var hudCreated:Bool = false;
	public var healthreset:Bool = false;

	#if debug
	public var debugControls:FlxText;

	public static var pressforcontrols:FlxText;

	public var FPS:FlxText;
	#end

	public function new(ps:Playstate) {
		super();
		this.ps = ps;

		scrollFactor.set(0, 0);

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
		super.update(elapsed);
		if (!hudCreated) {
			if (ps.Player.suit != null) {
				createHud(); // i dont wanna clutter the new function, so imma just move all that to a seperate function
				hudCreated = true;
			} else if (ps.Player.GotSuitFirstTime) {
				createHudFirstStartupAnim();
				hudCreated = true;
			}
		}

		if (healthBar != null)
			healthBar.setRange(0, ps.Player.maxHealth);
		if (stamBar != null)
			stamBar.setRange(0, ps.Player.maxStamina);
		if (oxyBar != null)
			oxyBar.setRange(0, ps.Player.maxOxygen);

		if (!hudCreateAnimRunning) {
			if (healthBar != null && !healthTweening && !hudCreateAnimRunning)
				healthBar.value = ps.Player.Health;
			if (stamBar != null)
				stamBar.value = ps.Player.stamina;
			if (oxyBar != null)
				oxyBar.value = ps.Player.oxygen;
			if (btrBar != null)
				btrBar.value = ps.Player.battery;
		}

		if (ammocounter_AMMONUMONE != null && ammocounter_AMMONUMTWO != null && ammocounter_AMMOSLASH != null && ammocounter_AMMOSPR1 != null
			&& ammocounter_AMMOSPR2 != null && ammocounter_AMMOSPR3 != null && ammocounter_AMMOSPR4 != null && ammocounter_AMMOTEXT != null) {
			switch (ps.Player.CurWeaponChoice) {
				case SHOTGUNSHELL:
					CurAmmoName = '12 Gauge BuckShells';
					ammocounter_AMMOTEXT.x = 980;
					CurAmmoCap = ps.Player.gunData.ShotgunAmmoCap;
					CurAmmoNum = ps.Player.gunData.ShotgunAmmoRemaining;
					ammocounter_AMMOSPR1.animation.play('BS');
					ammocounter_AMMOSPR2.animation.play('BS');
					ammocounter_AMMOSPR3.animation.play('BS');
					ammocounter_AMMOSPR4.animation.play('BS');
				case PISTOLROUNDS:
					CurAmmoName = '9MM';
					ammocounter_AMMOTEXT.x = 980;
					CurAmmoCap = ps.Player.gunData.PistolAmmoCap;
					CurAmmoNum = ps.Player.gunData.PistolAmmoRemaining;
					ammocounter_AMMOSPR1.animation.play('9MM');
					ammocounter_AMMOSPR2.animation.play('9MM');
					ammocounter_AMMOSPR3.animation.play('9MM');
					ammocounter_AMMOSPR4.animation.play('9MM');
				case RIFLEROUNDS:
					CurAmmoName = '7.62x51MM NATO';
					ammocounter_AMMOTEXT.x = 980;
					CurAmmoCap = ps.Player.gunData.RifleAmmoCap;
					CurAmmoNum = ps.Player.gunData.RifleAmmoRemaining;
					ammocounter_AMMOSPR1.animation.play('NATO');
					ammocounter_AMMOSPR2.animation.play('NATO');
					ammocounter_AMMOSPR3.animation.play('NATO');
					ammocounter_AMMOSPR4.animation.play('NATO');
				case SMGROUNDS:
					CurAmmoName = 'FN 5.7×28mm NATO'; // we're making it a P90 smg. //no we're not, we're making it a mp9k
					ammocounter_AMMOTEXT.x = 980;
					CurAmmoCap = ps.Player.gunData.SMGAmmoCap;
					CurAmmoNum = ps.Player.gunData.SMGAmmoRemaining;
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
		}

		#if debug
		var fps:Float = elapsed;
		FPS.text = '$fps :FPS';
		if (FlxG.keys.anyJustPressed([HOME])) {
			debugControls.alpha = 1;
			FlxTween.tween(debugControls, {"alpha": 0}, 2, {ease: FlxEase.expoIn});
		}
		if (FlxG.keys.anyJustPressed([NUMPADONE, NUMPADTWO, NUMPADTHREE, NUMPADFOUR, NUMPADFIVE])) {
			if (FlxG.keys.anyJustPressed([NUMPADONE])) {
				ps.Player.Health = 100;
			}
			if (FlxG.keys.anyJustPressed([NUMPADTWO])) {
				ps.Player.Health = 75;
			}
			if (FlxG.keys.anyJustPressed([NUMPADTHREE])) {
				ps.Player.Health = 50;
			}
			if (FlxG.keys.anyJustPressed([NUMPADFOUR])) {
				ps.Player.Health = 25;
			}
			if (FlxG.keys.anyJustPressed([NUMPADFIVE])) {
				ps.Player.Health = 0;
			}
		}
		#end
		if (healthTweening) {
			//TODO: this
			ps.Player.Health = 100;
			ps.Player.displayHealth = 100;
			healthTweening = false;
		}
	}

	function createHud():Void {
		StatMSGContainer = new StatusMessageHolder(200, 300, #if debug true #else false #end, ps);
		hudCreateAnimRunning = false;

		healthBar = new FlxBar(50, 5, LEFT_TO_RIGHT, 250, 25, ps.Player, 'displayHealth');
		healthBar.createFilledBar(0xFF830000, 0xFFFF0000);

		HPTXT = new FlxText(52, healthBar.y + 14);
		HPTXT.scale.set(1.2, 1.2);
		HPTXT.alignment = LEFT;
		HPTXT.text = "Health";

		stamBar = new FlxBar(healthBar.x, healthBar.y + 25, LEFT_TO_RIGHT, 200, 25, ps.Player, 'stamina');
		stamBar.createFilledBar(0xFF0083A0, 0xFF00B7FF);

		SMTXT = new FlxText(HPTXT.x, HPTXT.y + 25);
		SMTXT.scale.set(1.2, 1.2);
		SMTXT.alignment = LEFT;
		SMTXT.text = "Stamina";

		OXTXT = new FlxText(350, -1.5);
		OXTXT.alignment = CENTER;
		OXTXT.text = "OXYGEN";

		BTRTXT = new FlxText(885, -1.5);
		BTRTXT.alignment = CENTER;
		BTRTXT.text = "BATTERY";

		oxyBar = new FlxBar(350, 2.5, LEFT_TO_RIGHT, 300, 5, ps.Player, 'oxygen');
		oxyBar.createFilledBar(0xFF003DA0, 0xFF001AFF);

		btrBar = new FlxBar(650, 2.5, RIGHT_TO_LEFT, 280, 5, ps.Player, 'battery');
		btrBar.createFilledBar(0xFF007816, 0xFF07D700);

		HUDBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, 60, FlxColor.TRANSPARENT);
		var HUDBGPOINTS:Array<FlxPoint> = [
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

		ammocounter_AMMOSPR1 = new FlxSprite(1241, 25).loadGraphic(Assets.image('game/HUD_Bullets'), true, 9, 31);
		ammocounter_AMMOSPR1.animation.add('9MM', [0], 1, false, false, false);
		ammocounter_AMMOSPR1.animation.add('10MM', [1], 1, false, false, false);
		ammocounter_AMMOSPR1.animation.add('BS', [2], 1, false, false, false);
		ammocounter_AMMOSPR1.animation.add('NATO', [3], 1, false, false, false);
		ammocounter_AMMOSPR1.animation.play('9MM');
		ammocounter_AMMOSPR2 = new FlxSprite(1250, 25).loadGraphic(Assets.image('game/HUD_Bullets'), true, 9, 31);
		ammocounter_AMMOSPR2.animation.add('9MM', [0], 1, false, false, false);
		ammocounter_AMMOSPR2.animation.add('10MM', [1], 1, false, false, false);
		ammocounter_AMMOSPR2.animation.add('BS', [2], 1, false, false, false);
		ammocounter_AMMOSPR2.animation.add('NATO', [3], 1, false, false, false);
		ammocounter_AMMOSPR2.animation.play('9MM');
		ammocounter_AMMOSPR3 = new FlxSprite(1259, 25).loadGraphic(Assets.image('game/HUD_Bullets'), true, 9, 31);
		ammocounter_AMMOSPR3.animation.add('9MM', [0], 1, false, false, false);
		ammocounter_AMMOSPR3.animation.add('10MM', [1], 1, false, false, false);
		ammocounter_AMMOSPR3.animation.add('BS', [2], 1, false, false, false);
		ammocounter_AMMOSPR3.animation.add('NATO', [3], 1, false, false, false);
		ammocounter_AMMOSPR3.animation.play('9MM');
		ammocounter_AMMOSPR4 = new FlxSprite(1268, 25).loadGraphic(Assets.image('game/HUD_Bullets'), true, 9, 31);
		ammocounter_AMMOSPR4.animation.add('9MM', [0], 1, false, false, false);
		ammocounter_AMMOSPR4.animation.add('10MM', [1], 1, false, false, false);
		ammocounter_AMMOSPR4.animation.add('BS', [2], 1, false, false, false);
		ammocounter_AMMOSPR4.animation.add('NATO', [3], 1, false, false, false);
		ammocounter_AMMOSPR4.animation.play('9MM');

		FACEBG = new FlxSprite(0, 5).makeGraphic(50, 50, FlxColor.WHITE);

		damageind = new FlxSprite(0, 60).loadGraphic(Assets.image('game/game/HUD_DMGINDC')); // TODO: implement when damage works.

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

	function healthAppear(V:Float) {
		wait(V, () -> {
			HPTXT.text = "H";
		});
		wait(V + 0.1, () -> {
			HPTXT.text = "He";
		});
		wait(V + 0.2, () -> {
			HPTXT.text = "Hea";
		});
		wait(V + 0.3, () -> {
			HPTXT.text = "Heal";
		});
		wait(V + 0.4, () -> {
			HPTXT.text = "Healt";
		});
		wait(V + 0.5, () -> {
			HPTXT.text = "Health";
		});
	}

	function staminaAppear(V:Float) {
		wait(V, () -> {
			SMTXT.text = "S";
		});
		wait(V + 0.1, () -> {
			SMTXT.text = "St";
		});
		wait(V + 0.2, () -> {
			SMTXT.text = "Sta";
		});
		wait(V + 0.3, () -> {
			SMTXT.text = "Stam";
		});
		wait(V + 0.4, () -> {
			SMTXT.text = "Stami";
		});
		wait(V + 0.5, () -> {
			SMTXT.text = "Stamin";
		});
		wait(V + 0.6, () -> {
			SMTXT.text = "Stamina";
		});
	}

	function oxygenAppear(V:Float) {
		wait(V, () -> {
			OXTXT.text = "O";
		});
		wait(V + 0.1, () -> {
			OXTXT.text = "OX";
		});
		wait(V + 0.2, () -> {
			OXTXT.text = "OXY";
		});
		wait(V + 0.3, () -> {
			OXTXT.text = "OXYG";
		});
		wait(V + 0.4, () -> {
			OXTXT.text = "OXYGE";
		});
		wait(V + 0.5, () -> {
			OXTXT.text = "OXYGEN";
		});
	}

	function batteryAppear(V:Float) {
		wait(V, () -> {
			BTRTXT.text = "B";
		});
		wait(V + 0.1, () -> {
			BTRTXT.text = "BA";
		});
		wait(V + 0.2, () -> {
			BTRTXT.text = "BAT";
		});
		wait(V + 0.3, () -> {
			BTRTXT.text = "BATT";
		});
		wait(V + 0.4, () -> {
			BTRTXT.text = "BATTE";
		});
		wait(V + 0.5, () -> {
			BTRTXT.text = "BATTER";
		});
		wait(V + 0.6, () -> {
			BTRTXT.text = "BATTERY";
		});
	}

	function createHudFirstStartupAnim():Void {
		StatMSGContainer = new StatusMessageHolder(0, 60, #if debug true #else false #end, ps);
		hudCreateAnimRunning = true;

		HUDBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, 60, FlxColor.TRANSPARENT);
		var HUDBGPOINTS:Array<FlxPoint> = [
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
		HUDBG.y = -60;

		healthBar = new FlxBar(50, 5, LEFT_TO_RIGHT, 250, 25, ps.Player, 'displayHealth');
		healthBar.createFilledBar(0xFF830000, 0xFFFF0000);
		healthBar.alpha = 0;
		ps.Player.displayHealth = 0;
		healthBar.updateHitbox();

		HPTXT = new FlxText(52, healthBar.y + 14, 0);
		HPTXT.scale.set(1.2, 1.2);
		HPTXT.alignment = LEFT;
		HPTXT.wordWrap = false;
		HPTXT.text = "";
		HPTXT.alpha = 0;

		stamBar = new FlxBar(healthBar.x, healthBar.y + 25, LEFT_TO_RIGHT, 200, 25, ps.Player, 'stamina');
		stamBar.createFilledBar(0xFF0083A0, 0xFF00B7FF);
		stamBar.alpha = 0;

		SMTXT = new FlxText(HPTXT.x, HPTXT.y + 25);
		SMTXT.scale.set(1.2, 1.2);
		SMTXT.alignment = LEFT;
		SMTXT.text = "";
		SMTXT.alpha = 0;

		OXTXT = new FlxText(350, -1.5);
		OXTXT.alignment = CENTER;
		OXTXT.text = "";
		OXTXT.alpha = 0;

		BTRTXT = new FlxText(885, -1.5);
		BTRTXT.alignment = CENTER;
		BTRTXT.text = "";
		BTRTXT.alpha = 0;

		oxyBar = new FlxBar(350, 2.5, LEFT_TO_RIGHT, 300, 5, ps.Player, 'oxygen');
		oxyBar.createFilledBar(0xFF003DA0, 0xFF001AFF);
		oxyBar.alpha = 0;

		btrBar = new FlxBar(650, 2.5, RIGHT_TO_LEFT, 280, 5, ps.Player, 'battery');
		btrBar.createFilledBar(0xFF007816, 0xFF07D700);
		btrBar.alpha = 0;

		FACEBG = new FlxSprite(0, 5).makeGraphic(50, 50, FlxColor.WHITE);
		FACEBG.alpha = 0;

		ammocounter_LINE = new FlxSprite(980, 28).makeGraphic(250, 5, FlxColor.WHITE);
		ammocounter_LINE.scale.x = 0.0001;
		ammocounter_LINE.updateHitbox();

		ammocounter_AMMOTEXT = new FlxText(1050, 0, 0, '', 24, true);
		ammocounter_AMMOTEXT.alignment = CENTER;
		ammocounter_AMMOTEXT.alpha = 0;

		ammocounter_AMMONUMONE = new FlxText(1032, 30, '', 24, true);
		ammocounter_AMMONUMONE.alpha = 0;
		ammocounter_AMMOSLASH = new FlxText(0, 30, 0, '/', 24, true);
		ammocounter_AMMOSLASH.alpha = 0;
		ammocounter_AMMONUMTWO = new FlxText(0, 30, 0, '', 24, true);
		ammocounter_AMMONUMTWO.alpha = 0;

		ammocounter_AMMOSPR1 = new FlxSprite(1241, 25).loadGraphic(Assets.image('game/HUD_Bullets'), true, 9, 31);
		ammocounter_AMMOSPR1.animation.add('9MM', [0], 1, false, false, false);
		ammocounter_AMMOSPR1.animation.add('10MM', [1], 1, false, false, false);
		ammocounter_AMMOSPR1.animation.add('BS', [2], 1, false, false, false);
		ammocounter_AMMOSPR1.animation.add('NATO', [3], 1, false, false, false);
		ammocounter_AMMOSPR1.animation.play('9MM');
		ammocounter_AMMOSPR2 = new FlxSprite(1250, 25).loadGraphic(Assets.image('game/HUD_Bullets'), true, 9, 31);
		ammocounter_AMMOSPR2.animation.add('9MM', [0], 1, false, false, false);
		ammocounter_AMMOSPR2.animation.add('10MM', [1], 1, false, false, false);
		ammocounter_AMMOSPR2.animation.add('BS', [2], 1, false, false, false);
		ammocounter_AMMOSPR2.animation.add('NATO', [3], 1, false, false, false);
		ammocounter_AMMOSPR2.animation.play('9MM');
		ammocounter_AMMOSPR3 = new FlxSprite(1259, 25).loadGraphic(Assets.image('game/HUD_Bullets'), true, 9, 31);
		ammocounter_AMMOSPR3.animation.add('9MM', [0], 1, false, false, false);
		ammocounter_AMMOSPR3.animation.add('10MM', [1], 1, false, false, false);
		ammocounter_AMMOSPR3.animation.add('BS', [2], 1, false, false, false);
		ammocounter_AMMOSPR3.animation.add('NATO', [3], 1, false, false, false);
		ammocounter_AMMOSPR3.animation.play('9MM');
		ammocounter_AMMOSPR4 = new FlxSprite(1268, 25).loadGraphic(Assets.image('game/HUD_Bullets'), true, 9, 31);
		ammocounter_AMMOSPR4.animation.add('9MM', [0], 1, false, false, false);
		ammocounter_AMMOSPR4.animation.add('10MM', [1], 1, false, false, false);
		ammocounter_AMMOSPR4.animation.add('BS', [2], 1, false, false, false);
		ammocounter_AMMOSPR4.animation.add('NATO', [3], 1, false, false, false);
		ammocounter_AMMOSPR4.animation.play('9MM');

		ammocounter_AMMOSPR1.alpha = 0;
		ammocounter_AMMOSPR2.alpha = 0;
		ammocounter_AMMOSPR3.alpha = 0;
		ammocounter_AMMOSPR4.alpha = 0;

		FlxTween.tween(HUDBG, {y: 0}, 1, {ease: FlxEase.cubeOut});

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
		add(StatMSGContainer);
		StatMSGContainer.alpha = 0;
		wait(1, () -> {
			StatMSGContainer.alpha = 1;
			StatMSGContainer.DoCoolIntro();
		});
	}

	public function showBars() {
		wait(1, () -> {
			ps.Player.displayHealth = 0;
			ps.Player.stamina = 0;
			FlxTween.tween(healthBar, {alpha: 1}, 1, {
				ease: FlxEase.expoOut,
				onComplete: function(Twn:FlxTween) {
					ps.Player.displayHealth = 0;
					healthTweening = true;
					FlxTween.tween(HPTXT, {alpha: 1}, 0.2, {ease: FlxEase.sineOut});
					wait(0.2, () -> {
						healthAppear(0.2);
					});
				}
			});
			FlxTween.tween(stamBar, {alpha: 1}, 1, {
				ease: FlxEase.expoOut,
				onUpdate: function(Twn3:FlxTween) {
					ps.Player.stamina = 0;
				},
				onComplete: function(Twn2:FlxTween) {
					ps.Player.stamina = 0;
					FlxTween.tween(SMTXT, {alpha: 1}, 0.2, {ease: FlxEase.sineOut});
					wait(0.2, () -> {
						staminaAppear(0.2);
					});
				}
			});
			FlxTween.tween(oxyBar, {alpha: 1}, 1, {
				ease: FlxEase.expoOut,
				onComplete: function(Twn4:FlxTween) {
					FlxTween.tween(OXTXT, {alpha: 1}, 0.2, {ease: FlxEase.sineOut});
					wait(0.2, () -> {
						oxygenAppear(0.2);
					});
				}
			});
			FlxTween.tween(btrBar, {alpha: 1}, 1, {
				ease: FlxEase.expoOut,
				onComplete: function(Twn5:FlxTween) {
					FlxTween.tween(BTRTXT, {alpha: 1}, 0.2, {ease: FlxEase.sineOut});
					wait(0.2, () -> {
						batteryAppear(0.2);
					});
				}
			});
			FlxTween.tween(FACEBG, {alpha: 1}, 0.2, {ease: FlxEase.expoOut});
			wait(1, () -> {
				FlxTween.tween(ammocounter_LINE, {"scale.x": 1}, 2.2, {ease: FlxEase.cubeOut, onUpdate: function(Twn6:FlxTween) {
					ammocounter_LINE.updateHitbox();
				}});
			});
		});
	}
}
