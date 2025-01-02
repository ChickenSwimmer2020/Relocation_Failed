package backend;

import flixel.FlxG;
import haxe.PosInfos;

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
        #if modded #if html5 return "Html5 (MODDED)"; #else #if cpp return "Windows (MODDED)"; #else 
        #if hl return "HashLink/Windows (MODDED)"; #else return "Unknown (MODDED)"; #end #end #end #else 
        #if html5 return "Html5"; #else #if cpp return "Windows"; #else #if hl return "HashLink/Windows";
        #else return "Unknown"; #end #end #end #end

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
    

    // RIP Single Trace function, you are useless to me :>
    // RIP FlxDemo change transition function, you are useless to me aswell:> //HEY, SOLAR I WANTED THAT, I WANTED COOL TRANSITIONS :sob:


    /**
     * iIf: Instant if(not really instant and if anything it's basically the same as an if statement, but it's a cool name, right?)
     * It's literally an if statement, but uses a switch statement. The compiler won't generate a jump table as it only has two cases. 
     * A jump table is a table of places for the compiler to just through, which is much faster than an if-else. The issue is that a standard
     * compiler only generates it if there are more than 5 cases. This means it will will give you literally no extra 
     * frames(And I(ZSolarDev) have no use for it), but my friend(ChickenSwimmer2020) added it in, so I'll keep it as he says it's useful.
     * @param boolToCheck the bool to check
     * @param ifTrue what to do if true
     * @param ifFalse what to do if false
     * @return Bool: useful if you need to use an iif within something else, good for chaining.
     * @since RF_DEV_0.3.0
     */
    public static function iIf(boolToCheck:Bool, ifTrue:Void->Void, ifFalse:Void->Void):Bool {
        switch(boolToCheck) {
            case true: ifTrue();
            case false: ifFalse();
        }
        return boolToCheck;
    }
    #if !mobile
    /**
      * # getSpriteAngleFromMousePos();
      * ## isnt there a better way to do this?!
      * there uhm, probably a lot of a better way to do this...
      * ---
      * Example: how to format the function
      * ```haxe
      * mysprite.angle = Functions.getSpriteAngleFromMousePos();
      * ```
      * ---
      * @return Float
      *
      * @since RF_DEV_0.0.9
      */
    @:deprecated("getSpriteAngleFromMousePose is deprecated, use FlxAngle.angleBetweenPoint, instead") // RF_Dev_0.1.1
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

    /**
     * Formats a PosInfos object into a string.
     * @param posInfos 
     * @return String
     * @since RF_DEV_0.2.7
     */
    public static function formatPosInfos(posInfos:PosInfos):String
        return 'Called from ${posInfos.fileName}.${posInfos.methodName}(${posInfos.customParams}):${posInfos.lineNumber}';
}