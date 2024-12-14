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
}

class Bullet extends FlxSprite {
    public var _SPEED:Float = 600;
    private var _TARGET:FlxPoint;
    private var _TYPE:BulletType;
    public static var ApplyTracer:Bool = false;


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
        }

        velocity.set(_SPEED, 0);
        var rand:Float = new FlxRandom().float(-0.5, 0.5);
        velocity.pivotDegrees(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, _TARGET, true) + rand);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(!this.isOnScreen(Playstate.instance.FGCAM)) {
            this.kill();
        }
    }

    public static function shoot() {
        var mousePos = FlxG.mouse.getPosition();
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, mousePos, PISTOLROUNDS));
    }

    public function getType():BulletType
    {
        return _TYPE;
    }
}