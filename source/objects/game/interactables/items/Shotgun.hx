package objects.game.interactables.items;

import objects.game.controllables.Player;

@:keep
class Shotgun extends BaseWeapon {
	public function new(parent:Item) {
		super(parent);
		weaponType = SHOTGUN;
		ammoCap = 75;
		ammoRemaining = 75;
		statusMessage = 'Shotgun Acquired!';
		onPickup = () -> {
			var plr:Player = ps.Player;
			if (plr.gun.theGunTexture.alpha == 0)
				plr.gun.theGunTexture.alpha = 1;
			plr.CurWeaponChoice = SHOTGUNSHELL;
			plr.weaponInventory.set(plr.weaponInventory.getNextFreeInIntMap(), this);
			plr.updateWeapon();
		};
	}

	override public function onSelected(plr:Player) {
		plr.CurWeaponChoice = SHOTGUNSHELL;
		plr.gun.changeTexture(15, 15, 'game/W_shotgun', true, 128, 64);
	}
}
