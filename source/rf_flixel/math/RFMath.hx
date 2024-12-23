package rf_flixel.math;

import flixel.math.FlxMath;

class RFMath extends FlxMath
{
    public static function clamp(value:Float, min:Float, max:Float):Float
        return Math.max(min, Math.min(max, value));

    public static function mapRange(n:Float, fromMin:Float, fromMax:Float, toMin:Float, toMax:Float)
		return (n - fromMin) * (toMax - toMin) / (fromMax - fromMin) + toMin;

	/**
	 * Simple AABB collision detection.
     * Takes in any object that contains x, y, width, and height variables.
     * @since RF_DEV_0.2.7
	 */
	public static function AABBCollide(a:Dynamic, b:Dynamic)
	{
        var objA:XYWHObj = new XYWHObj(Std.int(a.x), Std.int(a.y), Std.int(a.width), Std.int(a.height));
        var objB:XYWHObj = new XYWHObj(Std.int(b.x), Std.int(b.y), Std.int(b.width), Std.int(b.height));
		if ((objB.x >= objA.x + objA.width) || (objB.x + objB.width <= objA.x) ||
            (objB.y >= objA.y + objA.height) || (objB.y + objB.height <= objA.y))
			return false;
		else
			return true;
	}
}