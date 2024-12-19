package backend;

import flixel.addons.transition.TransitionData;
import flixel.math.FlxPoint;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.FlxG;

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
    /**
      * # ever thought that the default flixel fade transition is stupid?
      * ## well look no further!
      * with this handy little function, you can easily change the fadeout/fadein to be
      * nearly anything!
      * ---
      *
      * Types Options: [tiles, fade, none]
      *
      * graphic Options: [circle, diamond, square]
      *
      * ---
      * ###### hehe, i stole this from the flixel transition demo >:)
      * @param Durations Array the first number of the array is the in duration, second is out duration.
      * @param Colors Array first FlxColor is transin, second is transout
      * @param Direction Array of Strings. options above. the first is transin second is transout
      * @param Types Array of Strings. item one is transin, item two is transout.
      * @param Graphic String. unless you set type to tiles, this doesnt do anything. options above
      * @since RF_DEV_0.1.6
      */
    public static function changeFlixelTransition(Durations:Array<Float>, Colors:Array<FlxColor>, Directions:Array<String>, Types:Array<String>, Graphic:String) {
        var trainIn = FlxTransitionableState.defaultTransIn;
        var trainOut = FlxTransitionableState.defaultTransOut;
        var p:FlxPoint = new FlxPoint();
        var p2:FlxPoint = new FlxPoint();
        var switchtype:flixel.addons.transition.TransitionData.TransitionType;
        var switchtype2:flixel.addons.transition.TransitionData.TransitionType;
        function getTileDataAsset(Graphic):FlxGraphic{
                var graphicClass:Class<Dynamic> = switch (Graphic)
                {
                    case "circle": GraphicTransTileCircle;
                    case "square": GraphicTransTileSquare;
                    case "diamond", _: GraphicTransTileDiamond;
                }
                
                var graphic = FlxGraphic.fromClass(cast graphicClass);
                graphic.persist = true;
                graphic.destroyOnNoUse = false;
                return graphic;
        }
        switch(Types[0]) {
            case 'tiles':
                switchtype = TILES;
            case 'fade':
                switchtype = FADE;
            case 'none':
                switchtype = NONE;
            default:
                switchtype = null;
        }
        switch(Types[1]) {
            case 'tiles':
                switchtype2 = TILES;
            case 'fade':
                switchtype2 = FADE;
            case 'none':
                switchtype2 = NONE;
            default:
                switchtype2 = null;
        }
        switch(Directions[0]) {
            case "up":
                p.set(0, -1);
            case "down":
                p.set(0, 1);
            case "left":
                p.set(-1, 0);
            case "right":
                p.set(1, 0);
            case "upleft":
                p.set(-1, -1);
            case "upright":
                p.set(1, -1);
            case "downleft":
                p.set(-1, 1);
            case "downright":
                p.set(1, 1);
            default:
                p.set(0, 0);
        }
        switch(Directions[1]) {
            case "up":
                p2.set(0, -1);
            case "down":
                p2.set(0, 1);
            case "left":
                p2.set(-1, 0);
            case "right":
                p2.set(1, 0);
            case "upleft":
                p2.set(-1, -1);
            case "upright":
                p2.set(1, -1);
            case "downleft":
                p2.set(-1, 1);
            case "downright":
                p2.set(1, 1);
            default:
                p2.set(0, 0);
        }
        if(trainIn != null) {
          trainIn.duration = Durations[0];
          trainIn.color = Colors[0];
          trainIn.direction = p;
          trainIn.type = switchtype;
          if(Types[0] == 'tiles') {
            trainIn.tileData.asset = getTileDataAsset(Graphic);
          }
        }
          
        if(trainOut != null) {
          trainOut.duration = Durations[1];
          trainOut.color = Colors[1];
          trainOut.direction = p2;
          trainOut.type = switchtype2;
          if(Types[1] == 'tiles') {
            trainIn.tileData.asset = getTileDataAsset(Graphic);
          }
        }
    }
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
}