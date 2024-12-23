package objects.game.controllables;


import flixel.math.FlxRandom;
import rf_flixel.addons.effects.RFTrail;
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
    public var _TYPE:BulletType;
    public var ApplyTracer:Bool = false;
    public var tracy:RFTrail;
    public var lifetime:Int = 1;

    public function new(X:Float, Y:Float, target:FlxPoint, type:BulletType, ?Tracer:Bool, ?Speed:Float) {
        super(X, Y);

        if(Speed != null)
            _SPEED = Speed;

        _TYPE = type;
        _TARGET = target;

        switch(type) {
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
        }

        wait(lifetime, () -> {
            destroy();
            if(tracy != null) {
                Playstate.instance.BulletGroup.remove(tracy);
                tracy.destroy();
                tracy = null;
            }
        });

        if(Tracer){
            tracy = new RFTrail(this, null, 10, 2, 0.4, 0.05);
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