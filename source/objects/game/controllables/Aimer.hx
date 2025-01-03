package objects.game.controllables;

import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.effects.FlxFlicker;
#if !mobile
class Aimer extends FlxSprite {
    static public var curAngle:Float;
    var shotgunPumping:Bool = false; //so we can make sure that you cant fire while the shotgun is pumping
    public var gun:Gun = new Gun();
    public var GunGroup:FlxSpriteGroup = new FlxSpriteGroup();

    var RIFLEfireRate:Float = 0.1; // Time between shots in seconds
    var RIFLEfireTimer:Float = 0; // Tracks time since the last shot
    public function new() {
        super();
		loadGraphic(Assets.image('Player_upper'), true, 32, 32, true);
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        RIFLEfireTimer += elapsed;
        this.x = Player.AimerPOSx;
        this.y = Player.AimerPOSy;
        this.updateHitbox(); //since angle stuff changes, we want this to update. right?
        #if !mobile
        AimAtCusor();
        #else
        //TODO: DO THIS
        #end
        curAngle = this.angle;

        #if !mobile //we need to calculate the shooting from the player so we can check ammo numberss
        if(FlxG.mouse.pressed && !shotgunPumping) {
            if(checkAmmo() == true) {
                switch(Playstate.instance.Player.CurWeaponChoice) { //remove some ammo when we fire the gun
                    case PISTOLROUNDS: //howd i forget this?? :man_facepalm:
                        if(FlxG.mouse.justPressed) {
                            Playstate.instance.Player.PistolAmmoRemaining--;
                            trace('Pistol Bullet Shot!');
                            gun.shoot();
                            Playstate.instance.FGCAM.shake(0.001, 0.1);
                            Playstate.instance.HUDCAM.shake(0.001, 0.1);
                            Playstate.instance.camera.shake(0.001, 0.1);
                        }
                    case RIFLEROUNDS:
                        if (RIFLEfireTimer >= RIFLEfireRate) {
                            Playstate.instance.Player.RifleAmmoRemaining--;
                            trace('Rifle Bullet Shot!');
                            gun.shoot();
                            RIFLEfireTimer = 0; // Reset the timer after firing
                            Playstate.instance.FGCAM.shake(0.002, 0.1);
                            Playstate.instance.HUDCAM.shake(0.002, 0.1);
                            Playstate.instance.camera.shake(0.002, 0.1);
                        }
                    case SHOTGUNSHELL:
                        if(FlxG.mouse.justPressed) {
                            Playstate.instance.Player.ShotgunAmmoRemaining--;
                            trace('Shotgun Fired!');
                            gun.shotgunShoot();
                            shotgunPumping = true;
                            wait(0.2, ()->{ trace('shotgun pumping...'); });
                            wait(0.5, ()->{ shotgunPumping = false; trace('shotgun pumped!'); }); //shotgun pumping!
                            Playstate.instance.FGCAM.shake(0.005, 0.1);
                            Playstate.instance.HUDCAM.shake(0.005, 0.1);
                            Playstate.instance.camera.shake(0.005, 0.1);
                        }
                    case SMGROUNDS:
                        Playstate.instance.Player.SMGAmmoRemaining--;
                        trace('SMG Bullet Shot!');
                        gun.shoot();
                        Playstate.instance.FGCAM.shake(0.001, 0.1);
                        Playstate.instance.HUDCAM.shake(0.001, 0.1);
                        Playstate.instance.camera.shake(0.001, 0.1);
                }
            }
            else {
                FlxFlicker.flicker(Playstate.instance.Hud.ammocounter_AMMONUMONE, 2, 0.1, true, false);
                FlxFlicker.flicker(Playstate.instance.Hud.ammocounter_AMMOSLASH, 2, 0.1, true, false);
                FlxFlicker.flicker(Playstate.instance.Hud.ammocounter_AMMONUMTWO, 2, 0.1, true, false);
                trace('selected ammo type is empty!');
                //play empty ammo noise
            }
        }
        #else
        #end
    }
    function checkAmmo():Bool {
        switch(Playstate.instance.Player.CurWeaponChoice) {
            case PISTOLROUNDS:
                if(Playstate.instance.Player.PistolAmmoRemaining > 0)
                    return true;
                else
                    return false;
            case SHOTGUNSHELL:
                if(Playstate.instance.Player.ShotgunAmmoRemaining > 0)
                    return true;
                else
                    return false;
            case RIFLEROUNDS:
                if(Playstate.instance.Player.RifleAmmoRemaining > 0)
                    return true;
                else
                    return false;
            case SMGROUNDS:
                if(Playstate.instance.Player.SMGAmmoRemaining > 0)
                    return true;
                else
                    return false;
        }
    }
    #if !mobile
    public function AimAtCusor()
        {
            var Mouse:FlxPoint = FlxG.mouse.getPosition();
            angle = FlxAngle.angleBetweenPoint(this, Mouse, true); // now the aimer will be at teh same angle as the bullets when fired :/

            //flip the player based on what angle is current
            if(Aimer.curAngle < -90 || Aimer.curAngle > 90)
                this.flipY = true;
            else
                this.flipY = false;
        }
    #else
    //TODO: IMPLEMENT MOBILE SUPPORT FOR THE AIMER
    #end
}
#else
//TODO: android aim system, joystick maybe?
#end