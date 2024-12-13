package objects;

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

	public var isMoving:Bool = false;
    public var stamina:Int = 100;
    #if (flixel >= "6.0.0")
    public var health:Int = 100;
    #end
    public var maxStamina:Int = 100;
    public var maxHealth:Int = 100;

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
	}

    public function CheckCollision(obj:FlxSprite):Bool {
        if(this.overlaps(obj)) {
            trace('player is colliding!');
            FlxG.collide(this, obj, null);
            return true;
        } else {
            return false;
        }
    }

	function checkForPauseMenu() {
        #if !mobile
		if (FlxG.keys.anyPressed([ESCAPE]))
			FlxG.state.openSubState(new substates.PauseMenuSubState());
        #else
        if (HUD.virtualPad.buttonC.pressed)
            FlxG.state.openSubState(new substates.PauseMenuSubState()); //support for mobile pausing
        #end
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
        #if !mobile
        AimerPOSx = this.x;
        AimerPOSy = this.y;
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
    public function new() {
        super();
		loadGraphic(Assets.image('Player_upper'), true, 32, 32, true);
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        this.x = Player.AimerPOSx;
        this.y = Player.AimerPOSy;
        #if !mobile
        AimAtCusor();
        #else
        //TODO: DO THIS
        #end
        curAngle = this.angle;
    }
    #if !mobile
    public function AimAtCusor()
        {
            //angle is a float, singular number between 360, and -360. somehow, i need to get a value like that from the mouse coords. how the fuck does that work???
            //answer: triga-fucking-nomitry.
            angle = Functions.getSpriteAngleFromMousePos();
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