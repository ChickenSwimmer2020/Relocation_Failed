package objects;

import backend.Assets;
import substates.PausemenuSubState;
import backend.HUD;

class Player extends FlxSprite {
	public var SPEED:Float = 300;
	public var DRAG:Float = 1000;

	private var isSprinting:Bool = false;
	var isMoving:Bool = false;

	

	public function new(xPos:Float, yPos:Float) {
		super(xPos, yPos);
		// makeGraphic(50, 50, FlxColor.LIME); //OLD
		loadGraphic(Assets.image('Player'), true, Std.int(101.2), 215, true);
		drag.x = DRAG;
		drag.y = DRAG;

		animation.add("idle", [1], 30, false, false, false);

		animation.add("left", [2], 30, false, false, false);
		animation.add("right", [0], 30, false, false, false);
		animation.add("up", [3], 30, false, false, false);
		animation.add("down", [4], 30, false, false, false);

		animation.play('idle');
	}

	function checkForPauseMenu() {
		final escape = FlxG.keys.anyPressed([ESCAPE]);

		if (escape) {
			FlxG.state.openSubState(new substates.PausemenuSubState());
		}
	}

	function movement() {
		final left = FlxG.keys.anyPressed([LEFT, A]);
		final right = FlxG.keys.anyPressed([RIGHT, D]);
		final up = FlxG.keys.anyPressed([UP, W]);
		final down = FlxG.keys.anyPressed([DOWN, S]);
		final sprint = FlxG.keys.anyPressed([SHIFT, SHIFT]);

		if (sprint && !isSprinting && HUD.STAMINA > 10 && isMoving) {
			SPEED = SPEED * 1.25;
			DRAG = DRAG * 5;
			isSprinting = true;
		} else if (isSprinting && !sprint || HUD.STAMINA == 0) {
			SPEED = 300;
			DRAG = 1000;
			isSprinting = false;
			if(isMoving) //quick fix so that stamina hopefully comes back even while moving
				isSprinting = false;
		}

		if (left || right || up || down) {
			if (left)
				animation.play("left");
				isMoving = true;
			if (right)
				animation.play("right");
				isMoving = true;
			if (up)
				animation.play("up");
				isMoving = true;
			if (down)
				animation.play("down");
				isMoving = true;
		} else {
			animation.play("idle");
			isMoving = false;
		}

		if (right) {
			velocity.x = SPEED;
		} else if (left) {
			velocity.x = -SPEED;
		}

		if (left && right) {
			velocity.x = 0;
			animation.play('idle');
		}

		if (up) {
			velocity.y = -SPEED;
		} else if (down) {
			velocity.y = SPEED;
		}

		if (up && down) {
			velocity.y = 0;
			animation.play('idle');
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		movement();
		checkForPauseMenu();
		#if debug
		FlxG.watch.addQuick('Stamina', HUD.STAMINA);
		FlxG.watch.addQuick('Speed', SPEED);
		#end

		if(HUD.STAMINA < 20)
			SPEED = 300;
		
		if(isSprinting && HUD.STAMINA != 0 && isMoving){
			HUD.STAMINA -= 1;
		}
		if (!isSprinting) {
			if(HUD.STAMINA < 100)
				HUD.STAMINA += 1;
		}
	}
}
