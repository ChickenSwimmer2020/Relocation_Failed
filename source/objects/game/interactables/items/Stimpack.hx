package objects.game.interactables.items;

class Stimpack extends BaseItem {
	public function new(parent:Item) {
		super(parent);
		statusMessage = 'administering medical assistance...';
		onPickup = () -> {
			ps.Player.Health += 25; // TODO: make it change the value depending on player health and suit
			wait(parent._STATMSGWAITTIME, () -> {
				ps.Hud.StatMSGContainer.CreateStatusMessage('Health Restored By [CHANGABLE VALUE]%!', parent._STATMSGTWEENTIME, parent._STATMSGWAITTIME,
					parent._STATMSGFINISHYPOS);
			});
		};
	}

	override function get_returnCondition():Bool
		return ps.Player.suit != null;
}
