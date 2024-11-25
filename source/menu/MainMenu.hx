package menu;

import backend.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import backend.Functions;
import backend.Button;
import flixel.addons.display.FlxBackdrop;


class MainMenu extends FlxState {
    var Title:FlxText;
    var Suffix:FlxText;

    var versiontext:FlxText;
    var platFormText:FlxText;
    var curPlatform:String;

    var Button_Play:Button;
    var Button_Settings:Button;

    var BG:FlxBackdrop;

    

    override public function create() {
        //background
        BG = new FlxBackdrop(Assets.image('MainMenuBGSKY'), XY, 0, 0);
        BG.velocity.x = -100;
        add(BG);

        //menu title stuff.
        Title = new FlxText(0, 0, 0, "", 8, true);
        Title.setFormat(null, 48, FlxColor.BLUE, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        Title.text = "RELOCATION FAILED";
        Title.screenCenter(X);
        Title.antialiasing = false;
        add(Title);

        Suffix = new FlxText(0, 0, 0, "", 8, true);
        Suffix.setFormat(null, 24, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        Suffix.text = "TESTING VERSION";
        Suffix.setPosition(Title.x + 250, 50);
        Suffix.antialiasing = false;
        add(Suffix);

        platFormText = new FlxText(0, 680, 0, "", 8, true);
        platFormText.setFormat(null, 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        platFormText.text = Functions.GetPlatform();
        platFormText.antialiasing = false;
        platFormText.scale.set(1.5,1.5);
        platFormText.updateHitbox();
        add(platFormText);

        versiontext = new FlxText(0, 700, 0, "", 8, true);
        versiontext.setFormat(null, 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        versiontext.text = "V " + Application.current.meta.get('version');
        versiontext.antialiasing = false;
        versiontext.scale.set(1.5,1.5);
        versiontext.updateHitbox();
        add(versiontext);

        //buttons handling
        Button_Play = new Button(600, 360, Assets.image('ButtonTEST'), ()->{ Functions.DoButtonShtuff('Play'); }, 1, false);
        add(Button_Play);
        Button_Play.screenCenter(XY);

        Button_Settings = new Button(Button_Play.x, Button_Play.y + 160, Assets.image('ButtonTEST'), ()->{ Functions.DoButtonShtuff('Settings'); }, 1, false);
        add(Button_Settings);

    }

    override public function update(elapsed:Float) {
            super.update(elapsed);

            if(FlxG.mouse.overlaps(Button_Play))
                {
                    FlxTween.cancelTweensOf(Button_Play);
                    Button_Play.Hover = true;
                    FlxTween.tween(Button_Play, {"scale.x": 1.2, "scale.y": 1.2}, 0.5, {
                        ease: FlxEase.circOut
                    });
                }
            else
                {
                    FlxTween.cancelTweensOf(Button_Play);
                    Button_Play.Hover = false;
                    FlxTween.tween(Button_Play, {"scale.x": 1, "scale.y": 1}, 0.5, {
                        ease: FlxEase.circOut
                    });
                }

            if(FlxG.mouse.overlaps(Button_Settings))
                {
                    FlxTween.cancelTweensOf(Button_Settings);
                    Button_Settings.Hover = true;
                    FlxTween.tween(Button_Settings, {"scale.x": 1.2, "scale.y": 1.2}, 0.5, {
                        ease: FlxEase.circOut
                    });
                }
            else
                {
                    FlxTween.cancelTweensOf(Button_Settings);
                    Button_Settings.Hover = false;
                    FlxTween.tween(Button_Settings, {"scale.x": 1, "scale.y": 1}, 0.5, {
                        ease: FlxEase.circOut
                    });
                }
    }
}