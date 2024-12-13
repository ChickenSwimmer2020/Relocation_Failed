package objects;

import backend.Assets;
import flixel.math.FlxPoint;

class NPC extends FlxSprite {
    /**
        # This is the main NPC character script
        ## you make NPC's with this, there are a couple variables.
        @param xPos[Int] the x position of the NPC.
        @param yPos[Int] the y position of the NPC.
        @param Spr[String] the graphic the character should use.
        @param FrameBounds[Array:Int] the frame height and width for animations.
        @param FreeMovement[Bool] should the NPC be able to move freely.
        //@param Behavior[NPCBehavior] ???
        //@param Weapon[String] ???
        @param ?forcedMovementPath[Array:FlxPoint] should the NPC be forced to follow a certain path.
    **/                                                                                          //TODO: implement
    public function new(xPos:Float, yPos:Float, FrameBounds:Array<Int>, Spr:String, /*Behavior:NPCBehavior, Weapon:String,*/ FreeMovement:Bool, ?forcedMovementPath:Array<FlxPoint>) {
        super(xPos, yPos, Spr);
        loadGraphic(Assets.image(Spr), true, FrameBounds[0], FrameBounds[1]);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(this.animation.getByName('idle') != null)
            this.animation.play('idle');
    }

    /**
        # allows implementation of animations to NPC sprites.
        @param animName[String] animation name.
        @param animFrames[Array:Int] the frames of the animation.
        @param frameRate[Int] the rate at which the frames will change.
        @param flipX[Bool] should the animation be flipped on the x axis.
        @param flipY[Bool] should the animation be flipped on the y axis.
        @param ?loop[Bool] should the animation loop.
    **/
    public function AddAnimation(animName:String, animFrames:Array<Int>, frameRate:Int, flipX:Bool, flipY:Bool, ?loop:Bool = false) {
        this.animation.add(animName, animFrames, frameRate, loop, flipX, flipY);
    }
}