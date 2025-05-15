package objects.game.controllables;

import objects.game.controllables.Bullet.Shell;
import sys.thread.Thread;
import math.RFMath;
import math.RFVector;
import lunarps.math.LunarInterp;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import backend.Functions;
import flixel.group.FlxSpriteGroup;

using StringTools;

//TODO: rewrite this entire object's code. it is WAY too messy :/

typedef GunData = { //this is the data that can be gotten from [weaponname]_BEHAVIOR.json
	X:Float, //TODO: make work.
	Y:Float,
	Texture:String,
	pumpAction:Bool,
	FrameWidth:Float,
	FrameHeight:Float,
	Damage:Int,
	maxMag:Int,
	maxPool:Int,
	bulletData:{
		DMG:Int, //damage
		SPD:Float, //speed
		TRC:Bool, //tracers
		EJC:Bool, //shell ejection (NOT AN OVERRIDE)
		LBH:Bool //leave bullt holes
	}
}

class Gun extends FlxSpriteGroup {
	/**
	 * the gun texture varible for changing the fun sprites.
	 * @since RF_DEV_0.3.0
	 */
	public var theGunTexture:FlxSprite = new FlxSprite(0, 0);

	/**
	 * the gun textures X position before lerping.
	 * @since RF_DEV_0.3.0
	 */
	public var realGunXPOS:Float;

	/**
	 * the gun textures Y position before lerping.
	 * @since RF_DEV_0.3.0
	 */
	public var realGunYPOS:Float;

	/**
	 * the gun textures ANGLE before lerping
	 * @since RF_DEV_0.3.0
	 */
	public var realGunANGLE:Float;

	public var ratio:Float = 1;

	public var moveCallback:Void->Void;

	public var ContainsAnimation:Bool = false;

	public var ShotgunPassthrough:Bool = false;

	public function new() {
		super();
		// moveCallback = () -> { ratio = 0; }; //this is causing problems somehow
		//TODO: make loading gun data from a json work right.
	}

	/**
	 * Change the Texture of the gun.
	 * ---
	 * @param X the X position of the gun texture, these are seperate so we can have offsets for the guns themselves.
	 * @param Y the Y position of the gun texture, these are seperate so we can have offsets for the guns themselves.
	 * @param Texture texture to use, just put file name, dont include extension.
	 * @param isShotgun is the weapon a shotguntype weapon? defaults to false.
	 * @param FrameWidth how wide is each frame, int. defaults to 64
	 * @param FrameHeight how tall is each frame, int. defaults to 64
	 * @since RF_DEV_0.3.0
	 */
	public function changeTexture(X:Float, Y:Float, Texture:String, isShotgun:Bool = false, FrameWidth:Int = 64, FrameHeight:Int = 64) {
		if (Texture == '') {
			theGunTexture.makeGraphic(0, 0, 0x0);
			return;
		}
		theGunTexture.loadGraphic(Assets.image(Texture), true, FrameWidth, FrameHeight);
		// Add trace to check total frames available
		trace('Total frames in sprite: ${theGunTexture.numFrames}');

		// Make sure animations are initialized
		if (theGunTexture.animation == null) {
			trace("Animation object is null!");
			return;
		}
		ShotgunPassthrough = isShotgun;

		theGunTexture.animation.add('Idle', [0], 24, false, false, false); //added once here to make sure the animations exist.
		theGunTexture.animation.add('Pew', [1, 2, 3, 4, 5], 12, false, false, false);
		if (ShotgunPassthrough) {
			theGunTexture.animation.add('Cock', [6, 7, 8, 9, 10, 11, 12, 13], 12, false, false, false); //accurate name.
		}

		// Verify animations exist
		trace('Available animations: ${[for (name in theGunTexture.animation.getNameList()) name]}');

		theGunTexture.setPosition(X, Y);
		// realGunXPOS = X;
		// realGunYPOS = Y;
		// realGunANGLE = theGunTexture.angle;

		theGunTexture.animation.remove('Idle'); //remove the animations since they arent needed on this sprite.
		theGunTexture.animation.remove('Pew');
		if(ShotgunPassthrough)
			theGunTexture.animation.remove('Cock');

		Playstate.instance.AimerGroup.add(theGunTexture);
		loadRealAnimationData(); // add the animations to the actual gun within playstate itself
		theGunTexture.animation.play('Idle');
	} // i mean, if we're having different guns. we need textures!

	public function updateTexturePosition(X:Float, Y:Float) {
		realGunXPOS = X;
		realGunYPOS = Y;
	}

	public function loadRealAnimationData() {
		// Add animations and verify they were added
		Playstate.instance.AimerGroup.members[0].animation.add('Idle', [0], 24, false, false, false);
		Playstate.instance.AimerGroup.members[0].animation.add('Pew', [1, 2, 3, 4, 5], 12, false, false, false);
		if (ShotgunPassthrough) {
			Playstate.instance.AimerGroup.members[0].animation.add('Cock', [6, 7, 8, 9, 10, 11, 12, 13], 12, false, false, false);
		}
	}

	public function shoot(WeaponType:Bullet.BulletType) {
		var OffsetX:Float;
		var OffsetY:Float;
		var EJECTOffsetX:Float;
		var EJECTOffsetY:Float;
		switch (WeaponType) {
			case PISTOLROUNDS:
				OffsetX = 30;
				OffsetY = 30;
				EJECTOffsetX = 30;
				EJECTOffsetY = 30;
			case SHOTGUNSHELL:
				OffsetX = 0; // not needed, offsets for the shotgun are forced since its a single weapon type, just kept to prevent errors.
				OffsetY = 0;
				EJECTOffsetX = 0;
				EJECTOffsetY = 0;
			case SMGROUNDS:
				OffsetX = 0;
				OffsetY = 0;
				EJECTOffsetX = 0;
				EJECTOffsetY = 0;
			case RIFLEROUNDS:
				OffsetX = 0;
				OffsetY = 0;
				EJECTOffsetX = 0;
				EJECTOffsetY = 0;
			default: // default the bullet fire offsets. prevents null access
				OffsetX = 0;
				OffsetY = 0;
				EJECTOffsetX = 0;
				EJECTOffsetY = 0;
		}
		var mousePos = FlxG.mouse.getPosition();
		Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.x + OffsetX, Playstate.instance.Player2.y + OffsetY, mousePos,
			Playstate.instance.Player.CurWeaponChoice, Preferences.save.bulletTracers));
		Playstate.instance.AimerGroup.members[0].x -= 10;
		////Playstate.instance.AimerGroup.members[0].angle -= 15;
		theGunTexture.x = -15;
		////theGunTexture.angle = -15;
		Playstate.instance.AimerGroup.members[0].animation.play('Pew', true);
		if(Preferences.save.ShellEjection)
			Shell.EjectShell(WeaponType, {X: EJECTOffsetX, Y: EJECTOffsetY}, new FlxPoint(cast(new FlxRandom().int(-100, 100)), cast(new FlxRandom().int(-100, 100))), false); //should work MUCH better? more customizability.
	}

	public function shotgunShoot() {
		var OffsetX:Float = 15;
		var OffsetY:Float = 15;
		var EJECTOffsetX:Float = 15;
		var EJECTOffsetY:Float = 15;
		Playstate.instance.AimerGroup.members[0].animation.play('Pew', true);
		var Spread:Array<FlxPoint> = getShotgunSpread(FlxG.mouse.getPosition(), Playstate.instance.Player2.angle, 240, 9, 100);
		for (spread in 0...8)
			Playstate.instance.BulletGroup.add(new Bullet(Playstate.instance.Player2.x + OffsetX, Playstate.instance.Player2.y + OffsetY, Spread[spread],
				SHOTGUNSHELL, true));
		Shell.EjectShell(Playstate.instance.Player.CurWeaponChoice, {X: EJECTOffsetX, Y: EJECTOffsetY}, new FlxPoint(cast(new FlxRandom().int(-100, 100)), cast(new FlxRandom().int(-100, 100))), true);
	}

	//TODO: re-write this, was coded by chatgpt and isnt the best.
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

	override public function update(elapsed:Float) {
		super.update(elapsed);
		this.angle = Playstate.instance.Player2.angle; // change the group angle to the players instead of the gun, since it will move the gun with it and hopefully center the guns rotation possibly.
		if (ratio < 1)
			ratio += 0.0001;
	}
}
