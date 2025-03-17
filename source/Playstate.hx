package;

import backend.save.GameSave;
import backend.level.Level.LevelSprite;
import objects.RFTriAxisSprite;
import flixel.math.FlxPoint;
import objects.game.controllables.Aimer.InteractionBox;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import openfl.Assets;
import haxe.zip.Reader;
import haxe.io.Bytes;
import haxe.zip.Entry;
import objects.game.interactables.items.*;
import objects.game.interactables.Item.ItemType;
import Xml.XmlType;
import sys.io.File;
import flixel.math.FlxMath;
import lime.system.Clipboard;
import backend.dialogue.DialogueTypedefs.Dialogue;
import menu.MainMenu;
import tjson.TJSON;
import backend.save.PlayerSaveStateUtil;
import flixel.tweens.FlxEase;
import backend.save.SaveState;
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
	public var Player2:Aimer;
	public var AimerGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var Player3:InteractionBox; // for interactions since i cant attach the sprite to the aimer itself :/

	public var Hud:HUD;
	public var Level:Level;
	public var doubleAxisColliders:Array<RFTriAxisSprite> = [];
	public var tripleAxisColliders:Array<LevelSprite> = [];

	public var FGCAM:FlxCamera;
	public var HUDCAM:FlxCamera;

	public var followStyle:FlxCameraFollowStyle;

	public var _LEVEL:String;
	public var saveSlot:Int = 1;

	public var LevelTransitionFadeSprite:FlxSprite = new FlxSprite(0, 0);

	public var BulletGroup:FlxGroup;
	public var ShellGroup:FlxGroup;
	#if debug
		public var DebuggerHelper = new debug.DEBUG();
	#end

	public var isBeatStateType:Bool = false; // should camera bop
	public var BPM:Float = 150;
	public var BopsPerNumOfBeats:Int = 4000;

	public var nextTriggerTime:Float = 0;
	public var interval:Float;

	public var defaultCamZoom:Float = 1;
	public var FgCamDefaultZoom:Float = 1;
	public var items:Array<BaseItem> = [];
	public var dying:Bool = false;
	var tweenOneDone:Bool = false;
	var tweenTwoDone:Bool = false;

	override public function new(levelToLoad:String = 'level0', ?PlayerPosition:Array<Float> = null, ?save:SaveState, ?saveSlot:Int = 1) {
		super();
		instance = this;
		this.saveSlot = saveSlot;
		_LEVEL = levelToLoad;
		// Test dialogue
		var dialogue:Dialogue = {
			strings: [
				{
					dialogueBox: {
						texPath: '',
						idleAnim: {
							name: 'idle',
							frame: [100, 70],
							looped: true,
							fps: 24,
							flipX: false,
							flipY: false
						},
						scaleX: 1,
						scaleY: 1,
						xOffset: 0,
						yOffset: 0
					},
					fontTex: '',
					charLeft: 'gilbert',
					charRight: 'chillbert',
					charCenter: '',
					speakingCharacters: ['gilbert'],
					sounds: [
						{
							voiceMode: 'perChar',
							soundPath: 'assets/sound/voices/gilbert/1.wav',
							volume: 1
						},
						{
							voiceMode: 'perChar',
							soundPath: 'assets/sound/voices/chillbert/1.wav',
							volume: 1
						}
					],
					text: [
						{
							autoplayNext: true,
							animsToPlay: [
								{
									charName: 'gilbert',
									animName: 'speak'
								},
								{
									charName: 'chillbert',
									animName: 'speak'
								}
							],
							speed: 1,
							text: 'I,',
							postTextPause: 1,
							format: {
								color: '0xFF000000',
								borderColor: '0xFF000000',
								underlined: false
							}
						},
						{
							autoplayNext: true,
							animsToPlay: [
								{
									charName: 'gilbert',
									animName: 'speak'
								},
								{
									charName: 'chillbert',
									animName: 'speak'
								}
							],
							speed: 1,
							text: 'AM,',
							postTextPause: 1,
							format: {
								color: '0xFF000000',
								borderColor: '0xFF000000',
								underlined: false
							}
						},
						{
							autoplayNext: true,
							animsToPlay: [
								{
									charName: 'gilbert',
									animName: 'yell'
								},
								{
									charName: 'chillbert',
									animName: 'yell'
								}
							],
							speed: 1,
							text: 'THE ONE!!!!!',
							postTextPause: 1,
							format: {
								color: '0xFFFF0000',
								borderColor: '0xFFFF0000',
								underlined: true
							}
						}
					]
				}
			],
			bgMusic: {
				songs: [
					{
						volume: 1,
						path: 'assets/sound/mus/WeightLess.ogg',
						looped: false
					}
				],
			},
			hscriptPath: ''
		};
		// Clipboard.text = TJSON.encode(dialogue, 'fancy'); //! SOLAR CAN YOU LIKE, NOT?!
		//* sorry, i was angry from a bug. but writing to my clipboard is annoying when i have code stored, because it overwrites the last result in clipboard history.
		// trace('JSON DIALOGUE: \n${TJSON.encode(dialogue, 'fancy')}');

		if (PlayerPosition == null)
			PlayerPosition = [0, 0, 0];

		Player = new Player(PlayerPosition[0], PlayerPosition[1], PlayerPosition[2], this);
		Player.Transitioning = false;
		if (save != null)
			loadSaveState(save);
	}

	public function loadSaveState(?state:SaveState) {
		if (state != null) {
			// health and stamina
			Player.Health = state.cur_health;
			Player.stamina = state.cur_stamina;
			Player.battery = state.cur_battery;
			// positioning
			Player.x = state.player_x;
			Player.y = state.player_y;
			Player.z = state.player_z;

			if (state.hassuit) {
				var suit:Suit = new Suit(null);
				suit.ps = this;
				items.push(suit);
				Player.suit = suit;
			}
			if (state.haspistol) {
				var pistol:Pistol = new Pistol(null);
				pistol.ps = this;
				pistol.ammoRemaining = state.pisremain;
				pistol.ammoCap = state.piscap;
				items.push(pistol);
				Player.weaponInventory.set(Player.weaponInventory.getNextFreeInIntMap(), pistol);
			}
			if (state.hasshotgun) {
				var shotgun:Shotgun = new Shotgun(null);
				shotgun.ps = this;
				shotgun.ammoRemaining = state.shtremain;
				shotgun.ammoCap = state.shtcap;
				items.push(shotgun);
				Player.weaponInventory.set(Player.weaponInventory.getNextFreeInIntMap(), shotgun);
			}
			if (state.hassmg) {
				var smg:SMG = new SMG(null);
				smg.ps = this;
				smg.ammoRemaining = state.smgremain;
				smg.ammoCap = state.smgcap;
				items.push(smg);
				Player.weaponInventory.set(Player.weaponInventory.getNextFreeInIntMap(), smg);
			}
			if (state.hasrifle) {
				var rifle:Rifle = new Rifle(null);
				rifle.ps = this;
				rifle.ammoRemaining = state.rifremain;
				rifle.ammoCap = state.rifcap;
				items.push(rifle);
				Player.weaponInventory.set(Player.weaponInventory.getNextFreeInIntMap(), rifle);
			}
			// other.
			// Player.hasSuit =;
		}
	}

	public function onWeaponPickup() {
		if(!Playstate.instance.Hud.bullets.visible)
			FlxTween.tween(Playstate.instance.Hud.bullets, {alpha: 1}, {ease: FlxEase.cubeInOut});
	}

	override public function create() {
		super.create();

		////RFLParser.LoadRFLData('TestRFL', '', 'TestFile');

		if (!FlxG.sound.music.playing) {
			FlxG.sound.playMusic(Assets.music('WeightLess.ogg'), 1, true);
		}

		BulletGroup = new FlxGroup();
		ShellGroup = new FlxGroup();

		FGCAM = new FlxCamera();
		FlxG.cameras.add(FGCAM, false);
		FGCAM.bgColor = 0x0011FF00;

		HUDCAM = new FlxCamera();
		FlxG.cameras.add(HUDCAM, false);
		HUDCAM.bgColor = 0x0011FF00;

		Hud = new HUD(this); // hud does get init, BUT doesnt actually show anything until you pickup the suit.
		Hud.cameras = [HUDCAM];
		Player2 = new Aimer(this);
		// Level = new Level(LevelLoader.ParseLevelData(RFLParser.LoadRFLData(_LEVEL, '', 'Level')), this);
		Player3 = new InteractionBox();
		Player3.scrollFactor.set();
		Player3.camera = HUDCAM;
		Level = new Level(RFLParser.LoadRFLData(Assets.asset('levels/$_LEVEL.rfl')), this);
		Level.EditorMode = false;
		Level.loadLevel();

		for (obj in Level.objects) {
			if (obj.doubleAxisCollide && !obj.isForegroundSprite)
				doubleAxisColliders.push(obj);
			if (obj.tripleAxisCollide && !obj.isForegroundSprite)
				tripleAxisColliders.push(obj);
		}
		Player.doubleAxisColliders = doubleAxisColliders;
		Player.tripleAxisColliders = tripleAxisColliders;

		add(Level);
		Level.layeringGrp.add(Player);
		Level.layeringGrp.add(Player2);
		add(Player3);
		add(AimerGroup);
		add(BulletGroup);
		add(ShellGroup);
		add(Hud);

		#if debug
			DebuggerHelper.createCustomPlayerTracker();
		#end

		isBeatStateType = Level.isBeatStage;
		BPM = Level.FrameTime;

		interval = (60 / BPM * BopsPerNumOfBeats);
	}

	override public function update(elapsed:Float) {
		#if debug
		DebuggerHelper.update(elapsed);

		FlxG.watch.addQuick('BPM', BPM);
		FlxG.watch.addQuick('interval', interval);
		FlxG.watch.addQuick('TriggerTime', nextTriggerTime);
		#end

		if(FlxG.keys.anyJustPressed([BACKSLASH])){
			if(!dying){
				FlxTween.tween(FlxG.camera.zoom, {"zoom": 0.1}, 2.6, {
					ease: FlxEase.expoIn,
					onComplete: function(twn:FlxTween){
						tweenOneDone = true;
					}
				});
				wait(0.5, ()->{
					FlxTween.tween(FlxG.camera.angle, {"angle": 90}, 1.6, {
						ease: FlxEase.expoOut,
						onComplete: function(twn:FlxTween){
							FlxG.camera.angle = 0;
							tweenTwoDone = true;
						}
					});
				});
				if(tweenOneDone && tweenTwoDone){
					FlxG.switchState(()-> new DeathState(this.saveSlot));
					trace('done');
				}
				dying = true;
			}
		}

		for(FlxSprite in ShellGroup){
			var Sprite = cast FlxSprite;
			if(Sprite.velocity.x > 0){
				Sprite.velocity.x--;
			}else if(Sprite.velocity.x < 0){
				Sprite.velocity.x++;
			}
			if(Sprite.velocity.y > 0){
				Sprite.velocity.y--;
			}else if(Sprite.velocity.y < 0){
				Sprite.velocity.y++;
			}
		}

		FlxG.mouse.visible = true;

		for (item in items)
			item.update(elapsed);

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
		if(!dying){
			if (!Level.CameraLocked) { // camera locking so we can have static rooms
				FlxG.camera.follow(Player, followStyle, Level.CameraLerp * elapsed);
				FGCAM.follow(Player, followStyle, Level.CameraLerp * elapsed);
			}
			if (FlxG.keys.anyPressed([PAGEUP]) && defaultCamZoom < 2) {
				defaultCamZoom += 0.05;
				FgCamDefaultZoom += 0.05;
			}
			if (FlxG.keys.anyPressed([PAGEDOWN]) && defaultCamZoom > 1) {
				defaultCamZoom -= 0.05;
				FgCamDefaultZoom -= 0.05;
			}
			if (defaultCamZoom > 2)
				defaultCamZoom = 2;
			if (FgCamDefaultZoom > 2)
				FgCamDefaultZoom = 2;

			if (defaultCamZoom < 1)
				defaultCamZoom = 1;
			if (FgCamDefaultZoom < 1)
				FgCamDefaultZoom = 1;

			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
			FGCAM.zoom = FlxMath.lerp(FgCamDefaultZoom, FGCAM.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
			HUDCAM.zoom = FlxMath.lerp(1, HUDCAM.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
		}

		Player.CurRoom = Level.LevelID;

		AimerGroup.update(elapsed); // you know, this might cause issues with animations :facepalm:
		AimerGroup.setPosition(Player2.x, Player2.y);
		
		Player3.setPosition(FlxG.mouse.viewX, FlxG.mouse.viewY);

		Playstate.instance.AimerGroup.angle = Player2.angle + 1;
		super.update(elapsed);
		//*health stuff

		//* camera bop stuff for the cool stages with bopping music
		if(!dying){
			if (isBeatStateType) {
				if (FlxG.sound.music != null) {
					FlxG.sound.music.onComplete = () -> {
						nextTriggerTime = 0;
					};
					if (FlxG.sound.music.time >= nextTriggerTime) {
						FlxG.camera.zoom += 0.01;
						FGCAM.zoom += 0.01;
						HUDCAM.zoom += 0.005;
						nextTriggerTime += interval;
					}
				}
			}
		}
        GameSave.saveState.loadSaveFieldsFromArray(PlayerSaveStateUtil.getSaveArray());
	}

	override public function destroy() {
		super.destroy();
		FGCAM.destroy();
		HUDCAM.destroy();
	}
}

class DeathState extends FlxState {
	//TODO: death screen
	//I HAVE AN IDEA!!!!!!!
	//okay, FUCK the current death screen idea of hte player simply dying, what iv we like take the ultrakill deathscreen with the static
	//and fov changes, do like do that but then it like shows a CRT shutoff animation, after that it like, shows a scanline setting with green
	//text that spells out with some typing sounds in the background ">| would you like to try again?" with like yes or no options
	//and if you press yes then it like, switches to a POV of your character waking up from a nap and commenting on the weird dream, IN-UNIVERS
	//EXPLANATION FOR SAVING AND LOADING!!!!!! ITS TWOFOLD!!!
	var deathText:FlxText;
	var deathText2:FlxText;
	var deathText3:FlxText;
	var bg:FlxSprite; // remember to make this into a semi-transparent version of whereever you are in the main playstate somehow.
	var deathanim:FlxSprite;
	var saveSlot:Int = 1;
	var deathAnimFinished:Bool = false;

	public function new(saveSlot:Int = 1,) {
		super();
		this.saveSlot = saveSlot;
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(50, 50, FlxColor.CYAN);
		add(bg);
		bg.screenCenter(XY);
		// bg.creategraphicfromscreenshotorseomthignidfk add function to create graphic from screenshot.

		//deathanim = new FlxSprite(0, 0);
		// TODO: create death animation.
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (deathAnimFinished) {
			if (FlxG.keys.anyPressed([ESCAPE])) {
				FlxG.switchState(MainMenu.new);
			}
			if (FlxG.keys.anyPressed([ANY]) && !FlxG.keys.anyPressed([ESCAPE])) {
				PlayerSaveStateUtil.LoadPlayerSaveState(saveSlot);
			}
		}
	}
}
