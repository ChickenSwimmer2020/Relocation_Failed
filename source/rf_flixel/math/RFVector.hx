package rf_flixel.math;

/**
 * A simple vector class.
 * @since RF_DEV_0.3.0
 */
class RFVector {
    /**
     * The x value of this vector.
     * @since RF_DEV_0.3.0
     */
    public var x:Float;
    
    /**
     * The y value of this vector.
     * @since RF_DEV_0.3.0
     */
    public var y:Float;
    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }

    /**
     * Sets the x and y values of this vector.
     * @param x Float
     * @param y Float
     * @since RF_DEV_0.3.0
     */
    public function set(x:Float, y:Float):Void {
        this.x = x;
        this.y = y;
    }

    /**
     * Adds a vector to this vector.
     * @param v RFVector
     * @return RFVector
     * @since RF_DEV_0.3.0
     */
    public function add(v:RFVector):RFVector{
		x += v.x;
		y += v.y;
		return this;
	}
	
    /**
     * Substracts a vector from this vector.
     * @param v RFVector
     * @return RFVector
     * @since RF_DEV_0.3.0
     */
	public function substract(v:RFVector):RFVector{	
		x -= v.x;
		y -= v.y;
		return this;
	}
	
    /**
     * Multiplies this vector by a vector.
     * @param k Float
     * @return RFVector
     * @since RF_DEV_0.3.0
     */
	public function multiply(k:Float):RFVector{
		x *= y *= k;
		return this;
	}
}