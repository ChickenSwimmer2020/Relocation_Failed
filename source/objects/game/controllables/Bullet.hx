package objects.game.controllables;

import flixel.animation.FlxAnimationController;
import flixel.system.FlxAssets.FlxGraphicAsset;
import math.RFMath;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import rf_flixel.addons.effects.RFTrail;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

enum BulletType {
	NULL; // for when you dont have the suit or have a melee weapon equipped
	SHOTGUNSHELL; // display name: 12 Gauge Buckshot
	PISTOLROUNDS; // display name: 9 MilliMeter
	RIFLEROUNDS; // display name: 7.62x51mm NATO
	SMGROUNDS; // display name: 10MM
}

class Bullet extends FlxSprite {
	public var _SPEED:Float = 2000;

	private var _TARGET:FlxPoint;

	public var _TYPE:BulletType;
	public var ApplyTracer:Bool = false;
	public var tracy:RFTrail;
	public var lifetime:Int = 1;

	public function new(X:Float, Y:Float, target:FlxPoint, type:BulletType, ?Tracer:Bool, ?Speed:Float) {
		super(X, Y);

		if (Speed != null)
			_SPEED = Speed;

		_TYPE = type;
		_TARGET = target;

		switch (type) {
			case SHOTGUNSHELL:
				lifetime = 1;
				makeGraphic(5, 5, FlxColor.RED);
			case PISTOLROUNDS:
				lifetime = 1;
				makeGraphic(5, 5, FlxColor.YELLOW);
			case RIFLEROUNDS:
				lifetime = 1;
				makeGraphic(5, 5, FlxColor.WHITE);
			case SMGROUNDS:
				lifetime = 1;
				makeGraphic(5, 5, FlxColor.CYAN);
			case NULL:
				lifetime = 0;
				makeGraphic(5, 5, FlxColor.TRANSPARENT);
		}

		wait(lifetime, () -> {
			destroy();
			if (tracy != null) {
				Playstate.instance.BulletGroup.remove(tracy);
				tracy.destroy();
				tracy = null;
			}
		});

		if (Tracer) {
			tracy = new RFTrail(this, null, 10, 0, 1, 0.1);
			Playstate.instance.BulletGroup.add(tracy);
			ApplyTracer = true;
		}

		velocity.set(_SPEED, 0);
		velocity.pivotDegrees(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, _TARGET, true) + new FlxRandom().float(-5, 5));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
class Shell extends FlxSprite {
	public function new(x:Float, y:Float){
		super(x, y);
	}
	public static function EjectShell(Type:Bullet.BulletType, Offset:{X:Float, Y:Float}, Velocity:FlxPoint, onPump:Bool = false){
		var Shell:Shell = new Shell(Playstate.instance.Player.x + Offset.X, Playstate.instance.Player.y + Offset.Y);
		switch(Type){
			case RIFLEROUNDS:
				Shell.makeGraphic(4, 1, FlxColor.YELLOW);
			case SMGROUNDS:
				Shell.makeGraphic(2, 1, FlxColor.YELLOW);
			case PISTOLROUNDS:
				Shell.makeGraphic(3, 1, FlxColor.YELLOW);
			case SHOTGUNSHELL:
				Shell.makeGraphic(5, 1, FlxColor.RED);
			default:
				Shell.makeGraphic(1, 1, FlxColor.WHITE);
		}
		if(onPump){
			wait(0.5, ()->{ //cant base this on curFrame for some reason, ugh, TIMERS.
				Playstate.instance.ShellGroup.add(Shell);
				Shell.velocity = Velocity;
			});
		}else{
			Playstate.instance.ShellGroup.add(Shell);
			Shell.velocity = Velocity;
		}

		wait(10, ()->{
			FlxTween.tween(Shell, {alpha: 0}, 1, {onComplete: function(Twn:FlxTween) {
				Shell.destroy(); //should destroy so it doesnt become a memory problem the more shells that exist.
			}});
		});
	}

	override public function update(elapsed:Float){ 
		super.update(elapsed);

		for(object in Playstate.instance.ShellGroup){
			if(Std.isOfType(object, Shell)){
				var Shell:Shell = cast object;
				if (Shell != null && Shell.exists) {
					if (!Shell.velocity.equals(FlxPoint.get(0, 0))) {
						Shell.velocity.set(Shell.velocity.x > 0 ? -0.01 : (Shell.velocity.x < 0 ? 0.01 : 0), (Shell.velocity.x > 0 ? -0.01 : (Shell.velocity.x < 0 ? 0.01 : 0)));
					}
				}
			}
		}
	}
}
