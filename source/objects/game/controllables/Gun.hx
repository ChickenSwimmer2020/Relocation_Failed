package objects.game.controllables;

import flixel.math.FlxPoint;
import flixel.math.FlxRandom;

class Gun {
    public function new()
        return;

    public function shoot() {
        var mousePos = FlxG.mouse.getPosition();
        Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.getGraphicMidpoint().x, Playstate.instance.Player2.getGraphicMidpoint().y, mousePos, Playstate.instance.Player.CurWeaponChoice, true));
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
}