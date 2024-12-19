package objects;

import openfl.events.MouseEvent;
import flixel.effects.FlxFlicker;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.addons.effects.FlxTrail;
import flixel.effects.particles.FlxParticle;
import flixel.addons.effects.chainable.FlxTrailEffect;
import backend.Functions;
import flixel.math.FlxMath;
import backend.Assets;
import substates.PauseMenuSubState;
import backend.HUD;

typedef PhysicProperties = {
    var speed:Float;
    var drag:Float;
}

enum abstract MovementDirection(String) from String to String
{
    var up = 'up';
    var down = 'down';
    var left = 'left';
    var right = 'right';
    var none = 'idle';
}

class Player extends FlxSprite {
    public var nonSprintPhysProps:PhysicProperties = {
        speed: 300,
        drag: 1000
    };
    public var sprintPhysProps:PhysicProperties = {
        speed: 375,
        drag: 5000
    };
    public var collisionPhysProps:PhysicProperties = {
        speed: 300,
        drag: 999999999999
    };
    public var curPhysProperties:PhysicProperties;
    public var curMovementDir:MovementDirection;

    public var CurWeaponChoice:Bullet.BulletType;
    public var currentWeaponIndex:Int = 0;
    public var weapons:Array<String> = ["Pistol", "Shotgun", "Rifle", "Smg"];

    public var PistolAmmoRemaining:Int = 200;
    public var RifleAmmoRemaining:Int = 500;
    public var ShotgunAmmoRemaining:Int = 75;
    public var SMGAmmoRemaining:Int = 900;

    public var PistolAmmoCap:Int = 200; //what are general ammo caps in games?
    public var RifleAmmoCap:Int = 500;
    public var ShotgunAmmoCap:Int = 75;
    public var SMGAmmoCap:Int = 900;

	public var isMoving:Bool = false;
    public var stamina:Int = 100;
    #if (flixel >= "6.0.0")
        public var health:Int = 100;
    #end
    public var oxygen:Int = 200;

    public var maxStamina:Int = 100;
    public var maxHealth:Int = 100;
    public var maxOxygen:Int = 200;

	public var playstate:Playstate;

    public static var AimerPOSy:Float;
    public static var AimerPOSx:Float;

	public function new(xPos:Float, yPos:Float, playstate:Playstate) {
		super(xPos, yPos);
        health = 100;
        this.playstate = playstate;
        curPhysProperties = nonSprintPhysProps;		
        loadGraphic(Assets.image('Player_LEGS'), true, 51, 51, true);
		drag.set(curPhysProperties.drag, curPhysProperties.drag);

		animation.add("idle", [0], 30, false, false, false);

		animation.add("left", [1], 30, false, false, false);
		animation.add("right", [3], 30, false, false, false);
		animation.add("up", [2], 30, false, false, false);
		animation.add("down", [4], 30, false, false, false);

        animation.add("DIAGNOAL_upleft", [5], 30, false, false, false);
        animation.add("DIAGNOAL_upright", [6], 30, false, false, false);
        animation.add("DIAGNOAL_downright", [7], 30, false, false, false);
        animation.add("DIAGNOAL_downleft", [8], 30, false, false, false);

		animation.play('idle');
        FlxG.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        CurWeaponChoice = PISTOLROUNDS; //prevent a crash from the hud trying to read the curweaponchoice as null
	}

    public function CheckCollision(obj:FlxSprite) {
        FlxG.collide(this, obj, null);
    }

    function resetPauseMenu() {
        if(PauseMenuSubState.PauseJustClosed) {
            var tmr:FlxTimer = new FlxTimer();
            tmr.start(1, function(tmr:FlxTimer) {
                PauseMenuSubState.PauseJustClosed = false;
                Functions.traceOnce('pause menu detection has been reset');
            });
        }
    }

	function checkForPauseMenu() {
        #if !mobile
		if (FlxG.keys.anyPressed([ESCAPE]) && !PauseMenuSubState.PauseJustClosed) //so the pause menu can be closed with the escape key and not instantly reopen
			FlxG.state.openSubState(new substates.PauseMenuSubState());
        #else
        if (HUD.virtualPad.buttonC.pressed)
            FlxG.state.openSubState(new substates.PauseMenuSubState()); //support for mobile pausing
        #end
	}

    function forceCaps() {
        if(Playstate.instance.Player.health > Playstate.instance.Player.maxHealth) //we dont want our health to go above 100, this should work for now until we get a better system in
            Playstate.instance.Player.health -= 10; //SHUT UP ABOUT BEING REMOVED SOON :sob:

        //insert the suit/armor stuff here.

        if(Playstate.instance.Player.ShotgunAmmoRemaining > Playstate.instance.Player.ShotgunAmmoCap)
            Playstate.instance.Player.ShotgunAmmoRemaining--;

        if(Playstate.instance.Player.RifleAmmoRemaining > Playstate.instance.Player.RifleAmmoCap)
            Playstate.instance.Player.RifleAmmoRemaining--;

        if(Playstate.instance.Player.PistolAmmoRemaining > Playstate.instance.Player.PistolAmmoCap)
            Playstate.instance.Player.PistolAmmoRemaining--;
    }

    private function onMouseWheel(event:MouseEvent):Void {
        if (event.delta > 0) {
            // Scroll up
            currentWeaponIndex = (currentWeaponIndex - 1 + weapons.length) % weapons.length;
        } else if (event.delta < 0) {
            // Scroll down
            currentWeaponIndex = (currentWeaponIndex + 1) % weapons.length;
        }

        updateWeapon();
    }

    // Update the weapon
    private function updateWeapon():Void {
        trace("Selected weapon: " + weapons[currentWeaponIndex]);
        switch(weapons[currentWeaponIndex]) {
            case 'Pistol':
                CurWeaponChoice = PISTOLROUNDS;
            case 'Shotgun':
                CurWeaponChoice = SHOTGUNSHELL;
            case 'Rifle':
                CurWeaponChoice = RIFLEROUNDS;
            case 'Smg':
                CurWeaponChoice = SMGROUNDS;
        }
    }

	function movement() {
        #if !mobile
		if (FlxG.keys.anyPressed([SHIFT]) && stamina > 0 && isMoving){
			curPhysProperties = sprintPhysProps;
            stamina--;
        }else{
			curPhysProperties = nonSprintPhysProps;
            if(stamina < 100 && !FlxG.keys.anyPressed([SHIFT]))
                stamina++;
        }
        #else
		if (HUD.virtualPad.buttonX.pressed && stamina > 0 && isMoving){ //mobile gamepad support
			curPhysProperties = sprintPhysProps;
            stamina--;
        }else{
			curPhysProperties = nonSprintPhysProps;
            if(stamina < 100 && !HUD.virtualPad.buttonX.pressed)
                stamina++;
        }
        #end

        #if !mobile
        if (FlxG.keys.anyPressed([LEFT, A]))
            curMovementDir = left;
        else if (FlxG.keys.anyPressed([RIGHT, D]))
            curMovementDir = right;
        else if (FlxG.keys.anyPressed([UP, W]))
            curMovementDir = up;
        else if (FlxG.keys.anyPressed([DOWN, S]))
            curMovementDir = down;
        else
            curMovementDir = none;
        #else
        if (HUD.virtualPad.buttonLeft.pressed)
            curMovementDir = left;
        else if (HUD.virtualPad.buttonRight.pressed)
            curMovementDir = right;
        else if (HUD.virtualPad.buttonUp.pressed)
            curMovementDir = up;
        else if (HUD.virtualPad.buttonRight.pressed)
            curMovementDir = down;
        else
            curMovementDir = none;
        #end

		animation.play(curMovementDir);
		isMoving = curMovementDir != none;

        #if !mobile
        var movementDirs = [FlxG.keys.anyPressed([LEFT, A]), FlxG.keys.anyPressed([RIGHT, D]), FlxG.keys.anyPressed([UP, W]), FlxG.keys.anyPressed([DOWN, S])];
        #else
        var movementDirs = [HUD.virtualPad.buttonLeft.pressed, HUD.virtualPad.buttonRight.pressed, HUD.virtualPad.buttonUp.pressed, HUD.virtualPad.buttonRight.pressed];
        #end
        var count = 0;
        var allOn = false;
        for (dir in movementDirs) if (dir) count++;
        if (count == 4)
            allOn = true;
        for (dirID in 0...movementDirs.length)
        {
            if (movementDirs[dirID])
                switch (dirID)
                {
                    case 0 | 1:
                        if (dirID == 0 && !movementDirs[dirID+1])
                            velocity.x = -curPhysProperties.speed;
                        else if (dirID == 1 && !movementDirs[dirID-1])
                            velocity.x = curPhysProperties.speed;
                        else
                            velocity.x = 0;

                    case 2 | 3:
                        if (dirID == 2 && !movementDirs[dirID+1])
                            velocity.y = -curPhysProperties.speed;
                        else if (dirID == 3 && !movementDirs[dirID-1])
                            velocity.y = curPhysProperties.speed;
                        else
                            velocity.y = 0;
                         
                    default:
                }
        }

        if (count < 3){
            if (movementDirs[2] && movementDirs[0]) animation.play('DIAGNOAL_upleft');
            if (movementDirs[2] && movementDirs[1]) animation.play('DIAGNOAL_upright');
            if (movementDirs[3] && movementDirs[0]) animation.play('DIAGNOAL_downleft');
            if (movementDirs[3] && movementDirs[1]) animation.play('DIAGNOAL_downright');
        }
        if (movementDirs[0] && movementDirs[1] && movementDirs[3]) animation.play('down', true);
        if (movementDirs[0] && movementDirs[1] && movementDirs[2]) animation.play('up', true);

        if (allOn) animation.play('idle');
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		movement();
		checkForPauseMenu();
        resetPauseMenu();
        forceCaps(); //so variables such as health and ammo dont go above 100
        #if !mobile
        AimerPOSx = this.getGraphicMidpoint().x - 15;
        AimerPOSy = this.getGraphicMidpoint().y - 15;
        #else
        #end
		#if debug
		FlxG.watch.addQuick('Stamina', stamina);
		FlxG.watch.addQuick('Speed', curPhysProperties.speed);
		#end
	}
}
#if !mobile
class Aimer extends FlxSprite {
    static public var curAngle:Float;
    var shotgunPumping:Bool = false; //so we can make sure that you cant fire while the shotgun is pumping

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
                            Bullet.shoot();
                            Playstate.instance.FGCAM.shake(0.001, 0.1);
                            Playstate.instance.HUDCAM.shake(0.001, 0.1);
                            Playstate.instance.camera.shake(0.001, 0.1);
                        }
                    case RIFLEROUNDS:
                        if (RIFLEfireTimer >= RIFLEfireRate) {
                            Playstate.instance.Player.RifleAmmoRemaining--;
                            trace('Rifle Bullet Shot!');
                            Bullet.shoot();
                            RIFLEfireTimer = 0; // Reset the timer after firing
                            Playstate.instance.FGCAM.shake(0.002, 0.1);
                            Playstate.instance.HUDCAM.shake(0.002, 0.1);
                            Playstate.instance.camera.shake(0.002, 0.1);
                        }
                    case SHOTGUNSHELL:
                        if(FlxG.mouse.justPressed) {
                            Playstate.instance.Player.ShotgunAmmoRemaining--;
                            trace('Shotgun Fired!');
                            Bullet.shotgunShoot();
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
                        Bullet.shoot();
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