package objects.game.interactables.items;

@:keep
class Suit extends BaseItem {
	var startChecking:Bool = false;

	public function new(parent:Item) {
		super(parent);
		customPickupCallback = () -> {
			ps.Player.GotSuitFirstTime = true;
			wait(3, () -> {
				startChecking = true;
				trace('TODO: make awsome cutscene for getting the suit for the first time once we make that area where you obtain the suit');
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
