package objects.game.interactables.items;

@:keep
class HealthPack extends BaseItem {
	public function new(parent:Item) {
		super(parent);
		statusMessage = 'administering medical assistance...';
		onPickup = () -> {
			ps.Player.Health = ps.Player.maxHealth;
			wait(parent._STATMSGWAITTIME, () -> {
				ps.Hud.StatMSGContainer.CreateStatusMessage('Health Restored!', parent._STATMSGTWEENTIME, parent._STATMSGWAITTIME, parent._STATMSGFINISHYPOS);
			});
		};
	}

	override function get_returnCondition():Bool
		return ps.Player.suit != null;
}
