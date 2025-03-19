package;

import shaders.DeathBinary.BinaryShader;
import openfl.filters.ShaderFilter;
import shaders.DeathStatic.StaticShader;
import flixel.effects.FlxFlicker;
import crash.FlxTypeText;
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
	public var activlyDying:Bool = false;
	var tweenOneDone:Bool = false;
	var tweenTwoDone:Bool = false;

	//var staticShader:StaticShader;
	var binary:BinaryShader;
	//var filter:ShaderFilter;
	var filter2:ShaderFilter;

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

		//staticShader = new StaticShader();
		binary = new BinaryShader();
		//filter = new ShaderFilter(staticShader);
		filter2 = new ShaderFilter(binary);

		FlxG.mouse.visible = true; //* why was this being called in onUpdate(elapsed:Float)?

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

		for(object in Playstate.instance.members){
			if(Std.isOfType(object, FlxSprite)){
				var obj:FlxSprite = cast object;
				if(!obj.isOnScreen()){
					if(obj.visible)
						obj.visible = false;
				}else{
					if(!obj.visible)
						obj.visible = true;
				}
			}
		}

		if(#if debug FlxG.keys.anyJustPressed([BACKSLASH]) #else null #end){ //! replace with real death logic when applicable
			if(!dying){
				binary.createPixels();
				FlxG.camera.filters = [/*filter,*/filter2];
				FlxG.camera.zoom += 2;
				HUDCAM.zoom += 2;
				FGCAM.zoom += 2;
				FlxG.camera.shake(0.005, 0.4);
				HUDCAM.shake(0.005, 0.4);
				FGCAM.shake(0.005, 0.4);
				wait(0.4, ()->{
					FlxG.camera.shake(0.0025, 0.4);
					HUDCAM.shake(0.0025, 0.4);
					FGCAM.shake(0.0025, 0.4);
					wait(0.4, ()->{
						FlxG.camera.shake(0.001, 0.4);
						HUDCAM.shake(0.001, 0.4);
						FGCAM.shake(0.001, 0.4);
					});
				});
				if(Player.suit != null){
					FlxTween.tween(Hud.StatMSGContainer, {alpha: 0}, 0.4, { ease: FlxEase.expoIn });
					wait(0.4, ()->{
						FlxTween.tween(HUDCAM, {y: -60}, 0.2, { ease: FlxEase.expoIn });
					});
				}
				wait(0.6, ()->{
					activlyDying = true;
					FlxG.sound.music.fadeOut(1.5, 0, function(snd:FlxTween) { FlxG.sound.music.stop(); });
					FlxG.sound.play(backend.Assets.sound('death.ogg'), 1, false);
					FlxTween.tween(FlxG.camera, {zoom: 0.001}, 1.6, { //* why dont these tweens work? //IM SUCH A DUMBASS I PUT `FlxG.camera.zoom` AS THE TARGETTED OBJECT :sob:
						ease: FlxEase.expoIn,
						type: ONESHOT,
						onComplete: function(twn:FlxTween){
							tweenOneDone = true;
						}
					});
					FlxTween.tween(FGCAM, {zoom: 0.001}, 1.6, {
					ease: FlxEase.expoIn,
					type: ONESHOT,
					});
					wait(1, ()->{
						FlxTween.tween(FlxG.camera, {angle: 90}, 0.6, {
							ease: FlxEase.expoIn,
							type: ONESHOT,
							onComplete: function(twn2:FlxTween){
								FlxG.camera.angle = 0;
								FlxG.switchState(()-> new DeathState(this.saveSlot));
							}
						});
						FlxTween.tween(FGCAM, {angle: 90}, 0.6, { //forground camera because that also needs to be moved
							ease: FlxEase.expoIn,
							type: ONESHOT,
							onComplete: function(twn2:FlxTween){
								FGCAM.angle = 0;
							}
						});
					});
				});
			}
			dying = true;
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
		for (item in items){
			item.update(elapsed);
			//if(Std.isOfType(item, BaseItem)){ //TODO: item logic to hide it offscreen, hard to do since BaseItem is a FlxBasic
			//	var itm:FlxBasic = cast item;
//
			//}
		}

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


		}
		if(!activlyDying){
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
			FGCAM.zoom = FlxMath.lerp(FgCamDefaultZoom, FGCAM.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
			HUDCAM.zoom = FlxMath.lerp(1, HUDCAM.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
		}

		Player.CurRoom = Level.LevelID;

		AimerGroup.update(elapsed); // you know, this might cause issues with animations :facepalm:
		AimerGroup.setPosition(Player2.x, Player2.y);
		
		Player3.setPosition(FlxG.mouse.gameX, FlxG.mouse.gameY);

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
	//I HAVE AN IDEA!!!!!!!
	//okay, FUCK the current death screen idea of the player simply dying, what if we like take the ultrakill deathscreen with the static
	//and fov changes, do like do that but then it like shows a CRT shutoff animation, after that it like, shows a scanline setting with green
	//text that spells out with some typing sounds in the background ">| would you like to try again?" with like yes or no options
	//and if you press yes then it like, switches to a POV of your character waking up from a nap and commenting on the weird dream, IN-UNIVERS
	//EXPLANATION FOR SAVING AND LOADING!!!!!! ITS TWOFOLD!!!
	var deathanim:FlxSprite;
	var saveSlot:Int = 1;
	var deathAnimFinished:Bool = false;

	var bg:FlxSprite;
	var bg2:FlxSprite;

	var text:String = 'Would you like to try again?';
	var	Msg:FlxTypeText;

	var text1:FlxText;
	var text3:FlxText;
	var text2:FlxText;

	public var BPM:Float = 90;
	public var nextTriggerTime:Float = 0;
	public var interval:Float;
	public var BopsPerNumOfBeats:Int = 1000;

	public var leaving:Bool = false;
	public var canBop:Bool = false;

	public function new(saveSlot:Int = 1,) {
		super();
		this.saveSlot = saveSlot;
		bg = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xFF000000, 0xFF630000], 1, 90);
		add(bg);
		bg2 = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xFF000000, 0xFF00FF00], 1, 90);
		add(bg2);
		bg.y = 720;
		bg2.visible = false;

		Msg = new FlxTypeText(470, 500, 1000, text, 24);
		Msg.font = Assets.font('terminus');
		var sound:Array<flixel.sound.FlxSound> = [];
		for(i in 0...4){
			sound.push(FlxG.sound.load(backend.Assets.sound('clicks/click$i.ogg')));
		}
		Msg.sounds = sound;
		Msg.color = 0xFFFFFFFF;
		add(Msg);
		Msg.cursorCharacter = '█';
		Msg.showCursor = false;
		Msg.txtPerFrame = 1;
		Msg.cursorBlinkSpeed = 0.2;


		text1 = new FlxText(0, 0, FlxG.width, 'RECONNECTING', 86, false);
		text1.setFormat(backend.Assets.font('terminus'), 86, FlxColor.WHITE, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		text1.screenCenter(Y);

		text3 = new FlxText(900, text1.y, 500, '', 86, false);
		text3.setFormat(backend.Assets.font('terminus'), 86, FlxColor.WHITE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);

		text2 = new FlxText(0, 0, FlxG.width, '', 74, false);
		text2.setFormat(backend.Assets.font('terminus'), 74, FlxColor.WHITE, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		text2.y = text1.y + 58;

		add(text1);
		add(text2);
		add(text3);
		
		wait(0, ()->{
			text3.text = '';
			wait(0.4, ()->{
				text3.text = '.';
				wait(0.4, ()->{
					text3.text = '..';
					wait(0.4, ()->{
						text3.text = '...';
						wait(0.4, ()->{
							text3.text = '.';
							wait(0.4, ()->{
								text3.text = '..';
								wait(0.4, ()->{
									text3.text = '...';
								});
							});
						});
					});
				});
			});
		});

		wait(2.7, ()->{
			text3.visible = false;
			text1.setFormat(backend.Assets.font('terminus'), 86, FlxColor.WHITE, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
			text1.text = 'CONNECTION';

			text2.setFormat(backend.Assets.font('terminus'), 74, FlxColor.RED, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
			text2.text = 'FAILED';
			canBop = true;
			FlxG.sound.playMusic(backend.Assets.music('Miscalculation.ogg'), 1, true);
			FlxFlicker.flicker(text2, 4, 0.5, true, false);
			FlxTween.tween(bg, {y: 100}, 0.5, { ease: FlxEase.expoOut });
			wait(4.5, ()->{
				Msg.showCursor = true;
				wait(2, ()->{
					Msg.start();
					wait(2, ()->{ Msg.showCursor = false; });
				});
			});
		});


		wait(10, ()->{
			deathAnimFinished = true;
		});
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		interval = (60 / BPM * BopsPerNumOfBeats);
		if(!leaving){
			FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
		}
		if (deathAnimFinished) {
			if (FlxG.keys.anyPressed([ESCAPE])) {
				deathAnimFinished = false; //* shitty way of blocking input once you press a button, but it works so what do i care
				leaving = true;
				canBop = false;
				FlxG.sound.music.fadeOut(2);
				text1.y = text1.y - 25;
				text2.y = text2.y + 5;
				FlxTween.tween(FlxG.camera, {zoom: 0.001}, 1.6, {
					ease: FlxEase.expoIn,
				});
				FlxTween.tween(FlxG.camera, {alpha: 0}, 1.6, {
					ease: FlxEase.expoIn,
				});
				FlxTween.tween(bg, {y: 720}, 0.5, { ease: FlxEase.expoIn, onComplete: function(twn:FlxTween) { bg.visible = false; }});
				FlxFlicker.stopFlickering(text2);
				Msg.visible = false;
				text2.text = 'EXCLUSIONS LIST';
				#if windows
				text1.text = '[signal.${Sys.environment()["COMPUTERNAME"]}] ADDED TO';
				#elseif linux
				text1.text = '[signal.${Sys.environment()["USER"]}] ADDED TO';
				#end
				wait(2, ()->{
					FlxG.sound.music.stop();
					FlxG.switchState(MainMenu.new);
				});
			}
			if (FlxG.keys.anyPressed([SPACE, ENTER]) && !FlxG.keys.anyPressed([ESCAPE])) {
				deathAnimFinished = false;
				FlxFlicker.stopFlickering(text2);
				bg.visible = false;
				bg2.visible = true;
				FlxG.camera.shake(0.005, 0.4);
				wait(0.4, ()->{
					FlxG.camera.shake(0.0025, 0.4);
					wait(0.4, ()->{
						FlxG.camera.shake(0.001, 0.4);
					});
				});
				text2.visible = false;
				text1.text = 'RETRYING';
				text1.color = 0xFF00FF00;
				text3.x = 800;
				text3.visible = true;
				Msg.visible = false;
				text3.color = 0xFF00FF00;
				wait(0, ()->{
					text3.text = '';
					wait(0.4, ()->{
						text3.text = '.';
						wait(0.4, ()->{
							text3.text = '..';
							wait(0.4, ()->{
								text3.text = '...';
								wait(0.4, ()->{
									text3.text = '.';
									wait(0.4, ()->{
										text3.text = '..';
										wait(0.4, ()->{
											text3.text = '...';
										});
									});
								});
							});
						});
					});
				});
				FlxG.sound.music.fadeOut(2.3);
				wait(2.3, ()->{
					FlxTween.tween(FlxG.camera, {alpha: 0}, 0.2, { ease: FlxEase.expoIn, onComplete: function (twn:FlxTween) {
						wait(0.2, ()->{
							FlxG.sound.music.stop();
							PlayerSaveStateUtil.LoadPlayerSaveState(saveSlot);
						});
					}});
				});
			}
		}
		//hehe, cool bopping :wink:
		if(canBop){
			if (FlxG.sound.music != null) {
				FlxG.sound.music.onComplete = () -> {
					nextTriggerTime = 0;
				};
				if (FlxG.sound.music.time >= nextTriggerTime && canBop) {
					FlxG.camera.zoom += 0.02;
					bg.y = 0;
					FlxTween.tween(bg, {y:100}, 0.5, { ease: FlxEase.expoOut });
					nextTriggerTime += interval;
				}
			}
		}
	}
}
