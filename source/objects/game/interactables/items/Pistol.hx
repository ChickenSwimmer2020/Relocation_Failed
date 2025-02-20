package objects.game.interactables.items;

import objects.game.controllables.Player;

class Pistol extends BaseWeapon {
	public function new(parent:Item) {
		super(parent);
		weaponType = PISTOL;
		ammoCap = 200;
		ammoRemaining = 200;
		statusMessage = 'Pistol Acquired!';
		onPickup = () -> {
			var plr:Player = ps.Player;
			plr.CurWeaponChoice = PISTOLROUNDS;
			if (plr.gun.theGunTexture.alpha == 0)
				plr.gun.theGunTexture.alpha = 1;
			plr.weaponInventory.set(plr.weaponInventory.getNextFreeInIntMap(), this);
			plr.updateWeapon();
		};
	}

	override public function onSelected(plr:Player) {
		plr.CurWeaponChoice = PISTOLROUNDS;
		plr.gun.changeTexture(15, 15, 'game/W_pistol', false, 64, 64);
	}
}
