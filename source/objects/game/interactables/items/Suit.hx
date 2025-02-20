package objects.game.interactables.items;

class Suit extends BaseItem {
	var startChecking:Bool = false;

	public function new(parent:Item) {
		super(parent);
		customPickupCallback = () -> {
			ps.Player.GotSuitFirstTime = true;
			wait(3, () -> {
				startChecking = true;
			});
		};
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (startChecking) {
			if (!ps.Hud.StatMSGContainer.doingCoolIntro) {
				startChecking = false;
				ps.Player.suit = this;
				ps.Player.GotSuitFirstTime = false;
			}
		}
	}
}
