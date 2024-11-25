package objects;

import backend.Assets;
import substates.PauseMenuSubState;

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
    public var curPhysProperties:PhysicProperties;
    public var curMovementDir:MovementDirection;

	public var isMoving:Bool = false;
    public var stamina:Int = 100;
    public var maxStamina:Int = 100;
    public var maxHealth:Int = 100;

	public var playstate:Playstate;

	public function new(xPos:Float, yPos:Float, playstate:Playstate) {
		super(xPos, yPos);
        health = 100;
        this.playstate = playstate;
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
		if (FlxG.keys.anyPressed([SHIFT]) && stamina > 0 && isMoving){
			curPhysProperties = sprintPhysProps;
            stamina--;
        }else{
			curPhysProperties = nonSprintPhysProps;
            if(stamina < 100 && !FlxG.keys.anyPressed([SHIFT]))
                stamina++;
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

        var movementDirs = [FlxG.keys.anyPressed([LEFT, A]), FlxG.keys.anyPressed([RIGHT, D]), FlxG.keys.anyPressed([UP, W]), FlxG.keys.anyPressed([DOWN, S])];
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
        switch (curMovementDir)
        {
            case right:
                
            case left:
                
            case up:
                
            case down:
                
            default:
                // literally nothing.
        }
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		movement();
		checkForPauseMenu();
		#if debug
		FlxG.watch.addQuick('Stamina', stamina);
		FlxG.watch.addQuick('Speed', curPhysProperties.speed);
		#end
	}
}
