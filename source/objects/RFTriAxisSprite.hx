package objects;

import flixel.system.FlxAssets.FlxGraphicAsset;

class RFTriAxisSprite extends FlxSprite {
	public var tX:Float = 0;
	public var tY:Float = 0;
	public var tZ:Float = 0;
	public var z:Float = 0;
	public var special:Bool = false;

	public function new(x:Float, y:Float, z:Float, ?graphic:FlxGraphicAsset) {
		super(0, 0, graphic);
		tX = x;
		tY = y;
		tZ = z;
		updatePos();
	}

	public function setPos(x:Float, y:Float, z:Float) {
		tX = x;
		tY = y;
		tZ = z;
		updatePos();
	}

	override public function update(elapsed:Float) {
		updatePos();
		super.update(elapsed);
	}

	public function updatePos() {
		x = tX;
		z = tZ;
		y = tY + z;
	}
}
