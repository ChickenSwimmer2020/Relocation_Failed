package modding.ui;

import flixel.tweens.FlxEase;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.addons.effects.FlxTrail;
import flixel.tweens.FlxTween;

class MODStar extends FlxSprite {
	/**
	 * The tween that moves the star.
	 * @since RF_DEV_0.4.1
	 */
	public var tween:FlxTween;

	override public function new(x:Int, y:Int, graphic:FlxGraphicAsset, dur:Float) {
		super(x, y, graphic);
		var r = new FlxRandom();
		var xPos:Int = 0;
		var yPos:Int = 0;

        xPos = r.int(0, 1280);
        yPos = 720;

		scale.set(0.5, 0.5);
		tween = FlxTween.tween(this, {
			x: xPos,
			y: 0,
			alpha: 0.2,
			'scale.x': 1,
			'scale.y': 1
		}, dur, {
			ease: FlxEase.linear,
			onComplete: (_) -> {
				destroy();
			}
		});
		tween.start();
	}
}
