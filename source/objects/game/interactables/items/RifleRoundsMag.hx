package objects.game.interactables.items;

@:keep
class RifleRoundsMag extends BaseItem {
	public function new(parent:Item) {
		super(parent);
		statusMessage = 'Rifle Ammo +25!';
		onPickup = () -> {
			for (weapon in ps.Player.weaponInventory) {
				if (weapon == null)
					continue;
				if (weapon.weaponType == RIFLE)
					weapon.ammoRemaining += 25;
			}
		};
	}

	override function get_returnCondition():Bool
		return ps.Player.suit != null;
}
