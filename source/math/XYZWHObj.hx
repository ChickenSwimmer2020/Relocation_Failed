package math;

/**
 * A simple object for x, y, z, width, and height.
 * @since RF_DEV_0.4.0
 */
class XYZWHObj extends XYWHObj {
    /**
	 * The x value of this object.
	 * @since RF_DEV_0.2.7
	 */
    public var z:Int;

    override public function new(x:Int, y:Int, z:Int, width:Int, height:Int){
		super(x, y, width, height);
        this.z = z;
    }
}