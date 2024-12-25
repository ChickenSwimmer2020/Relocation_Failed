package math;

/**
 * A simple vector class.
 * @since RF_DEV_0.3.0
 */
class RFVector {
    //////////////////// INSTANCED RFVECTOR ////////////////////

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
     * Copies this vector and returns it.
     * @return RFVector
     * @since RF_DEV_0.3.0
     */
    public function copy():RFVector
        return new RFVector(x, y);

    public function toString():String
        return 'RFVector($x, $y)';



    //////////////////// STATIC RFVECTOR ////////////////////

    /**
     * Adds vector A to vector B.
     * @param a RFVector
     * @param b RFVector
     * @return RFVector
     * @since RF_DEV_0.3.0
     */
     public static function add(a:RFVector, b:RFVector):RFVector{
        var aNew = a.copy();
        var bNew = b.copy();
		aNew.x += bNew.x;
		aNew.y += bNew.y;
		return aNew;
	}

	
    /**
     * Subtracts vector A from vector B.
     * @param a RFVector
     * @param b RFVector
     * @return RFVector
     * @since RF_DEV_0.3.0
     */
	public static function subtract(a:RFVector, b:RFVector):RFVector{
        var aNew = a.copy();
        var bNew = b.copy();
		aNew.x -= bNew.x;
		aNew.y -= bNew.y;
		return aNew;
	}
	
    /**
     * Multiplies vector A and vector B.
     * @param a RFVector
     * @param b RFVector
     * @return RFVector
     * @since RF_DEV_0.3.0
     */
     public static function multiply(a:RFVector, b:RFVector):RFVector{
        var aNew = a.copy();
        var bNew = b.copy();
		aNew.x *= bNew.x;
		aNew.y *= bNew.y;
		return aNew;
	}

    /**
     * Divides vector A and vector B.
     * @param a RFVector
     * @param b RFVector
     * @return RFVector
     * @since RF_DEV_0.3.0
     */
     public static function divide(a:RFVector, b:RFVector):RFVector{
        var aNew = a.copy();
        var bNew = b.copy();
		aNew.x /= bNew.x;
		aNew.y /= bNew.y;
		return aNew;
	}
}