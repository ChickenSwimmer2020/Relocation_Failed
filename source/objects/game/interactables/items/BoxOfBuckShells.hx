package objects.game.interactables.items;

class BoxOfBuckShells extends BaseItem {
	public function new(parent:Item) {
		super(parent);
		statusMessage = 'Shotgun Ammo Refilled!';
		onPickup = () -> {
			for (weapon in ps.Player.weaponInventory) {
				if (weapon == null)
					continue;
				if (weapon.weaponType == SHOTGUN)
					weapon.ammoRemaining == weapon.ammoCap;
			}
		};
	}

	override function get_returnCondition():Bool
		return ps.Player.suit != null;
}
