package objects.game.interactables.items;

class Buckshell extends BaseItem {
	public function new(parent:Item) {
		super(parent);
		statusMessage = 'Shotgun Ammo +25!';
		onPickup = () -> {
			for (weapon in ps.Player.weaponInventory) {
				if (weapon == null)
					continue;
				if (weapon.weaponType == SHOTGUN)
					weapon.ammoRemaining += 25;
			}
		};
	}

	override function get_returnCondition():Bool
		return ps.Player.suit != null;
}
