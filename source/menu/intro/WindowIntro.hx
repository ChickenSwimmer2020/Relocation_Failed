package menu.intro;

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
        #if hl
        HLNativeWindow.setWindowLayered();
        HLNativeWindow.setWindowDarkMode(true); // It just looks cleaner
        window = Application.current.window;
        window.focus();
        setWindowAlpha(0);
        oldWindowDimensions = new Vector2(window.width, window.height);
        oldWindowPosition = new Vector2(window.x, window.y);
        window.borderless = true;
        window.x = 0;
        window.y = 0;
        window.width = Std.int(window.display.bounds.width);
        window.height = Std.int(window.display.bounds.height);
        FlxG.autoPause = false;
        FlxG.mouse.visible = false;
        wait(5, () -> {
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
            if (alpha < 255) alpha += 1;
            else FlxG.switchState(new IntroState());
            setWindowAlpha(alpha);
        }
    }
}