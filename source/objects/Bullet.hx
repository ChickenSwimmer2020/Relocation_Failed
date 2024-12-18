package objects;

import flixel.math.FlxRandom;
import flixel.addons.effects.FlxTrail;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

enum BulletType
{
    SHOTGUNSHELL; //display name: 12 Gauge Buckshot
    PISTOLROUNDS; //display name: 9 MilliMeter
    RIFLEROUNDS; //display name: 7.62x51mm NATO
    SMGROUNDS; //display name: 10MM
}

class Bullet extends FlxSprite {
    public var _SPEED:Float = 600;
    private var _TARGET:FlxPoint;
    private var _TYPE:BulletType;
    public static var ApplyTracer:Bool = false;
    public static var tracy:FlxTrail;
    public static var rand:Float = 0; //bullet spread!


    public function new(X:Float, Y:Float, target:FlxPoint, type:BulletType, ?Tracer:Bool, ?Speed:Float) {
        super(X, Y);

        if(Speed != null)
            _SPEED = Speed;

        if(Tracer)
            ApplyTracer = true;

        _TYPE = type;
        _TARGET = target;

        switch(type) {
            case SHOTGUNSHELL:
                makeGraphic(5, 5, FlxColor.RED);
            case PISTOLROUNDS:
                makeGraphic(5, 5, FlxColor.YELLOW);
            case RIFLEROUNDS:
                makeGraphic(5, 5, FlxColor.WHITE);
            case SMGROUNDS:
                makeGraphic(5, 5, FlxColor.CYAN);
        }

        velocity.set(_SPEED, 0);
        velocity.pivotDegrees(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, _TARGET, true) + rand);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        //check if our bullet is offscreen, somehow?
        if(this.isOnScreen(FlxG.camera) != true) {
            this.destroy();
            //if(ApplyTracer) {
            //    tracy.kill(); //TODO: FIX ME!
            //}
            trace('bullet was destroyed!!\n\nTHATS REALLY GOOD!');
        }
    }

    public static function shoot() {
        rand = new FlxRandom().float(-5, 5);
        var mousePos = FlxG.mouse.getPosition();
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, mousePos, Playstate.instance.Player.CurWeaponChoice, true));
        //for (bullet in Playstate.instance.BulletGroup) { //TODO: FIX THIS!!!!!!!!!!
        //    if (Std.isOfType(bullet, FlxSprite)) { // Ensure 'bullet' is a FlxSprite
        //        if (ApplyTracer) {
        //            tracy = new FlxTrail(cast bullet, null, 10, 2, 0.4, 0.05); // Cast 'bullet' to FlxSprite
        //            try {
        //                Playstate.instance.BulletGroup.add(tracy);
        //            } catch(e) {
        //                trace('tracer isnt alive!');
        //            }
        //        }
        //    }   
        //}
    }

    public static function shotgunShoot() {
        var Spread:Array<FlxPoint> = getShotgunSpread(FlxG.mouse.getPosition(), Playstate.instance.Player2.angle, 120, 7, 100);
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, Spread[0], SHOTGUNSHELL, true));
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, Spread[1], SHOTGUNSHELL, true));
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, Spread[2], SHOTGUNSHELL, true));
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, Spread[3], SHOTGUNSHELL, true));
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, Spread[4], SHOTGUNSHELL, true));
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, Spread[5], SHOTGUNSHELL, true));
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, Spread[6], SHOTGUNSHELL, true));
    }

    public static function getShotgunSpread(center:FlxPoint, facingAngle:Float, fov:Float, numBullets:Int, range:Float):Array<FlxPoint> {
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

    public function getType():BulletType
    {
        return _TYPE;
    }
}