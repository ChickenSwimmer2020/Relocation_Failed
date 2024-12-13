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
      * @since RF_DEV_0.0.9
      */
    static inline public function GetPlatform():String
        #if html5 return "Html5"; #else #if cpp return "Windows"; #else #if hl return "HashLink/Windows"; #else return "Unknown"; #end #end #end
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
            var Traced:Bool = false;
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
      * Functions.wait(1, (_) -> { code block; } )
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
            var mouseX = FlxG.mouse.getScreenPosition(Playstate.instance.HUDCAM).x;
            var mouseY = FlxG.mouse.getScreenPosition(Playstate.instance.HUDCAM).y;
            var relativeX = mouseX - screencenterX;
            var relativeY = mouseY - screencenterY;

            angle = Math.atan2(relativeY, relativeX) * 180 / Math.PI; //ew, pi.

            #if debug
            FlxG.watch.addQuick('CurAngle', angle);
            FlxG.watch.addQuick('screenCenterX', screencenterX);
            FlxG.watch.addQuick('screencenterY', screencenterY);
            FlxG.watch.addQuick('mouseX', FlxG.mouse.screenX);
            FlxG.watch.addQuick('mouseY', FlxG.mouse.screenY);
            FlxG.watch.addQuick('relativeX', relativeX);
            FlxG.watch.addQuick('relativeY', relativeY);
            #end
            return angle;
        }
    #end
}