package objects.game.controllables;

import objects.game.interactables.items.*;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.effects.FlxFlicker;

class Aimer extends RFTriAxisSprite {
	static public var curAngle:Float;

	public var shotgunPumping:Bool = false; // so we can make sure that you cant fire while the shotgun is pumping
	public var gun:Gun = new Gun();
	public var GunGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var ps:Playstate;
	public var player:Player;

	var RIFLEfireRate:Float = 0.1; // Time between shots in seconds
	var RIFLEfireTimer:Float = 0; // Tracks time since the last shot

	var SMGfireRate:Float = 0.07; // Time between shots in seconds
	var SMGfireTimer:Float = 0; // Tracks time since the last shot

	public function new(ps:Playstate) {
		this.ps = ps;
		player = ps.Player;
        super(player.x, player.y, player.z);
		loadGraphic(Assets.image('game/Player_upper'), true, 32, 32, true);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		RIFLEfireTimer += elapsed;
		SMGfireTimer += elapsed;
		tX = Player.AimerPOSx;
		tY = Player.AimerPOSy;
        tZ = Player.AimerPOSz;
		updateHitbox(); // since angle stuff changes, we want this to update. right?
		AimAtCusor();
		curAngle = angle;

		// we need to calculate the shooting from the player so we can check ammo numberss
		if (FlxG.mouse.pressed && !shotgunPumping) {
			if (checkAmmo() == true) {
				switch (player.CurWeaponChoice) { // remove some ammo when we fire the gun
					case PISTOLROUNDS: // howd i forget this?? :man_facepalm:
						if (FlxG.mouse.justPressed) {
							var pistol:Pistol = new Pistol(null);
							for (weapon in player.weaponInventory) {
								if (weapon.weaponType == PISTOL) {
									pistol = cast weapon;
									break;
								}
							}
							pistol.ammoRemaining--;
							gun.shoot(PISTOLROUNDS);
							Playstate.instance.Player.physVelocity.x -= 10;
							ps.FGCAM.shake(0.001, 0.1);
							ps.HUDCAM.shake(0.001, 0.1);
							ps.camera.shake(0.001, 0.1);
							pistol.remove();
							pistol = null;
						}
					case RIFLEROUNDS:
						if (RIFLEfireTimer >= RIFLEfireRate) {
							var rifle:Rifle = new Rifle(null);
							for (weapon in player.weaponInventory) {
								if (weapon.weaponType == RIFLE) {
									rifle = cast weapon;
									break;
								}
							}
							rifle.ammoRemaining--;
							gun.shoot(RIFLEROUNDS);
							Playstate.instance.Player.physVelocity.x -= 60;
							RIFLEfireTimer = 0; // Reset the timer after firing
							ps.FGCAM.shake(0.002, 0.1);
							ps.HUDCAM.shake(0.002, 0.1);
							ps.camera.shake(0.002, 0.1);
							rifle.remove();
							rifle = null;
						}
					case SHOTGUNSHELL:
						if (FlxG.mouse.justPressed) {
							var shotgun:Shotgun = new Shotgun(null);
							for (weapon in player.weaponInventory) {
								if (weapon.weaponType == SHOTGUN) {
									shotgun = cast weapon;
									break;
								}
							}
							shotgun.ammoRemaining--;
							gun.shotgunShoot();
							shotgunPumping = true;
							Playstate.instance.Player.physVelocity.x -= 500;
							wait(0.2, () -> {
								trace('shotgun pumping...');
								ps.AimerGroup.members[0].animation.play('Cock', true);
							});
							wait(0.5, () -> {
								shotgunPumping = false;
								trace('shotgun pumped!');
							}); // shotgun pumping!
							ps.FGCAM.shake(0.005, 0.1);
							ps.HUDCAM.shake(0.005, 0.1);
							ps.camera.shake(0.005, 0.1);
							shotgun.remove();
							shotgun = null;
						}
					case SMGROUNDS:
						if (SMGfireTimer >= SMGfireRate) {
							var smg:SMG = new SMG(null);
							for (weapon in player.weaponInventory) {
								if (weapon.weaponType == SMG) {
									smg = cast weapon;
									break;
								}
							}
							smg.ammoRemaining--;
							gun.shoot(SMGROUNDS);
							Playstate.instance.Player.physVelocity.x -= 50;
							SMGfireTimer = 0;
							ps.FGCAM.shake(0.001, 0.1);
							ps.HUDCAM.shake(0.001, 0.1);
							ps.camera.shake(0.001, 0.1);
							smg.remove();
							smg = null;
						}
					case NULL:
						// donothing hahaha.
				}
			} else {
				if (ps.Hud.ammocounter_AMMONUMONE != null
					&& ps.Hud.ammocounter_AMMOSLASH != null
					&& ps.Hud.ammocounter_AMMONUMTWO != null) {
					FlxFlicker.flicker(ps.Hud.ammocounter_AMMONUMONE, 2, 0.1, true, false);
					FlxFlicker.flicker(ps.Hud.ammocounter_AMMOSLASH, 2, 0.1, true, false);
					FlxFlicker.flicker(ps.Hud.ammocounter_AMMONUMTWO, 2, 0.1, true, false);
					// play empty ammo noise
				}
			}
		}
	}

	function checkAmmo():Bool {
		switch (player.CurWeaponChoice) {
			case PISTOLROUNDS:
				return player.gunData.PistolAmmoRemaining > 0;
			case SHOTGUNSHELL:
				return player.gunData.ShotgunAmmoRemaining > 0;
			case RIFLEROUNDS:
				return player.gunData.RifleAmmoRemaining > 0;
			case SMGROUNDS:
				return player.gunData.SMGAmmoRemaining > 0;
			case NULL:
				return false;
		}
	}

	public function AimAtCusor() {
		var Mouse:FlxPoint = FlxG.mouse.getPosition();
		angle = FlxAngle.angleBetweenPoint(this, Mouse, true); // now the aimer will be at teh same angle as the bullets when fired :/

		// flip the player based on what angle is current
		if (Aimer.curAngle < -90 || Aimer.curAngle > 90)
			this.flipY = true;
		else
			this.flipY = false;
	}
}

class InteractionBox extends FlxSprite {
	public function new() {
		super();
		makeGraphic(15, 15, FlxColor.WHITE);
		this.scrollFactor.set();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if(FlxG.mouse.justPressed) {
			this.color = FlxColor.BLUE;
			wait(0.5, ()->{
				this.color = FlxColor.WHITE;
			});
		}
	}
}
