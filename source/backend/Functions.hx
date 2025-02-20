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
class Functions {
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
	static inline public function GetPlatform():String #if modded #if html5 return "Html5 (MODDED)"; #else #if cpp return
		"Windows (MODDED)"; #else #if hl return "HashLink/Windows (MODDED)"; #else return "Unknown (MODDED)"; #end #end #end #else #if html5 return
			"Html5"; #else #if cpp return "Windows"; #else #if hl return "HashLink/Windows"; #else return "Unknown"; #end #end #end #end

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
	 * @param time Int
	 * @param onComplete Void
	 * @return FlxTimer
	 *
	 * @since RF_DEV_0.0.9
	 */
	inline static public function wait(time:Float, onComplete:() -> Void):FlxTimer
		return new FlxTimer().start(time, (_) -> {
			onComplete();
		});

	/* 

														---------THE FUNCTION GRAVEYARD---------
												RIP Single Trace function, you are useless to me :>
		 RIP FlxDemo change transition function, you are useless to me aswell :> //HEY, SOLAR I WANTED THAT, I WANTED COOL TRANSITIONS 😭
									RIP instant If, you were useless to me & CS2020(he forgot this existed). :>

	 */
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
	static public function getSpriteAngleFromMousePos():Float {
		// thanks chatGPT!
		var mousePos = FlxG.mouse.getViewPosition(Playstate.instance.HUDCAM);
		return Math.atan2(mousePos.y - FlxG.height / 2, mousePos.x - FlxG.width / 2) * 180 / Math.PI; // ew, pi.
	}

	/**
	 * Formats a PosInfos object into a string.
	 * @param posInfos 
	 * @return String
	 * @since RF_DEV_0.2.7
	 */
	public static function formatPosInfos(posInfos:PosInfos):String
		return 'Called from ${posInfos.fileName}.${posInfos.methodName}(${posInfos.customParams}):${posInfos.lineNumber}';
}
