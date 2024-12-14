package backend;

#if mobile
import flixel.input.touch.FlxTouch;
#end
/**
 * a kind complex functions set with many functions that allow for easy and much quicker function running.
 * @since RF_DEV_0.0.1
 */
class Functions
{
    /**
      * variable for detecting if the function
      * has been already executed
      * @since RF_DEV_0.1.0
      */
    public static var Traced:Bool = false;
    /**
      * # GetPlatform();
      * ## *wait, which platform was safe again?*
      * simple function to return the current platform, pretty easy to work with actually,
      * since it returns the platform variable as a string without any excess functions to get anything
      * ---
      * Example:
      * ```
      * var mystring:String = Functions.GetPlatform();
      * ```
      * ---
      * @return String
      * @since RF_DEV_0.0.4
      */
    static inline public function GetPlatform():String
        #if modded #if html5 return "Html5 (MODDED)"; #else #if cpp return "Windows (MODDED)"; #else #if hl return "HashLink/Windows (MODDED)";
        #else return "Unknown (MODDED)"; #end #end #end #else #if html5 return "Html5"; #else #if cpp return "Windows"; #else #if hl return "HashLink/Windows";
        #else return "Unknown"; #end #end #end #end
    /**
      * # traceOnce();
      * ## *why flood, when you can trace!*
      * have you ever had a variable that needs to trace, but it traces multiple times and floods the console?
      * well look no further than traceOnce!
      * now you can have a looped trace that will only trace a single time!
      * ---
      * Example:
      * ```
      * Functions.traceOnce('your text');
      * ```  
      * ---
      * @param text the text that should be traced
      * @since RF_DEV_0.0.9
      */
    static public function traceOnce(text:String) 
        {
            if(!Traced) {
                trace(text);
                Traced = true;
            }
            var tmr:FlxTimer = new FlxTimer();
            tmr.start(999999, function(tmr:FlxTimer){ //dont want it to restart, do we?
                Traced = false;
            });
        }
    /**
      * # wait();
      * ## timers are stupid, wait instead!
      * have you ever had problems with setting up timers? all that hard work for a single wait function?
      * well look no further than wait();!
      * with this small function, you can easily wait for as long as you need!
      * ---
      * Example: how to format the function
      * ```
      * Functions.wait(1, () -> { code block; });
      * ```
      * ---
      * @param Time Interger
      * @param onComplete Void
      * @return FlxTimer
      *
      * @since RF_DEV_0.0.9
      */
    inline static public function wait(Time:Float, onComplete:() -> Void):FlxTimer
        return new FlxTimer().start(Time, (_) ->{ onComplete(); });
    #if !mobile
    /**
      * # getSpriteAngleFromMousePos();
      * ## isnt there a better way to do this?!
      * there uhm, probably a lot of a better way to do this...
      * ---
      * Example: how to format the function
      * ```
      * mysprite.angle = Functions.getSpriteAngleFromMousePos();
      * ```
      * ---
      * @return Float
      *
      * @since RF_DEV_0.0.9
      */
    static public function getSpriteAngleFromMousePos():Float
        {
            //thanks chatGPT!
            var angle:Float = 0;
            var screencenterX = FlxG.width / 2;
            var screencenterY = FlxG.height / 2;
            var mouseX = FlxG.mouse.getViewPosition(Playstate.instance.HUDCAM).x;
            var mouseY = FlxG.mouse.getViewPosition(Playstate.instance.HUDCAM).y;
            var relativeX = mouseX - screencenterX;
            var relativeY = mouseY - screencenterY;

            angle = Math.atan2(relativeY, relativeX) * 180 / Math.PI; //ew, pi.

            #if debug
            FlxG.watch.addQuick('CurAngle', angle);
            FlxG.watch.addQuick('screenCenterX', screencenterX);
            FlxG.watch.addQuick('screencenterY', screencenterY);
            FlxG.watch.addQuick('mouseX', FlxG.mouse.viewX);
            FlxG.watch.addQuick('mouseY', FlxG.mouse.viewY);
            FlxG.watch.addQuick('relativeX', relativeX);
            FlxG.watch.addQuick('relativeY', relativeY);
            #end
            return angle;
        }
    #end
    #if desktop //window transparency stuff
        #if windows
        /**
          * # setWindowTransparencyColor();
          * ## *Just be transparent if you really love them*
          * allows for changing of the color that a window will automatically set as transparent
          * ---
          * @param red Interager (0-255)
          * @param green Interager (0-255)
          * @param blue Interager (0-255)
          * @param alpha Interager (0-255)
          * @since RF_DEV_0.1.0
          */
        @:functionCode('
            HWND window = GetActiveWindow();

            if (transparencyEnabled) {
                SetWindowLong(window, GWL_EXSTYLE, GetWindowLong(window, GWL_EXSTYLE) ^ WS_EX_LAYERED);
                SetLayeredWindowAttributes(window, RGB(0, 0, 0), 255, LWA_COLORKEY | LWA_ALPHA);
            }
            // make window layered
            int result = SetWindowLong(window, GWL_EXSTYLE, GetWindowLong(window, GWL_EXSTYLE) | WS_EX_LAYERED);
            if (alpha > 255) alpha = 255;
            if (alpha < 0) alpha = 0;
            SetLayeredWindowAttributes(window, RGB(red, green, blue), alpha, LWA_COLORKEY | LWA_ALPHA);
            alpha = result;
            transparencyEnabled = true;
        ')
        #end
        public static function setWindowTransparencyColor(red:Int, green:Int, blue:Int, alpha:Int = 255) {
            return alpha;
        }
        #if windows
        /**
          * # disableWindowTransparency();
          * ## *The first friend who doesnt look through you, should be a friend you stay with*
          * allows for toggling window transparency
          * ---
          * @param result Bool
          * @since RF_DEV_0.1.0
          */
        @:functionCode('
            if (!transparencyEnabled) return false;
            
            HWND window = GetActiveWindow();
            SetWindowLong(window, GWL_EXSTYLE, GetWindowLong(window, GWL_EXSTYLE) ^ WS_EX_LAYERED);
            SetLayeredWindowAttributes(window, RGB(0, 0, 0), 255, LWA_COLORKEY | LWA_ALPHA);
            transparencyEnabled = false;
        ')
        #end
        public static function disableWindowTransparency(result:Bool = true) {
            return result;
        }
    #end
}