package;

import menu.MainMenu;
import backend.save.PlayerSaveStateUtil;
import backend.save.PlayerSaveStateUtil.PlayerSaveStatus;
import flixel.tweens.FlxEase;
import backend.save.SaveState;
import backend.level.LevelLoader.LevelHeader;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup;
import backend.*;
import backend.level.*;
import objects.game.controllables.*;
import objects.game.hud.HUD;

class Playstate extends FlxTransitionableState {
	public static var instance:Playstate;

	// we have to create the player in a stupid way thanks to my ideas.
	public var Player:Player;
	#if !mobile
	public var Player2:Aimer;
	public var AimerGroup:FlxSpriteGroup = new FlxSpriteGroup();
	#else
	#end
	public var Hud:HUD;
	public var Level:Level;
	public var colliders:Array<FlxSprite> = [];

	public var FGCAM:FlxCamera;
	public var HUDCAM:FlxCamera;

	public var followStyle:FlxCameraFollowStyle;

	public var _LEVEL:String;
	public var saveSlot:Int = 1;

	public var BulletGroup:FlxGroup;
	#if !mobile
	#if debug
	public var DebuggerHelper = new backend.DEBUGKEYS();
	#end
	#end
	override public function new(levelToLoad:String = 'level1', ?PlayerPosition:Array<Float> = null, ?stats:SaveState, ?saveSlot:Int = 1) {
		super();
		instance = this;
		this.saveSlot = saveSlot;
		_LEVEL = levelToLoad;

		if (PlayerPosition == null)
			PlayerPosition = [0, 0];

		Player = new Player(PlayerPosition[0], PlayerPosition[1],
			this); // we need to init the player here or else its gonna cause a crash when attempting to load the save-state
		Player.Transitioning = false;

		if (stats != null) {
			// health and stamina
			Player.health = stats.cur_health;
			Player.stamina = stats.cur_stamina;
			Player.battery = stats.cur_battery;
			// positioning
			Player.x = stats.player_x;
			Player.y = stats.player_y;
			// ammo stuff.
			Player.PistolAmmoCap = stats.piscap;
			Player.PistolAmmoRemaining = stats.pisremain;
			Player.ShotgunAmmoCap = stats.shtcap;
			Player.ShotgunAmmoRemaining = stats.shtremain;
			Player.RifleAmmoCap = stats.rifcap;
			Player.RifleAmmoRemaining = stats.rifremain;
			Player.SMGAmmoCap = stats.smgcap;
			Player.SMGAmmoRemaining = stats.smgremain;
			// other.
			// Player.hasSuit =;
		}
	}

	override public function create() {
		super.create();

        if(!FlxG.sound.music.playing) {
            FlxG.sound.playMusic(Assets.music('IDLE.ogg'), 1, true);
        }

		BulletGroup = new FlxGroup();

		FGCAM = new FlxCamera();
		FlxG.cameras.add(FGCAM, false);
		FGCAM.bgColor = 0x0011FF00;

		HUDCAM = new FlxCamera();
		FlxG.cameras.add(HUDCAM, false);
		HUDCAM.bgColor = 0x0011FF00;

		Hud = new HUD(this);
		// if(!Player.HasSuit) Hud.y = 1350; //*  the hud to be invsible if the player doesnt have the suit
		Hud.cameras = [HUDCAM];
		#if !mobile
		Player2 = new Aimer();
		#else
		#end
		Level = new Level(LevelLoader.ParseLevelData(Assets.asset('$_LEVEL.json')));
		Level.EditorMode = false;
		Level.loadLevel();

		for (obj in Level.objects)
			if (obj.isCollider && !obj.isForeGroundSprite)
				colliders.push(obj);
		Player.colliders = colliders;

		add(Level);
		add(Player);
		#if !mobile
		add(Player2);
		add(AimerGroup);
		#else
		#end
		add(BulletGroup);
		add(Hud);
	}

	override public function update(elapsed:Float) {
		#if debug
		DebuggerHelper.update(elapsed);
		#end
		switch (Level.CameraFollowStyle) {
			case 'LOCKON':
				followStyle = LOCKON;
			case 'PLATFORMER':
				followStyle = PLATFORMER;
			case 'TOPDOWN':
				followStyle = TOPDOWN;
			case 'TOPDOWN_TIGHT':
				followStyle = TOPDOWN_TIGHT;
			case 'SCREEN_BY_SCREEN':
				followStyle = SCREEN_BY_SCREEN;
			case 'NO_DEAD_ZONE':
				followStyle = NO_DEAD_ZONE;
			default:
				followStyle = null;
		}
		if (!Level.CameraLocked) { // camera locking so we can have static rooms
			FlxG.camera.follow(Player, followStyle, Level.CameraLerp * elapsed);
			FGCAM.follow(Player, followStyle, Level.CameraLerp * elapsed);
		}
		if (FlxG.keys.anyPressed([PAGEUP]) && FlxG.camera.zoom < 2) {
			FlxG.camera.zoom += 0.05;
			FGCAM.zoom += 0.05;
		}
		if (FlxG.keys.anyPressed([PAGEDOWN]) && FlxG.camera.zoom > 1) {
			FlxG.camera.zoom -= 0.05;
			FGCAM.zoom -= 0.05;
		}
		if (FlxG.camera.zoom > 2)
			FlxG.camera.zoom = 2;
		if (FGCAM.zoom > 2)
			FGCAM.zoom = 2;

		if (FlxG.camera.zoom < 1)
			FlxG.camera.zoom = 1;
		if (FGCAM.zoom < 1)
			FGCAM.zoom = 1;

		Player.CurRoom = Level.LevelID;

		#if !mobile
        AimerGroup.update(elapsed); //you know, this might cause issues with animations :facepalm:
		AimerGroup.setPosition(Player2.x, Player2.y);
		Playstate.instance.AimerGroup.angle = Player2.angle + 1;
		#else
		#end
		super.update(elapsed);
	}

	override public function destroy() {
		super.destroy();
		FGCAM.destroy();
		HUDCAM.destroy();
	}
}

class DeathState extends FlxState {
	var deathText:FlxText;
	var deathText2:FlxText;
	var deathText3:FlxText;
	var bg:FlxSprite; // remember to make this into a semi-transparent version of whereever you are in the main playstate somehow.
	var deathanim:FlxSprite;

	public function new() {
		super();
		bg = new FlxSprite(0, 0);
		bg.makeGraphic(FlxG.width, FlxG.height, 0xFF51FF00);
		// bg.creategraphicfromscreenshotorseomthignidfk add function to create graphic from screenshot.
		deathText = new FlxText(0, 0, FlxG.width, "Your journey has ended.");
		deathText2 = new FlxText(0, 0, FlxG.width, "But you can try again...");
		deathText3 = new FlxText(0, 0, FlxG.width, "Press any key to load your last save.\n Or press escape to return to the main menu.");

        deathanim = new FlxSprite(0, 0);
        //TODO: create death animation.

		FlxTween.tween(bg, {alpha: 0.25}, 1, {ease: FlxEase.smootherStepInOut});
		wait(1, function() {
			StartDeath();
		});

        add(bg);
        //add(deathanim);
        add(deathText);
        add(deathText2);
        add(deathText3);
	}

	public function StartDeath():Void {
        //do something i think.
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (FlxG.keys.anyPressed([ESCAPE])) {
            FlxG.switchState(new MainMenu());
        }
        if (FlxG.keys.anyPressed([ANY]) && !FlxG.keys.anyPressed([ESCAPE])) {
            PlayerSaveStateUtil.LoadPlayerSaveState(1); //TODO: make this load the save state from the last save properly depending on save slot.
        }
    }
}
