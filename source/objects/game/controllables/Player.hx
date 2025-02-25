package objects.game.controllables;

import math.XYZWHObj;
import backend.level.Level.LevelSprite;
import objects.RFPhysTriAxisSprite.Vector3;
import objects.game.interactables.items.BaseWeapon.WeaponType;
import haxe.ds.IntMap;
import objects.game.interactables.items.*;
import openfl.events.MouseEvent;
import flixel.effects.FlxFlicker;
import backend.Functions;
import backend.Assets;
import substates.PauseMenuSubState;
import objects.game.controllables.Gun;

typedef PhysicProperties = {
	var speed:Float;
	var drag:Float;
}

enum abstract MovementDirection(String) from String to String {
	var up = 'up';
	var down = 'down';
	var left = 'left';
	var right = 'right';
	var none = 'idle';
}

typedef PlayerGunData = {
	var PistolAmmoRemaining:Int;
	var PistolAmmoCap:Int;
	var ShotgunAmmoRemaining:Int;
	var ShotgunAmmoCap:Int;
	var RifleAmmoRemaining:Int;
	var RifleAmmoCap:Int;
	var SMGAmmoRemaining:Int;
	var SMGAmmoCap:Int;
	var hasPistol:Bool;
	var hasShotgun:Bool;
	var hasRifle:Bool;
	var hasSMG:Bool;
	var hasSuit:Bool;
}

class Player extends RFPhysTriAxisSprite {
	public var nonSprintPhysProps:PhysicProperties = {
		speed: 300,
		drag: 7
	};
	public var sprintPhysProps:PhysicProperties = {
		speed: 400,
		drag: 14
	};
	public var curPhysProperties:PhysicProperties;
	public var curMovementDir:MovementDirection;
    public var canMove:Bool = true;

	public var gun:Gun = new Gun();

	public var CurWeaponChoice:Bullet.BulletType;
	public var curWeaponTypeIndex:Int = -1;
	public var weaponTypes:Array<WeaponType> = [PISTOL, SHOTGUN, RIFLE, SMG];
	public var weaponInventory:IntMap<BaseWeapon> = [0 => null, 1 => null, 2 => null, 3 => null,];

	// guns and current availability storage
	public var GotSuitFirstTime:Bool = false;
	public var suit:Suit = null;
	public var gunData(get, null):PlayerGunData;

	function get_gunData():PlayerGunData {
		var data:PlayerGunData = {
			PistolAmmoRemaining: 0,
			PistolAmmoCap: 0,
			ShotgunAmmoRemaining: 0,
			ShotgunAmmoCap: 0,
			RifleAmmoRemaining: 0,
			RifleAmmoCap: 0,
			SMGAmmoRemaining: 0,
			SMGAmmoCap: 0,
			hasPistol: false,
			hasShotgun: false,
			hasRifle: false,
			hasSMG: false,
			hasSuit: false
		};
		data.hasSuit = !(suit == null);
		for (weapon in weaponInventory) {
			if (weapon == null)
				continue;
			switch (weapon.weaponType) {
				case PISTOL:
					data.hasPistol = true;
					data.PistolAmmoRemaining = weapon.ammoRemaining;
					data.PistolAmmoCap = weapon.ammoCap;
				case SHOTGUN:
					data.hasShotgun = true;
					data.ShotgunAmmoRemaining = weapon.ammoRemaining;
					data.ShotgunAmmoCap = weapon.ammoCap;
				case RIFLE:
					data.hasRifle = true;
					data.RifleAmmoRemaining = weapon.ammoRemaining;
					data.RifleAmmoCap = weapon.ammoCap;
				case SMG:
					data.hasSMG = true;
					data.SMGAmmoRemaining = weapon.ammoRemaining;
					data.SMGAmmoCap = weapon.ammoCap;
				default:
			}
		}
		return data;
	}

	public var isMoving:Bool = false;
	public var stamina:Float = 100;
	public var Health:Float = 100;
	public var displayHealth:Float = 100;
	public var useDisplayHealthAsRealHealth:Bool = false; // used for the hud intro animation since we cant lower Health actually.
	public var oxygen:Float = 200;
	public var battery:Float = 500;

	public var maxStamina:Float = 100;
	public var maxHealth:Float = 100;
	public var maxOxygen:Float = 200;
	public var maxBattery:Float = 500;

	public var playstate:Playstate;
	public var doubleAxisColliders:Array<RFTriAxisSprite> = [];
	public var tripleAxisColliders:Array<LevelSprite> = [];
	
	public static var AimerPOSx:Float;
    public static var AimerPOSy:Float;
    public static var AimerPOSz:Float;

	public var CurRoom:String;

	public var Transitioning:Bool = false;

	public function new(xPos:Float, yPos:Float, zPos:Float, playstate:Playstate) {
		super(xPos, yPos, zPos);
		Health = 100;
		this.playstate = playstate;
		curPhysProperties = nonSprintPhysProps;
		loadGraphic(Assets.image('game/Player_LEGS'), true, 51, 51, true);
		physDrag.setTo(curPhysProperties.drag, curPhysProperties.drag, curPhysProperties.drag);

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
		CurWeaponChoice = NULL; // prevent a crash from the hud trying to read the curweaponchoice as null
		gun.changeTexture(1, 1, 'game/W_pistol', false, 64,
			64); // placeholder, dont want a gaphic but want at minimum for the sprite to exist to prevent null access.
		gun.theGunTexture.alpha = 0;
	}

	public var doubleAxisColliding:Bool = false;

	public function doubleAxisCollide() {
		doubleAxisColliding = false;
		for (obj in doubleAxisColliders)
			doubleAxisColliding = doubleAxisSeparate(obj);
	}

	public function doubleAxisSeparate(obj:RFTriAxisSprite):Bool {
		var overlapX = (x + width > obj.x) && (x < obj.x + obj.width);
		var overlapY = (y + height > obj.y) && (y < obj.y + obj.height);

		if (overlapX && overlapY) {
			var overlapWidth = Math.min(x + width - obj.x, obj.x + obj.width - x);
			var overlapHeight = Math.min(y + height - obj.y, obj.y + obj.height - y);

			if (overlapWidth < overlapHeight) {
				if (x < obj.x) {
					tX -= overlapWidth;
				} else {
					tX += overlapWidth;
				}
			} else {
				if (z < obj.y) {
					tZ -= overlapHeight;
				} else {
					tZ += overlapHeight;
				}
			}
			return true;
		}
		return false;
	}

	public var tripleAxisColliding:Bool = false;

	public function tripleAxisCollide() {
		tripleAxisColliding = false;
		for (obj in tripleAxisColliders)
			tripleAxisColliding = tripleAxisSeparate(obj);
	}

	public function tripleAxisSeparate(object:LevelSprite):Bool {
        var obj:XYZWHObj = new XYZWHObj(Std.int(object.x), Std.int(object.y), Std.int(object.z + object.indentationPixels), Std.int(Math.abs(object.width)), Std.int(Math.abs(object.height)));
        var pZ = z + height;
        var overlapX:Bool = (x + width > obj.x) && (x < obj.x + obj.width);
        var overlapZ:Bool = (z + height > obj.z) && (pZ < obj.z + obj.height);
        
        if (overlapX && overlapZ) {
            var overlapDepthX:Float = Math.min(x + width - obj.x, obj.x + obj.width - x);
            var overlapDepthZ:Float = 0;
            if (z < obj.z) 
                overlapDepthZ = Math.min(z + height - obj.z, obj.z + obj.height - z);
            else
                overlapDepthZ = Math.min(pZ + height - obj.z, obj.z + obj.height - pZ);
            
            if (overlapDepthX < overlapDepthZ) {
                if (x < obj.x) {
                    tX -= overlapDepthX;
                } else {
                    tX += overlapDepthX;
                }
            } else {
                if (z < obj.z) {
                    tZ -= overlapDepthZ;
                } else {
                    tZ += overlapDepthZ;
                }
            }
            return true;
        }
        return false;
	}

	function resetPauseMenu() {
		if (PauseMenuSubState.PauseJustClosed) {
			var tmr:FlxTimer = new FlxTimer();
			tmr.start(1, function(tmr:FlxTimer) {
				PauseMenuSubState.PauseJustClosed = false;
			});
		}
	}

	function checkForPauseMenu() {
		if (FlxG.keys.anyPressed([ESCAPE]) && !PauseMenuSubState.PauseJustClosed) { // so the pause menu can be closed with the escape key and not instantly reopen
			FlxG.state.openSubState(new substates.PauseMenuSubState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.pause();
		}
	}

	function forceCaps() {
		if (Health > maxHealth) // we dont want our Health to go above 100, this should work for now until we get a better system in
			Health -= 10;
        
		// insert the suit/armor stuff here.
		if (battery > maxBattery)
			battery = maxBattery;
	}

	function hasWeapon(weaponType:WeaponType):Bool {
		for (weapon in weaponInventory)
			if (weapon.weaponType == weaponType)
				return true;
		return false;
	}

	private function onMouseWheel(event:MouseEvent):Void {
		if (event.delta != 0) {
			if (event.delta > 0) // up
				curWeaponTypeIndex = (curWeaponTypeIndex - 1 + weaponTypes.length) % weaponTypes.length;
			else // down
				curWeaponTypeIndex = (curWeaponTypeIndex + 1) % weaponTypes.length;
		}
		updateWeapon();
	}

	public function updateWeapon():Void {
		if (weaponInventory.get(curWeaponTypeIndex) == null) {
			gun.theGunTexture.alpha = 0;
			CurWeaponChoice = NULL;
			return;
		}
		FlxFlicker.stopFlickering(Playstate.instance.Hud.ammocounter_AMMONUMONE);
		FlxFlicker.stopFlickering(Playstate.instance.Hud.ammocounter_AMMOSLASH);
		FlxFlicker.stopFlickering(Playstate.instance.Hud.ammocounter_AMMONUMTWO);
		trace("Selected weapon: " + weaponTypes[curWeaponTypeIndex]);
		gun.theGunTexture.alpha = 1;
		weaponInventory.get(curWeaponTypeIndex).onSelected(this);
	}

	function movement() {
        if (!canMove)
            return;
		if (FlxG.keys.anyPressed([SHIFT]) && stamina > 0 && isMoving) {
			curPhysProperties = sprintPhysProps;
			stamina--;
		} else {
			curPhysProperties = nonSprintPhysProps;
			if (stamina < 100 && !FlxG.keys.anyPressed([SHIFT]))
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
		// if (isMoving) gun.moveCallback();

		var movementDirs = [
			FlxG.keys.anyPressed([LEFT, A]),
			FlxG.keys.anyPressed([RIGHT, D]),
			FlxG.keys.anyPressed([UP, W]),
			FlxG.keys.anyPressed([DOWN, S])
		];
		var count = 0;
		var allOn = false;
		for (dir in movementDirs)
			if (dir)
				count++;
		if (count == 4)
			allOn = true;
		for (dirID in 0...movementDirs.length) {
			if (movementDirs[dirID])
				switch (dirID) {
					case 0 | 1:
						if (dirID == 0 && !movementDirs[dirID + 1])
							physVelocity.x = -curPhysProperties.speed;
						else if (dirID == 1 && !movementDirs[dirID - 1])
							physVelocity.x = curPhysProperties.speed;
						else
							physVelocity.x = 0;

					case 2 | 3:
						if (dirID == 2 && !movementDirs[dirID + 1])
							physVelocity.z = -curPhysProperties.speed;
						else if (dirID == 3 && !movementDirs[dirID - 1])
							physVelocity.z = curPhysProperties.speed;
						else
							physVelocity.z = 0;

					default:
				}
		}

		if (count < 3) {
			if (movementDirs[2] && movementDirs[0])
				animation.play('DIAGNOAL_upleft');
			if (movementDirs[2] && movementDirs[1])
				animation.play('DIAGNOAL_upright');
			if (movementDirs[3] && movementDirs[0])
				animation.play('DIAGNOAL_downleft');
			if (movementDirs[3] && movementDirs[1])
				animation.play('DIAGNOAL_downright');
		}
		if (movementDirs[0] && movementDirs[1] && movementDirs[3])
			animation.play('down', true);
		if (movementDirs[0] && movementDirs[1] && movementDirs[2])
			animation.play('up', true);

		if (allOn)
			animation.play('idle');
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (!Transitioning) { // prevent a crash by making sure none of this stuff gets called when using a door.
			movement();
			doubleAxisCollide();
			tripleAxisCollide();

			checkForPauseMenu();
			resetPauseMenu();
			forceCaps(); // so variables such as Health and battery dont go above the max
			AimerPOSx = getGraphicMidpoint().x - 15;
            AimerPOSy = tY;
			AimerPOSz = getGraphicMidpoint().y - 15;
			gun.update(elapsed);
			gun.updateTexturePosition(AimerPOSx, AimerPOSz);
			if (useDisplayHealthAsRealHealth)
				Playstate.instance.Player.displayHealth = Playstate.instance.Player.Health; // so we can get actual Health values for the Healthbar
			#if debug
			FlxG.watch.addQuick('Stamina', stamina);
			FlxG.watch.addQuick('Speed', curPhysProperties.speed);
			#end
			if (FlxG.keys.anyJustPressed([ONE, TWO, THREE, FOUR])) {
				if (FlxG.keys.anyJustPressed([ONE])) {
					curWeaponTypeIndex = 0;
				} else if (FlxG.keys.anyJustPressed([TWO])) {
					curWeaponTypeIndex = 1;
				} else if (FlxG.keys.anyJustPressed([THREE])) {
					curWeaponTypeIndex = 2;
				} else if (FlxG.keys.anyJustPressed([FOUR])) {
					curWeaponTypeIndex = 3;
				}
				updateWeapon();
			}
		}
	}

	override function destroy() {
		super.destroy();
		FlxG.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}
}
