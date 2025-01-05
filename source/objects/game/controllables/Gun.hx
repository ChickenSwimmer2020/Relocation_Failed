package objects.game.controllables;

import math.RFMath;
import math.RFVector;
import math.RFInterp;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import backend.Functions;

class Gun{
    /**
     * the gun texture varible for changing the fun sprites.
     * @since RF_DEV_0.3.0
     */
    public var theGunTexture:FlxSprite = new FlxSprite(0, 0);
    /**
     * the gun textures X position before lerping.
     * @since RF_DEV_0.3.0
     */
    public var realGunXPOS:Float;
    /**
     * the gun textures Y position before lerping.
     * @since RF_DEV_0.3.0
     */
    public var realGunYPOS:Float;
    /**
     * the gun textures ANGLE before lerping
     * @since RF_DEV_0.3.0
     */
    public var realGunANGLE:Float;

    public var ratio:Float = 1;

    public var moveCallback:Void->Void;

    public function new() {
        moveCallback = () -> { ratio = 0; };
    }

    /**
     * Change the Texture of the gun.
     * ---
     * @param X the X position of the gun texture, these are seperate so we can have offsets for the guns themselves.
     * @param Y the Y position of the gun texture, these are seperate so we can have offsets for the guns themselves.
     * @param Texture texture to use, just put file name, dont include extension.
     * @param hasAnims does it have animations? this is only really used if its a melee or a test graphic. defaults to false.
     * @param isShotgun is the weapon a shotguntype weapon? defaults to false.
     * @param idleAnim the frames that haver the idle anim, array of ints.
     * @param shootAnim same as idle, but for the shoot anim.
     * @param reloadAnim same as idle, but for the reload anim.
     * @param pumpAnim  only really used for shotgun, but exists because we need it/.
     * @param FPS frames per second of the anims, int. defaults to 24
     * @param FrameWidth how wide is each frame, int. defaults to 32
     * @param FrameHeight how tall is each frame, int. defaults to 32
     * @since RF_DEV_0.3.0
     */
    public function changeTexture(X:Float, Y:Float, Texture:String, isShotgun:Bool = false, ?hasAnims:Bool = false, ?idleAnim:Array<Int>, ?shootAnim:Array<Int>, ?reloadAnim:Array<Int>, ?pumpAnim:Array<Int>, FPS:Int = 24, FrameWidth:Int = 32, FrameHeight:Int = 32) {
        try{
            theGunTexture.loadGraphic(Assets.image(Texture), hasAnims, FrameWidth, FrameHeight);
        } catch(e) {
            trace('Error loading texture: ' + e.message);
        }
        theGunTexture.setPosition(X, Y);
        realGunXPOS = X;
        realGunYPOS = Y;
        realGunANGLE = theGunTexture.angle;
        if(hasAnims != null && hasAnims == true) {
            if(idleAnim != null)
                theGunTexture.animation.addByIndices('Idle', 'addlater', idleAnim, '', FPS, false, false, false);
            if(shootAnim != null)
                theGunTexture.animation.addByIndices('Shoot', 'addlater', shootAnim, '', FPS, false, false, false);
            if(reloadAnim != null)
                theGunTexture.animation.addByIndices('Shoot', 'addlater', reloadAnim, '', FPS, false, false, false);
            if(isShotgun)
                if(pumpAnim != null)
                    theGunTexture.animation.addByIndices('Shoot', 'addlater', pumpAnim, '', FPS, false, false, false);
        }
        try{
            Playstate.instance.AimerGroup.add(theGunTexture); //WHAT. CASUES. THAT. STUPID. CRASH. AHHHHHHOJWEFHOUHDILABGS
        }catch(e){
            trace('GOTCHA!\nerror:\n${e.message}\n${e.stack}');
        }
    } //i mean, if we're having different guns. we need textures!

    public function updateTexturePosition(X:Float, Y:Float) {
        realGunXPOS = X; 
        realGunYPOS = Y;
    }

    public function shoot() {
        var mousePos = FlxG.mouse.getPosition();
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, mousePos, Playstate.instance.Player.CurWeaponChoice, Preferences.save.bulletTracers));
        theGunTexture.x -= 10;
        theGunTexture.angle -= 15;
    }

    public function shotgunShoot() {
        var Spread:Array<FlxPoint> = getShotgunSpread(FlxG.mouse.getPosition(), Playstate.instance.Player2.angle, 240, 9, 100);
        for (spread in 0...8)
            Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, Spread[spread], SHOTGUNSHELL, true));
    }

    public function getShotgunSpread(center:FlxPoint, facingAngle:Float, fov:Float, numBullets:Int, range:Float):Array<FlxPoint> {
        var spread:Array<FlxPoint> = [];
        var halfFov = fov / 2;
    
        for (i in 0...numBullets) {
            // Randomize or evenly distribute angles within the FOV
            var angle = facingAngle - halfFov + FlxG.random.float(0, fov);
    
            // Convert angle to radians
            var rad = Math.PI * angle / 180;
    
            // Calculate x and y offsets based on the angle and range
            var offsetX = Math.cos(rad) * range;
            var offsetY = Math.sin(rad) * range;
    
            // Add the offset to the center point
            var bulletPoint = new FlxPoint(center.x + offsetX, center.y + offsetY);
            spread.push(bulletPoint);
        }
    
        return spread;
    }

    public function update(elapsed:Float) {
        if (ratio < 1)
            ratio += 0.05;
        theGunTexture.x = RFInterp.easedInterp(realGunXPOS, theGunTexture.x, ratio, 'smootherStepInOut');
        theGunTexture.angle = RFInterp.easedInterp(Playstate.instance.Player2.angle, theGunTexture.angle, ratio, 'smootherStepInOut');
    }
}