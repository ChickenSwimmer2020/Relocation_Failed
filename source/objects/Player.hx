package objects;

import backend.Assets;
import substates.PauseMenuSubState;
import backend.HUD;

typedef PhysicProperties = {
    var speed:Float;
    var drag:Float;
}

enum abstract MovementDirection(String) from String to String
{
    var left = 'left';
    var up = 'up';
    var right = 'right';
    var down = 'down';
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
    public var curPhysProperties:PhysicProperties;
    public var curMovementDir:MovementDirection;
	var isMoving:Bool = false;

	

	public function new(xPos:Float, yPos:Float) {
		super(xPos, yPos);
        curPhysProperties = nonSprintPhysProps;
		loadGraphic(Assets.image('Player'), true, 101, 215, true);
		drag.set(curPhysProperties.drag, curPhysProperties.drag);

		animation.add("idle", [1], 30, false, false, false);

		animation.add("left", [2], 30, false, false, false);
		animation.add("right", [0], 30, false, false, false);
		animation.add("up", [3], 30, false, false, false);
		animation.add("down", [4], 30, false, false, false);

		animation.play('idle');
	}

	function checkForPauseMenu() {
		if (FlxG.keys.anyPressed([ESCAPE]))
			FlxG.state.openSubState(new substates.PauseMenuSubState());
	}

	function movement() {
		if (FlxG.keys.anyPressed([SHIFT]) && HUD.STAMINA > 0 && isMoving){
			curPhysProperties = sprintPhysProps;
            HUD.STAMINA--;
        }else{
			curPhysProperties = nonSprintPhysProps;
            if(HUD.STAMINA < 100 && !FlxG.keys.anyPressed([SHIFT]))
                HUD.STAMINA++;
        }

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

		animation.play(curMovementDir);
		isMoving = curMovementDir != none;

        switch (curMovementDir)
        {
            case right:
                velocity.x = curPhysProperties.speed;
            case left:
                velocity.x = -curPhysProperties.speed;
            case up:
                velocity.y = -curPhysProperties.speed;
            case down:
                velocity.y = curPhysProperties.speed;
            default:
                // literally nothing.
        }
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		movement();
		checkForPauseMenu();
		#if debug
		FlxG.watch.addQuick('Stamina', HUD.STAMINA);
		FlxG.watch.addQuick('Speed', curPhysProperties.speed);
		#end
	}
}
