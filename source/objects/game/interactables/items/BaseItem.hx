package objects.game.interactables.items;

@:keep
class BaseItem extends FlxBasic {
	public var returnCondition(get, null):Bool;
	public var statusMessage:String = '';
	public var onPickup:Void->Void;
	public var parent:Item;
	public var ps:Playstate;
	public var customPickupCallback:Void->Void = ()->{};

	public function new(parent:Item) {
		super();
		this.parent = parent;
		if (parent != null)
			ps = parent.ps;
	}

	public function remove() {
		statusMessage = '';
		onPickup = null;
		customPickupCallback = ()->{}; //setting this to null probably wont help very much
	}

	public function RunCustomCallBackFunction():Void->Void {
		if(customPickupCallback != null)
			return customPickupCallback;
		else
			return null;
	}

	function get_returnCondition():Bool
		return true;
}
