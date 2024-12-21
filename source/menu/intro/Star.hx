package menu.intro;

import flixel.tweens.FlxEase;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.addons.effects.FlxTrail;
import flixel.tweens.FlxTween;

class Star extends FlxSprite
{
    public var tween:FlxTween;
    public var trail:FlxTrail;
    override public function new(x:Int, y:Int, graphic:FlxGraphicAsset, hasTrail:Bool = false, dur:Float) {
        super(x, y, graphic);
        var r = new FlxRandom();
        var xPos:Int = 0;
        var yPos:Int = 0;
        if (hasTrail)
        {
            trail = new FlxTrail(this, makeGraphic(10, 10).graphic, 10, 0, 1, 0.1);
        }
        if (r.bool())
        {
            xPos = r.int(-100, 1400);
            if (r.bool()) yPos = -100; else yPos = 800;
        }else{
            yPos = r.int(-100, 800);
            if (r.bool()) xPos = -100; else xPos = 1400;
        }

        scale.set(0, 0);
        tween = FlxTween.tween(this, {x: xPos, y: yPos, 'scale.x': 2, 'scale.y': 2}, dur, {ease: FlxEase.circIn, onComplete: (_) -> {
            destroy();
            if (trail != null)
                trail.destroy();
        }});
        tween.start();
    }
}