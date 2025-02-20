package objects;

import openfl.geom.Vector3D;

//* Why do they call it "Vector3D"? I'm not only using it for 3d.
class Vector3 extends Vector3D {
	public function subtractVec(a:Vector3):Vector3
		return new Vector3(x - a.x, y - a.y, z - a.z, w);

	public function multiplyVec(a:Vector3):Vector3
		return new Vector3(x * a.x, y * a.y, z * a.z, w);
}

class RFPhysTriAxisSprite extends RFTriAxisSprite {
	public var physVelocity:Vector3 = new Vector3(0, 0, 0);
	public var physDrag:Vector3 = new Vector3(0, 0, 0);
	public var physAcceleration:Vector3 = new Vector3(0, 0, 0);

	override public function update(elapsed:Float) {
		super.update(elapsed);

		physVelocity = physVelocity.subtractVec(physVelocity.multiplyVec(physDrag).multiplyVec(new Vector3(elapsed, elapsed, elapsed)));
		var physElapsed = physVelocity.multiplyVec(new Vector3(elapsed, elapsed, elapsed));

		if (Math.abs(physElapsed.x) < 0.0001)
			physElapsed.x = 0;
		if (Math.abs(physElapsed.y) < 0.0001)
			physElapsed.y = 0;
		if (Math.abs(physElapsed.z) < 0.0001)
			physElapsed.z = 0;
		tX += physElapsed.x;
		tY += physElapsed.y;
		tZ += physElapsed.z;
	}
}
