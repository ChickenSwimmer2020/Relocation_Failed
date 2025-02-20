package objects.game.interactables.items;

class RifleRoundsBox extends BaseItem {
	public function new(parent:Item) {
		super(parent);
		statusMessage = 'Rifle Ammo Refilled!';
		onPickup = () -> {
			for (weapon in ps.Player.weaponInventory) {
				if (weapon == null)
					continue;
				if (weapon.weaponType == RIFLE)
					weapon.ammoRemaining += weapon.ammoCap;
			}
		};
	}

	override function get_returnCondition():Bool
		return ps.Player.suit != null;
}
