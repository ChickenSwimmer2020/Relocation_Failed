package objects.game.interactables.items;

@:keep
class SuitBattery extends BaseItem {
	public function new(parent:Item) {
		super(parent);
		statusMessage = 'Battery Recharged By 15%!';
		onPickup = () -> {
			ps.Player.battery += 15;
		};
	}

	override function get_returnCondition():Bool
		return ps.Player.suit != null;
}
