package menu.intro;

import sys.thread.Thread;
import lime.math.Vector2;
#if hl import hlwnative.HLNativeWindow; #end
import lime.ui.Window;

class WindowIntro extends FlxState
{
    var window:Window;
    var fadingIn:Bool = false;
    var windowAlpha:Int = 0;
    public static var oldWindowDimensions:Vector2;
    public static var oldWindowPosition:Vector2;
    override public function create()
    {
        super.create();
        Thread.create(() -> {
            var logoCache:FlxSprite = new FlxSprite(0, 0, Assets.image("StudioLogo")); //cache the studio logos so it doesnt lag when doing stuff.
            var logoCache2:FlxSprite = new FlxSprite(0, 0, Assets.image("studiotext"));
            add(logoCache);
            add(logoCache2);
            wait(0.1, () -> {
                logoCache.alpha = 0;
                logoCache2.alpha = 0;
            });
        });
        #if hl
        HLNativeWindow.setWindowLayered();
        HLNativeWindow.setWindowDarkMode(true); // It just looks cleaner
        window = Application.current.window;
        window.focus();
        @:privateAccess // I found out that this caused the glitch where it appeared below my taskbar. I was wondering why that was happening.
            window.__attributes.alwaysOnTop = true; //keep the window on top so you cant accidently click off during the fade and break the illusion
        setWindowAlpha(0);
        oldWindowDimensions = new Vector2(window.width, window.height);
        oldWindowPosition = new Vector2(window.x, window.y);
        window.borderless = true;
        window.x = 0;
        window.y = 0;
        window.width = Std.int(window.display.bounds.width - 1); //apparently my push from the other pc didnt work?
        window.height = Std.int(window.display.bounds.height - 1);
        FlxG.autoPause = false;
        FlxG.mouse.visible = false;
        wait(2, () -> {
            fadingIn = true;
        });
        #end
    }
    function setWindowAlpha(alpha:Int)
    {
        #if hl HLNativeWindow.setWindowAlpha(alpha); #end
    }

    var alpha:Int = 0;
    override public function update(elapsed:Float)
    {
        window.focus();
        if (fadingIn){
            if (alpha < 255) alpha += 5;
            else FlxG.switchState(new IntroState());
            setWindowAlpha(alpha);
        }
    }
}