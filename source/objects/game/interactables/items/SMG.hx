package objects.game.interactables.items;

import objects.game.controllables.Player;

@:keep
class SMG extends BaseWeapon {
	public function new(parent:Item) {
		super(parent);
		weaponType = SMG;
		ammoCap = 900;
		ammoRemaining = 900;
		statusMessage = 'Submachine Gun Acquired!';
		onPickup = () -> {
			var plr:Player = ps.Player;
			plr.CurWeaponChoice = SMGROUNDS;
			plr.weaponInventory.set(plr.weaponInventory.getNextFreeInIntMap(), this);
			plr.updateWeapon();
		};
	}

	override public function onSelected(plr:Player) {
		plr.CurWeaponChoice = SMGROUNDS;
		plr.gun.changeTexture(15, 15, 'game/W_smg', false, 128, 64);
	}
}
