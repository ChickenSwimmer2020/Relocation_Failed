package math;

/**
 * A simple object for x, y, width, and height.
 * @since RF_DEV_0.2.7
 */
class XYWHObj {
	/**
	 * The x value of this object.
	 * @since RF_DEV_0.2.7
	 */
	public var x:Int = 0;

	/**
	 * The y value of this object.
	 * @since RF_DEV_0.2.7
	 */
	public var y:Int = 0;

	/**
	 * The width value of this object.
	 * @since RF_DEV_0.2.7
	 */
	public var width:Int = 0;

	/**
	 * The height value of this object.
	 * @since RF_DEV_0.2.7
	 */
	public var height:Int = 0;

	public function new(x:Int, y:Int, width:Int, height:Int)
	{
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}
