package menu.intro;

import math.RFInterp;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class IntroState extends FlxState
{
    var stars:Array<Star> = [];
    public var starCam:FlxCamera;
    public var shipCam:FlxCamera;
    var ship:FlxSprite;
    var overlay:FlxSprite;
    var dur:Float = 0.8;
    var trail:Bool = false;
    var lerpWindow:Bool = false;
    var planet:FlxSprite;
    var pIndex:Int = 0;
    override public function create()
    {
        super.create();
        starCam = new FlxCamera(0, 0, 1280, 720, 0);
        starCam.bgColor = 0x00000000;
        FlxG.cameras.add(starCam, false);
        shipCam = new FlxCamera(0, 0, 1280, 720, 1.2);
        shipCam.bgColor = 0x00000000;
        FlxG.cameras.add(shipCam, false);
        var overlayCam = new FlxCamera(0, 0, 1280, 720, 0);
        overlayCam.bgColor = 0x00000000;
        FlxG.cameras.add(overlayCam, false);
        ship = new FlxSprite(-120, -30, 'assets/ship-off.png');
        ship.setGraphicSize(1280, 720);
        ship.updateHitbox();
        ship.antialiasing = false;
        ship.cameras = [shipCam];
        add(ship);
        overlay = new FlxSprite(0, 0).makeGraphic(1280, 720, FlxColor.BLACK);
        overlay.alpha = 1;
        overlay.cameras = [overlayCam];
        add(overlay);
        var vingette = new FlxSprite(0, 0, 'assets/Vingette.png');
        vingette.alpha = 0.7;
        vingette.cameras = [overlayCam];
        add(vingette);
        var overlayWhite = new FlxSprite(0, 0).makeGraphic(1280, 720);
        overlayWhite.alpha = 0;
        overlayWhite.cameras = [overlayCam];
        add(overlayWhite);
        var skipTxt = new FlxText(20, 665, 0, 'Press SPACE To skip.', 30);
        skipTxt.alpha = 0.4;
        skipTxt.camera = overlayCam;
        add(skipTxt);
        planet = new FlxSprite(0, 200, 'assets/planet.png');
        planet.alpha = 0;
        add(planet);
        pIndex = members.indexOf(planet);
        FlxG.camera.zoom = 1.2;
        FlxG.sound.playMusic('assets/sound/intro/1.wav', 1, false);
        FlxTween.tween(overlay, {alpha: 0}, 2, {ease: FlxEase.circIn, onComplete: (_) -> {
            FlxTween.tween(skipTxt, {alpha: 0}, 1);
            wait(2, () -> {
                FlxG.sound.music.stop();
                overlay.alpha = 1;
                dur = 0.5;
                wait(2, () -> {
                    FlxG.sound.playMusic('assets/sound/intro/2.wav', 1, false);
                    overlay.alpha = 0;
                    shipCam.shake(0.001, 2);
                    FlxG.camera.shake(0.001, 2);
                    planet.scale.set(0.2, 0.2);
                    planet.alpha = 0.4;
                    FlxTween.tween(planet, {'scale.x': 0.75, 'scale.y': 0.75, alpha: 0.7}, 2, {ease: FlxEase.circIn});
                    wait(2, () -> {
                        FlxG.sound.music.stop();
                        overlay.alpha = 1;
                        trail = true;
                        dur = 0.2;
                        wait(2, () -> {
                            FlxG.sound.playMusic('assets/sound/intro/3.wav', 1, false);
                            overlay.alpha = 0;
                            shipCam.shake(0.005, 2);
                            FlxG.camera.shake(0.005, 2);
                            planet.scale.set(1, 1);
                            planet.alpha = 1;
                            FlxTween.tween(planet, {'scale.x': 5, 'scale.y': 5}, 2, {ease: FlxEase.circIn});
                            wait(1, () -> {FlxTween.tween(overlayWhite, {alpha: 1});});
                            wait(2, () -> {
                                Application.current.window.borderless = false;
                                lerpWindow = true;
                                wait(2, () -> {
                                    FlxG.camera.zoom = 0;
                                    FlxG.sound.music.stop();
                                    FlxG.mouse.visible = true;
                                    FlxG.switchState(new WaterMarks());
                                });
                            });
                        });
                    });
                });
            });
        }});
    }

    override public function destroy()
    {
        super.destroy();
        FlxG.cameras.remove(starCam);
        FlxG.cameras.remove(shipCam);
    }

    var val = 0.0;
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.SPACE)
        {
            var window = Application.current.window;
            window.borderless = false;
            window.x = Std.int(WindowIntro.oldWindowPosition.x);
            window.y = Std.int(WindowIntro.oldWindowPosition.y);
            window.width = Std.int(WindowIntro.oldWindowDimensions.x);
            window.height = Std.int(WindowIntro.oldWindowDimensions.y);
            FlxG.camera.zoom = 0;
            FlxG.sound.music.stop();
            FlxG.mouse.visible = true;
            FlxG.switchState(new WaterMarks());
        }
        if (lerpWindow)
        {
            val += 0.02;
            var window = Application.current.window;
            window.x = Std.int(RFInterp.easedInterp(window.x, WindowIntro.oldWindowPosition.x, val, 'smootherStepInOut'));
            window.y = Std.int(RFInterp.easedInterp(window.y, WindowIntro.oldWindowPosition.y, val, 'smootherStepInOut'));
            window.width = Std.int(RFInterp.easedInterp(window.width, WindowIntro.oldWindowDimensions.x, val, 'smootherStepInOut'));
            window.height = Std.int(RFInterp.easedInterp(window.height, WindowIntro.oldWindowDimensions.y, val, 'smootherStepInOut'));
        }
        var star:Star = cast new Star(Std.int(FlxG.width/2), Std.int(FlxG.height/2) - 30, null, trail, dur).makeGraphic(10, 10);
        if (trail) {
            add(star.trail);
            star.trail.camera = starCam;
        }
        star.camera = starCam;
        stars.push(star);
        insert(pIndex - 1, star);
        planet.updateHitbox();
    }
}