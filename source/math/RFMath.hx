package math;

/**
 * A class for math functions not included in Math/FlxMath.
 * @since RF_DEV_0.3.0
 */
class RFMath {
	/**
	 * Clamps a value within the given range.
	 * @param n Float
	 * @param min Float
	 * @param max Float
	 * @return Float
	 * @since RF_DEV_0.2.7
	 */
	public static function clamp(n:Float, min:Float, max:Float):Float
		return Math.max(min, Math.min(max, n));

	/**
	 * Maps a value from one range to another.
	 * @param n Value to map
	 * @param fromMin Min value of starting range
	 * @param fromMax Max value of starting range
	 * @param toMin Min value of target range
	 * @param toMax Max value of target range
	 * @return Float
	 * @since RF_DEV_0.2.7
	 */
	public static function mapRange(n:Float, fromMin:Float, fromMax:Float, toMin:Float, toMax:Float)
		return (n - fromMin) * (toMax - toMin) / (fromMax - fromMin) + toMin;

	/**
	 * Wraps a value given a range.
	 * Lets say you have a value of 6: you have a range of 0 to 4, that 6 will wrap around to become 2.
	 * @param n Float
	 * @param min Float
	 * @param max Float
	 * @return Float
	 * @since RF_DEV_0.3.0
	 */
	public static function wrapFromRange(n:Float, min:Float, max:Float):Float
		return (n - min) % max - min + min;

	/**
	 * Rounds a number to the nearest multiple.
	 * @param n Float
	 * @param multiple Float
	 * @return Float
	 * @since RF_DEV_0.3.0
	 */
	public static function roundToNearest(n:Float, multiple:Float):Float
		return Math.round(n / multiple) * multiple;

	/**
	 * Returns the distance between two vectors.
	 * @param v1 RFVector
	 * @param v2 RFVector
	 * @return Float
	 * @since RF_DEV_0.3.0
	 */
	public static function distanceBwtweeen(v1:RFVector, v2:RFVector):Float
		return Math.sqrt(Math.pow(v2.x - v1.x, 2) + Math.pow(v2.y - v1.y, 2));

	/**
	 * Returns the angle between two vectors.
	 * @param v1 RFVector
	 * @param v2 RFVector
	 * @return Float
	 * @since RF_DEV_0.3.0
	 */
	public static function angleBwtweeen(v1:RFVector, v2:RFVector):Float
		return Math.atan2(v2.y - v1.x, v2.x - v1.x);

	/**
	 * Simple AABB collision detection.
	 * Takes in any object that contains x, y, width, and height variables.
	 * @param a Object you want to check for collisions
	 * @param b Object you want to check for collisions
	 * @since RF_DEV_0.2.7
	 */
	public static function AABBCollide(a:Dynamic, b:Dynamic):Bool {
		var objA:XYWHObj = new XYWHObj(Std.int(a.x), Std.int(a.y), Std.int(a.width), Std.int(a.height));
		var objB:XYWHObj = new XYWHObj(Std.int(b.x), Std.int(b.y), Std.int(b.width), Std.int(b.height));
		if ((objB.x >= objA.x + objA.width) || (objB.x + objB.width <= objA.x) || (objB.y >= objA.y + objA.height) || (objB.y + objB.height <= objA.y))
			return true;
		else
			return false;
	}
}
