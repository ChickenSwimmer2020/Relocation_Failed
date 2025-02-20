package objects.game.interactables;

import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

class Trigger extends FlxSpriteGroup {
	public var Function:String;
	public var Width:Float;
	public var Height:Float;
	public var inEditor:Bool;
	public var trigger:RFTriAxisSprite;
	public var FireOnce:Bool;
	public var groupParent:FlxTypedGroup<RFTriAxisSprite>;
	public var directParent:FlxGroup;

	public function new(X:Float, Y:Float, Z:Float, directParent:FlxGroup, groupParent:FlxTypedGroup<RFTriAxisSprite>, Width:Float, Height:Float,
			?IsVisible:Bool = false, Func:String, ?oneShot:Bool = false, ?EditorMode:Bool = false) {
		super(0, 0);
		trigger = new RFTriAxisSprite(X, Y, Z);
		trigger.loadGraphic(Assets.image('Trigger'));
		trigger.alpha = IsVisible != null && IsVisible == true ? 1 : 0;
		trigger.width = Width;
		trigger.height = Height;
		trigger.setGraphicSize(Width, Height);
		trigger.updateHitbox();
		Function = Func;
		inEditor = EditorMode;
		FireOnce = oneShot;
		this.groupParent = groupParent;
		this.directParent = directParent;
		groupParent.add(trigger);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (!inEditor) {
			if (Function != null) {
				if (trigger.overlaps(Playstate.instance.Player)) {
					trace(Function);
					if (FireOnce) {
						directParent.remove(this);
						groupParent.remove(trigger);
						trigger.destroy();
						destroy();
					}
				}
			}
		}
	}
}
