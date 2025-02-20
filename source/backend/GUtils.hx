package backend;

import haxe.ds.IntMap;

class GUtils {
	/**
	 * Clears this array, modifies the array in place.
	 * @param array The array to clear.
	 * @param exFunc The function to execute on each object in the array before getting removed.
	 * @return The cleared array.
	 * @since RF_DEV_0.0.9
	 */
	public static function clearArray<T>(array:Array<T>, ?exFunc:(T) -> Void):Array<T> {
		for (arrayObj in array) {
			if (exFunc != null)
				exFunc(arrayObj);
			array.remove(arrayObj);
		}
		return array;
	}

	/**
	 * Gets the length of an IntMap.
	 * @param map The IntMap to get the length of.
	 * @return The length of the IntMap.
	 * @since RF_DEV_0.4.0
	 */
	public static function getIntMapLen<T>(map:IntMap<T>):Int {
		var mapLength = 0;
		for (i in map.keys())
			if (i > mapLength)
				mapLength = i;
		return mapLength;
	}

	/**
	 * Gets the next free index in an IntMap.
	 * @param map The IntMap to get the next free index of.
	 * @return The next free index of the IntMap.
	 * @since RF_DEV_0.4.0
	 */
	public static function getNextFreeInIntMap<T>(map:IntMap<T>):Int {
		var res = 0;
		for (i in 0...getIntMapLen(map)) {
			if (map.get(i) == null) {
				res = i;
				break;
			}
		}
		return res;
	}
}
