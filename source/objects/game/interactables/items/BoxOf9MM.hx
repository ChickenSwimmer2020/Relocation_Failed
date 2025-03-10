package objects.game.interactables.items;

@:keep
class BoxOf9MM extends BaseItem {
	public function new(parent:Item) {
		super(parent);
		statusMessage = 'Pistol Ammo Refilled!';
		onPickup = () -> {
			for (weapon in ps.Player.weaponInventory) {
				if (weapon == null)
					continue;
				if (weapon.weaponType == PISTOL)
					weapon.ammoRemaining == weapon.ammoCap;
			}
		};
	}

	override function get_returnCondition():Bool
		return ps.Player.suit != null;
}
