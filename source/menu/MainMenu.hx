package menu;

import flixel.ui.FlxButton.FlxButtonState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.addons.transition.FlxTransitionableState;
import menu.intro.Star;
import backend.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import backend.Functions;
import backend.save.PlayerSaveStateUtil;
import objects.menu.Button;

class MainMenu extends FlxState {
	var Title:FlxSprite;
	var Suffix:FlxText;

	var versiontext:FlxText;
	var platformText:FlxText;
	var curPlatform:String;

	var Button_Play:Button;
	var Button_Load:Button;
	var Button_Settings:Button;
	var Button_exit:Button;

	var stars:Array<Star> = [];
	var shipCam:FlxCamera;
	var starCam:FlxCamera;
	var planetCam:FlxCamera;
	var verCam:FlxCamera;
	var ship:FlxSprite;
	var planet:FlxSprite;
	var shipGlow:FlxSprite;
	var shipGlow2:FlxSprite;

	public var OutroText:Array<String> = [
		"", //* blank (DONT TOUCH ITS FOR THE SECRET MESSAGE)
		"\"I should rest for a while...\"",
		"\"I need to sit down...\"",
		"\"Maybe I can sleep...\"",
		"\"A safe place at last...\"",
		"\"What I wouldnt do for some BurritoAlarm...\"",
		"\"What I wouldnt do for some McGunalds...\"",
	];
	public var SecretOutro:String = "HotDog Water";
	public var RandomNumber:Int;

	public static var instance:MainMenu; // because of variable instancing needing to be done for button disabling when in the chapter substate

	public function new() {
		super();
		instance = this;
	}

	override public function create() {
		super.create();
		


		// determine the outro message now.
		RandomNumber = new FlxRandom().int(0, OutroText.length - 1);

		planetCam = new FlxCamera(0, 0, 1280, 720, 1);
		planetCam.bgColor = 0x00000000;
		FlxG.cameras.add(planetCam, false);

		starCam = new FlxCamera(0, 0, 1280, 720, 1);
		starCam.bgColor = 0x00000000;
		FlxG.cameras.add(starCam, false);

		shipCam = new FlxCamera(0, 0, 1280, 720, 1);
		shipCam.bgColor = 0x00000000;
		FlxG.cameras.add(shipCam, true);

		verCam = new FlxCamera(0, 0, 1280, 720, 1);
		verCam.bgColor = 0x00000000;
		FlxG.cameras.add(verCam, false);
		
		if(FlxG.sound.music == null){
			FlxG.sound.playMusic(Assets.music('ConnectionEstablished.ogg'));
		}else{
			if(!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Assets.music('ConnectionEstablished.ogg'));
		}
		
		// background
		planet = new FlxSprite(0, 200, 'assets/menu/planet.png');
		planet.camera = planetCam;
		planet.scale.set(4, 4);
		planet.color = 0xC7C7C7;
		planet.x = (FlxG.width - planet.width / 2) - 100;
		add(planet);

		ship = new FlxSprite(0, 0, 'assets/menu/ship.png');
		ship.setGraphicSize(1280, 720);
		ship.updateHitbox();
		ship.antialiasing = false;
		ship.camera = shipCam;
		add(ship);

        var vingette = new FlxSprite(0, 0, 'assets/menu/Vingette.png'); //* shouldnt be infront of things that glow, should it?
        vingette.alpha = 0.4;
        vingette.camera = verCam; //so it doesnt shake
        add(vingette);

        //menu title stuff.
        Title = new FlxSprite(0, 100).loadGraphic(Assets.image('menu/logo'));
        Title.scale.set(0.5,0.5);
        Title.updateHitbox();
        Title.screenCenter(X);
        Title.x = Title.x += 33;
        Title.camera = verCam;
        Title.antialiasing = false;
        add(Title);

        Suffix = new FlxText(0, 0, 0, "", 8, true);
        Suffix.setFormat(null, 24, FlxColor.YELLOW, CENTER, NONE, FlxColor.TRANSPARENT, true);
        Suffix.text = "TESTING VERSION";
        Suffix.camera = verCam;
        Suffix.setPosition(Title.x + 250, Title.y + 100);
        Suffix.antialiasing = false;
        add(Suffix);

        //                      these should have been behind the buttons.                           \\
        shipGlow = new FlxSprite(0, 0, 'assets/menu/ship-glow.png');
        shipGlow.setGraphicSize(1280, 720);
        shipGlow.updateHitbox();
        shipGlow.antialiasing = false;
        shipGlow.camera = verCam;
        add(shipGlow);

        shipGlow2 = new FlxSprite(0, 0, 'assets/menu/ship-glow-front.png');
        shipGlow2.setGraphicSize(1280, 720);
        shipGlow2.updateHitbox();
        shipGlow2.antialiasing = false;
        shipGlow2.camera = verCam;
        add(shipGlow2);

        //button handling
        Button_Play = new Button('New\nGame', 560, 280, Assets.image('menu/ButtonTEST'), ()->{
			var black:FlxSprite = new FlxSprite(0, 0);
			black.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			black.alpha = 0;
			add(black);
			black.camera = verCam;
			FlxTween.tween(black, {alpha: 1}, 1, { onComplete: function(twn:FlxTween) {
				FlxG.switchState(()->new Playstate.IntroState('assets/intro.lor'));
			}});
		}, 1, false);
        Button_Play.updateTextPosition();
        Button_Play.camera = verCam;
        add(Button_Play);

        Button_Load = new Button('Load\nGame', Button_Play.DaButton.x, Button_Play.DaButton.y + 85, Assets.image('menu/ButtonTEST'), ()->{ PlayerSaveStateUtil.LoadPlayerSaveState(1); FlxG.sound.music.stop(); FlxG.sound.playMusic(Assets.music('WeightLess.ogg'), 1, true); }, 1, false);
        Button_Load.updateTextPosition();
        Button_Load.camera = verCam;
        add(Button_Load);

        Button_Settings = new Button('Settings', Button_Load.DaButton.x + 250, Button_Load.DaButton.y + 10, Assets.image('menu/ButtonTEST'),
        ()->{ openSubState(new substates.DialogueSubState()); }, 1, false);
        Button_Settings.updateTextPosition();
        Button_Settings.camera = verCam;
        add(Button_Settings);

		Button_exit = new Button('Exit', Button_Settings.DaButton.x - 200, Button_Settings.DaButton.y + 75, Assets.image('menu/ButtonTEST'), () -> {
			var black:FlxSprite = new FlxSprite(0, 0);
			black.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			black.alpha = 0;
			add(black);
			var TheOutero:String = '';
			var FadeOutTime:Int = 1;

            if(RandomNumber == 0)   {
                TheOutero = SecretOutro;
                FadeOutTime = 5;
            }else{
                TheOutero = OutroText[RandomNumber];
                FadeOutTime = 1;
            }
            
            var goodbye:FlxText = new FlxText(0, 0, 0, TheOutero, 24, true);
            goodbye.screenCenter(XY);
            add(goodbye);
            FlxTween.tween(black, {alpha: 1}, FadeOutTime, {ease: FlxEase.smootherStepInOut});
            FlxG.sound.music.fadeOut(FadeOutTime);
            wait(FadeOutTime, function() {
                Sys.exit(0); 
            });
        }, 1, false);
        //Button_Settings.DaButton.updateHitbox();
        Button_exit.updateTextPosition();
        Button_exit.camera = verCam;
        add(Button_exit);

		platformText = new FlxText(0, 690, 0, "", 8, true);
		platformText.setFormat(null, 24, FlxColor.WHITE, LEFT, NONE, FlxColor.TRANSPARENT, true);
		platformText.text = Functions.GetPlatform();
		platformText.antialiasing = false;
		platformText.camera = verCam;
		add(platformText);

		versiontext = new FlxText(0, 665, 0, "", 8, true);
		versiontext.setFormat(null, 24, FlxColor.WHITE, LEFT, NONE, FlxColor.TRANSPARENT, true);
		versiontext.text = "V " + Application.current.meta.get('version');
		versiontext.antialiasing = false;
		versiontext.camera = verCam;
		add(versiontext);

        #if (debug || modded)
        var LevelEditorButton:FlxButton = new FlxButton(1200, 0, 'Editor', ()->{ FlxG.switchState(()->new debug.ChooseEditor()); });
        var ModViewerButton:FlxButton = new FlxButton(1200, 20, 'mods', ()->{ FlxG.switchState(modding.ModViewerState.new); });
        add(LevelEditorButton);
        LevelEditorButton.camera = verCam;
        add(ModViewerButton);
        ModViewerButton.camera = verCam;
		//ModViewerButton.status = FlxButtonState.DISABLED; //! MENU BROKEN. DO NOT USE.
        #end

        if(FlxG.save.data.seenFlashWarning != null && FlxG.save.data.seenFlashWarning != true) { 
            FlashWarn();
			#if !debug
         		FlxG.save.data.seenFlashWarning = true;
			#end
        }else{
            trace('Player has seen flash warning. not showing');
        }
    }

    override public function destroy()
    {
        super.destroy();
        FlxG.cameras.remove(starCam);
        FlxG.cameras.remove(shipCam);
        FlxG.cameras.remove(planetCam);
        FlxG.cameras.remove(verCam); //you forgot to remove this on state destory, solar. --ChickenSwimmer2020
    }

	public function FlashWarn() { //* we use this to create the falshing lights warning, since we're obviously going to want to add a feature to disable them, so we can get more players and accessibility!
		var WarnGroup:FlxSpriteGroup = new FlxSpriteGroup(0, 0, 0);
		add(WarnGroup);
		var BlackBox:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width + 50, FlxG.height + 50, FlxColor.BLACK);
		WarnGroup.add(BlackBox);

		var WarningText:FlxText = new FlxText(0, 0, 0, "", 24, true);
		WarningText.setFormat(null, 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		#if !debug
		WarningText.text = 'This game has flashing lights.\nif you are: epileptic, or photosensitive.\nplease navigate to the settings menu and disable them.\nthank you for enjoying our game!\n\n\nThis message will not show again';
		#else
		WarningText.text = 'This game has flashing lights.\nif you are: epileptic, or photosensitive.\nplease navigate to the settings menu and disable them.\nthank you for enjoying our game!\n\n\nThis message will not show again\n(not really, this is a debug build)';
		#end
		WarningText.screenCenter(XY);
		WarnGroup.add(WarningText);

		var Warn:FlxText = new FlxText(0, 0, 0, "", 24, true);
		Warn.setFormat(null, 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		Warn.text = 'Warning';
		Warn.screenCenter(X);
		Warn.y += 50;
		WarnGroup.add(Warn);

		var CloseButton:FlxButton = new FlxButton(1200, 700, "Ok", () -> {
			FlxTween.tween(WarnGroup, {alpha: 0}, 1, {
				ease: FlxEase.sineInOut,
				onComplete: function(twn:FlxTween) {
					WarnGroup.kill();
				}
			});
		});
		CloseButton.alpha = 0;
		WarnGroup.add(CloseButton);

        var SettingsButt:FlxButton = new FlxButton(CloseButton.x - 80, CloseButton.y, "Settings", ()->{ FlxG.state.openSubState(new menu.SettingsSubState(this)); WarnGroup.kill(); });
        SettingsButt.alpha = 0;
        WarnGroup.add(SettingsButt);

        wait(2, ()->{
            FlxTween.tween(CloseButton, {alpha: 1}, 1, { ease: FlxEase.sineInOut });
            FlxTween.tween(SettingsButt, {alpha: 1}, 1, { ease: FlxEase.sineInOut });
        });
    }

	var _:Int = 0;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		_++;
		_ %= 2; // let me guess, spawn stars on every other frame? --CS2020
		// yeah, you got it. --ZSolarDev
		FlxG.mouse.visible = true;
		if (_ == 0) {
			var star:Star = cast new Star(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2) - 30, null, false, 2).makeGraphic(10, 10);
			star.cameras = [starCam];
			stars.push(star);
			add(star);
		}
		if(FlxG.save.data.ScreenShake != null && FlxG.save.data.ScreenShake == true) {
			shipCam.shake(0.001, 1);
		}
		if (FlxG.mouse.overlaps(Button_Play)) {
			FlxTween.cancelTweensOf(Button_Play.DaButton);
			FlxTween.cancelTweensOf(Button_Play.DaText);
			Button_Play.Hover = true;
			Button_Play.updateTextPosition();
			FlxTween.tween(Button_Play.DaButton, {"scale.x": 0.8, "scale.y": 0.8, x: 585}, 0.5, {
				ease: FlxEase.circOut
			});
			FlxTween.tween(Button_Play.DaText, {"scale.x": 0.8, "scale.y": 0.8}, 0.5, {
				ease: FlxEase.circOut
			});
		} else {
			FlxTween.cancelTweensOf(Button_Play.DaButton);
			FlxTween.cancelTweensOf(Button_Play.DaText);
			Button_Play.Hover = false;
			Button_Play.updateTextPosition();
			FlxTween.tween(Button_Play.DaButton, {"scale.x": 0.6, "scale.y": 0.6, x: 600}, 0.5, {
				ease: FlxEase.circOut
			});
			FlxTween.tween(Button_Play.DaText, {"scale.x": 0.6, "scale.y": 0.6}, 0.5, {
				ease: FlxEase.circOut
			});
		}

		if (FlxG.mouse.overlaps(Button_Load)) {
			FlxTween.cancelTweensOf(Button_Load.DaButton);
			FlxTween.cancelTweensOf(Button_Load.DaText);
			Button_Load.Hover = true;
			Button_Load.updateTextPosition();
			FlxTween.tween(Button_Load.DaButton, {"scale.x": 0.8, "scale.y": 0.8, x: 585}, 0.5, {
				ease: FlxEase.circOut
			});
			FlxTween.tween(Button_Load.DaText, {"scale.x": 0.8, "scale.y": 0.8}, 0.5, {
				ease: FlxEase.circOut
			});
		} else {
			FlxTween.cancelTweensOf(Button_Load.DaButton);
			FlxTween.cancelTweensOf(Button_Load.DaText);
			Button_Load.Hover = false;
			Button_Load.updateTextPosition();
			FlxTween.tween(Button_Load.DaButton, {"scale.x": 0.6, "scale.y": 0.6, x: 600}, 0.5, {
				ease: FlxEase.circOut
			});
			FlxTween.tween(Button_Load.DaText, {"scale.x": 0.6, "scale.y": 0.6}, 0.5, {
				ease: FlxEase.circOut
			});
		}

		if (FlxG.mouse.overlaps(Button_Settings)) {
			FlxTween.cancelTweensOf(Button_Settings.DaButton);
			FlxTween.cancelTweensOf(Button_Settings.DaText);
			Button_Settings.Hover = true;
			FlxTween.tween(Button_Settings.DaButton, {"scale.x": 0.8, "scale.y": 0.8}, 0.5, {
				ease: FlxEase.circOut
			});
			Button_Settings.updateTextPosition();
			FlxTween.tween(Button_Settings.DaText, {"scale.x": 0.8, "scale.y": 0.8}, 0.5, {
				ease: FlxEase.circOut
			});
		} else {
			FlxTween.cancelTweensOf(Button_Settings.DaButton);
			FlxTween.cancelTweensOf(Button_Settings.DaText);
			Button_Settings.Hover = false;
			Button_Settings.updateTextPosition();
			FlxTween.tween(Button_Settings.DaButton, {"scale.x": 0.6, "scale.y": 0.6, x: 770}, 0.5, {
				ease: FlxEase.circOut
			});
			FlxTween.tween(Button_Settings.DaText, {"scale.x": 0.6, "scale.y": 0.6}, 0.5, {
				ease: FlxEase.circOut
			});
		}
		if (FlxG.mouse.overlaps(Button_exit)) {
			FlxTween.cancelTweensOf(Button_exit.DaButton);
			FlxTween.cancelTweensOf(Button_exit.DaText);
			Button_exit.Hover = true;
			FlxTween.tween(Button_exit.DaButton, {"scale.x": 0.6, "scale.y": 0.6}, 0.5, {
				ease: FlxEase.circOut
			});
			Button_exit.updateTextPosition();
			FlxTween.tween(Button_exit.DaText, {"scale.x": 0.6, "scale.y": 0.6}, 0.5, {
				ease: FlxEase.circOut
			});
		} else {
			FlxTween.cancelTweensOf(Button_exit.DaButton);
			FlxTween.cancelTweensOf(Button_exit.DaText);
			Button_exit.Hover = false;
			Button_exit.updateTextPosition();
			FlxTween.tween(Button_exit.DaButton, {"scale.x": 0.5, "scale.y": 0.5, x: 770}, 0.5, {
				ease: FlxEase.circOut
			});
			FlxTween.tween(Button_exit.DaText, {"scale.x": 0.5, "scale.y": 0.5}, 0.5, {
				ease: FlxEase.circOut
			});
		}
	}
}
