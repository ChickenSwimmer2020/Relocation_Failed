package;

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
	public var Hud:HUD;
	public var Level:Level;
	public var colliders:Array<FlxSprite> = [];

	public var FGCAM:FlxCamera;
	public var HUDCAM:FlxCamera;

	public var followStyle:FlxCameraFollowStyle;

	public var _LEVEL:String;
	public var saveSlot:Int = 1;

	public var LevelTransitionFadeSprite:FlxSprite = new FlxSprite(0, 0);

	public var BulletGroup:FlxGroup;
	#if debug
	public var DebuggerHelper = new backend.DEBUGKEYS();
	#end

	public var isBeatStateType:Bool = false; //should camera bop
	public var curStep:Int = 0; //goes up every frame for the proper bopping
	public var FrameTime:Float = 0;
	public var defaultCamZoom:Float = 1;
	public var FgCamDefaultZoom:Float = 1;

	override public function new(levelToLoad:String = 'level1', ?PlayerPosition:Array<Float> = null, ?save:SaveState, ?saveSlot:Int = 1) {
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
                        path: 'assets/sound/mus/IDLE.ogg',
                        looped: false
                    }
                ],
            },
            hscriptPath: ''
        };
        Clipboard.text = TJSON.encode(dialogue, 'fancy');
        trace('JSON DIALOGUE: \n${TJSON.encode(dialogue, 'fancy')}');

		if (PlayerPosition == null)
			PlayerPosition = [0, 0];

		Player = new Player(PlayerPosition[0], PlayerPosition[1],
			this); // we need to init the player here or else its gonna cause a crash when attempting to load the save-state
		Player.Transitioning = false;

		loadSaveState(save);
	}

    function loadSaveState(?state:SaveState) {
        if (state != null) {
			// health and stamina
			Player.health = state.cur_health;
			Player.stamina = state.cur_stamina;
			Player.battery = state.cur_battery;
			// positioning
			Player.x = state.player_x;
			Player.y = state.player_y;
			// ammo stuff.
			Player.PistolAmmoCap = state.piscap;
			Player.PistolAmmoRemaining = state.pisremain;
			Player.ShotgunAmmoCap = state.shtcap;
			Player.ShotgunAmmoRemaining = state.shtremain;
			Player.RifleAmmoCap = state.rifcap;
			Player.RifleAmmoRemaining = state.rifremain;
			Player.SMGAmmoCap = state.smgcap;
			Player.SMGAmmoRemaining = state.smgremain;
			// other.
			// Player.hasSuit =;
			Player.hasPistol = state.haspistol;
			Player.hasShotgun = state.hasshotgun;
			Player.hasSMG = state.hassmg;
			Player.hasRifle = state.hasrifle;
		}
    }

	public function onItemPickup(?Item:String, ?Extra:Dynamic, ?Function:Void -> Void) {
		#if debug
		if(Item != null)
			trace('Item was picked up: $Item');
		else
			trace('Item was picked up: [NAME NOT PROVIDED]');
		#end
		if(Function != null) {
			Function();
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

		Hud = new HUD(this); //hud does get init, BUT doesnt actually show anything until you pickup the suit.
		Hud.cameras = [HUDCAM];
		Player2 = new Aimer();
		Level = new Level(LevelLoader.ParseLevelData(Assets.asset('$_LEVEL.json')));
		Level.EditorMode = false;
		Level.loadLevel();

		for (obj in Level.objects)
			if (obj.isCollider && !obj.isForeGroundSprite)
				colliders.push(obj);
		Player.colliders = colliders;

		add(Level);
		add(Player);
		add(Player2);
		add(AimerGroup);
		add(BulletGroup);
		add(Hud);

		isBeatStateType = Level.isBeatStage;
		FrameTime = Level.FrameTime;
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

		Player.CurRoom = Level.LevelID;

        AimerGroup.update(elapsed); //you know, this might cause issues with animations :facepalm:
		AimerGroup.setPosition(Player2.x, Player2.y);
		Playstate.instance.AimerGroup.angle = Player2.angle + 1;
		super.update(elapsed);
		FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
		FGCAM.zoom = FlxMath.lerp(FgCamDefaultZoom, FGCAM.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
		HUDCAM.zoom = FlxMath.lerp(1, HUDCAM.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
		//*health stuff

		//* camera bop stuff for the cool stages with bopping music
		if(isBeatStateType) {
			curStep++; //curStep is the current frame.
			if(curStep % FrameTime == 0) {
				FlxG.camera.zoom += 0.02;
				FGCAM.zoom += 0.02;
				HUDCAM.zoom += 0.01;
			}
		}
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
    var saveSlot:Int = 1;

	public function new(saveSlot:Int = 1) {
		super();
        this.saveSlot = saveSlot;
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
            PlayerSaveStateUtil.LoadPlayerSaveState(saveSlot);
        }
    }
}
