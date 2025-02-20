package objects.game.interactables.items;

import objects.game.controllables.Player;

class Rifle extends BaseWeapon {
	public function new(parent:Item) {
		super(parent);
		weaponType = RIFLE;
		ammoCap = 500;
		ammoRemaining = 500;
		statusMessage = 'Rifle Acquired!';
		onPickup = () -> {
			var plr:Player = ps.Player;
			plr.CurWeaponChoice = RIFLEROUNDS;
			plr.weaponInventory.set(plr.weaponInventory.getNextFreeInIntMap(), this);
			plr.updateWeapon();
		};
	}

	override public function onSelected(plr:Player) {
		plr.CurWeaponChoice = RIFLEROUNDS;
	}
}
