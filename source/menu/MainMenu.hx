package menu;

import flixel.math.FlxRandom;
import flixel.addons.transition.FlxTransitionableState;
import menu.intro.Star;
import backend.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import backend.Functions;
import backend.save.PlayerSaveStateUtil;
import objects.menu.Button;

class MainMenu extends FlxTransitionableState {
    var Title:FlxText;
    var Title2:FlxText;
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

    public var OutroText:Array<String> = ["Goodbye...", "Until our paths cross again", "Your fate is in your hands"];
    public var RandomNumber:Int;

    public static var instance:MainMenu; //because of variable instancing needing to be done for button disabling when in the chapter substate

    public function new() {
        super();
        instance = this;
    }

    override public function create() {
        super.create();
        //determin the outro message now.
        RandomNumber = new FlxRandom().int(0, OutroText.length - 1);

        planetCam = new FlxCamera(0, 0, 1280, 720, 1);
        planetCam.bgColor = 0x00000000;
        FlxG.cameras.add(planetCam, false);
        
        starCam = new FlxCamera(0, 0, 1280, 720, 1);
        starCam.bgColor = 0x00000000;
        FlxG.cameras.add(starCam, false);

        shipCam = new FlxCamera(0, 0, 1280, 720, 1);
        shipCam.bgColor = 0x00000000;
        FlxG.cameras.add(shipCam);

        verCam = new FlxCamera(0, 0, 1280, 720, 1);
        verCam.bgColor = 0x00000000;
        FlxG.cameras.add(verCam);

        shipCam.flash();
        if (!FlxG.sound.music.playing)
            FlxG.sound.playMusic(Assets.music('MENU.ogg'));
        //background
        planet = new FlxSprite(0, 200, 'assets/planet.png');
        planet.camera = planetCam;
        planet.scale.set(4, 4);
        planet.color = 0xC7C7C7;
        planet.x = (FlxG.width - planet.width/2)-100;
        add(planet);

        ship = new FlxSprite(0, 0, 'assets/ship.png');
        ship.setGraphicSize(1280, 720);
        ship.updateHitbox();
        ship.antialiasing = false;
        ship.camera = shipCam;
        add(ship);

        //menu title stuff.
        Title2 = new FlxText(0, 170, 0, "", 8, true);
        Title2.setFormat(null, 48, FlxColor.RED, CENTER, NONE, FlxColor.BLACK, true);
        Title2.text = "FAILED";
        Title2.screenCenter(X);
        Title2.x = Title2.x + 35;
        Title2.camera = shipCam;
        Title2.antialiasing = false;
        add(Title2);

        Title = new FlxText(0, 150, 0, "", 8, true);
        Title.setFormat(null, 48, FlxColor.BLUE, CENTER, NONE, FlxColor.BLACK, true);
        Title.text = "RELOCATION";
        Title.screenCenter(X);
        Title.x = Title.x + 35;
        Title.camera = shipCam;
        Title.antialiasing = false;
        add(Title);

        Suffix = new FlxText(0, 0, 0, "", 8, true);
        Suffix.setFormat(null, 24, FlxColor.YELLOW, CENTER, NONE, FlxColor.TRANSPARENT, true);
        Suffix.text = "TESTING VERSION";
        Suffix.camera = shipCam;
        Suffix.setPosition(Title.x + 250, Title.y - 10);
        Suffix.antialiasing = false;
        add(Suffix);

        //                      these should have been behind the buttons.              \\
        shipGlow = new FlxSprite(0, 0, 'assets/ship-glow.png');
        shipGlow.setGraphicSize(1280, 720);
        shipGlow.updateHitbox();
        shipGlow.antialiasing = false;
        shipGlow.camera = shipCam;
        add(shipGlow);

        shipGlow2 = new FlxSprite(0, 0, 'assets/ship-glow-front.png');
        shipGlow2.setGraphicSize(1280, 720);
        shipGlow2.updateHitbox();
        shipGlow2.antialiasing = false;
        shipGlow2.camera = shipCam;
        add(shipGlow2);

        //button handling
        Button_Play = new Button('New\nGame', 560, 280, Assets.image('ButtonTEST'), ()->{ FlxG.state.openSubState(new substates.ChapterSelectSubState(this)); }, 1, false);
        //Button_Play.DaButton.updateHitbox();
        Button_Play.updateTextPosition();
        Button_Play.camera = shipCam;
        add(Button_Play);

        Button_Load = new Button('Load\nGame', Button_Play.DaButton.x, Button_Play.DaButton.y + 85, Assets.image('ButtonTEST'), ()->{ PlayerSaveStateUtil.LoadPlayerSaveState(1); FlxG.sound.music.stop(); FlxG.sound.playMusic(Assets.music('IDLE.ogg'), 1, true); }, 1, false);
        //Button_Load.DaButton.updateHitbox();
        Button_Load.updateTextPosition();
        Button_Load.camera = shipCam;
        add(Button_Load);

        Button_Settings = new Button('Settings', Button_Load.DaButton.x + 250, Button_Load.DaButton.y + 10, Assets.image('ButtonTEST'),
        ()->{ FlxG.switchState(new menu.Settings()); }, 1, false);
        //Button_Settings.DaButton.updateHitbox();
        Button_Settings.updateTextPosition();
        Button_Settings.camera = shipCam;
        add(Button_Settings);

        Button_exit = new Button('Exit', Button_Settings.DaButton.x - 200, Button_Settings.DaButton.y + 75, Assets.image('ButtonTEST'),
        ()->{ 
            var black:FlxSprite = new FlxSprite(0, 0);
            black.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
            black.alpha = 0;
            add(black);
            var goodbye:FlxText = new FlxText(0, 0, 0, OutroText[RandomNumber], 24, true);
            goodbye.screenCenter(XY);
            add(goodbye);
            FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.smootherStepInOut});
            FlxTween.tween(goodbye, {alpha: 0}, 1, {ease: FlxEase.smootherStepInOut});
            FlxG.sound.music.fadeOut(1);
            wait(1, function() {
                Sys.exit(0); 
            });
        }, 1, false);
        //Button_Settings.DaButton.updateHitbox();
        Button_exit.updateTextPosition();
        Button_exit.camera = shipCam;
        add(Button_exit);

        var vingette = new FlxSprite(0, 0, 'assets/Vingette.png');
        vingette.alpha = 0.4;
        vingette.camera = shipCam;
        add(vingette);

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
        var LevelEditorButton:FlxButton = new FlxButton(0, 0, 'Level Editor', ()->{ FlxG.switchState( new debug.LevelEditorState() ); });
        add(LevelEditorButton);
        #end
    }

    override public function destroy()
    {
        super.destroy();
        FlxG.cameras.remove(starCam);
        FlxG.cameras.remove(shipCam);
        FlxG.cameras.remove(planetCam);
    }

    var _:Int = 0;
    override public function update(elapsed:Float) {
            super.update(elapsed);
            _++; _ %= 2; //let me guess, spawn stars on every other frame? --CS2020
            if (_ == 0){
                var star:Star = cast new Star(Std.int(FlxG.width/2), Std.int(FlxG.height/2) - 30, null, false, 2).makeGraphic(10, 10);
                star.cameras = [starCam];
                stars.push(star);
                add(star);
            }
            shipCam.shake(0.001, 1);
            if(FlxG.mouse.overlaps(Button_Play))
                {
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
                }
            else
                {
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

            if(FlxG.mouse.overlaps(Button_Load))
                {
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
                }
            else
                {
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

            if(FlxG.mouse.overlaps(Button_Settings))
                {
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
                }
            else
                {
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
            if(FlxG.mouse.overlaps(Button_exit))
                {
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
                }
            else
                {
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