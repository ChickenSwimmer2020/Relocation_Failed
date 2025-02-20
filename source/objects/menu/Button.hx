package objects.menu;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.touch.FlxTouchManager;
import flixel.input.touch.FlxTouch;

class Button extends FlxTypedGroup<FlxObject> {
	private var StaticBG:FlxSprite = new FlxSprite(0, 0);
	private var Pressed:Void->Void;

	public var Hover:Bool = false;
	public var DaButton:FlxSprite;
	public var DaText:Txt;

	/**
	 * # Button
	 * ## why would you press this on me?!
	 * #### why am i putting these comments?!
	 * ---
	 * its'a button! thats, literally it. it sa button, and it does stuff when pressed.
	 * @param X Float
	 * @param Y Float
	 * @param BG FlxGraphic
	 * @param PRS Void->Void
	 * @param SCL Float
	 * @param BGANIM Bool
	 * @since RF_DEV_0.0.2
	 */
	public function new(TEXT:String, X:Float, Y:Float, BG:FlxGraphic, PRS:Void->Void, SCL:Float, ?BGANIM:Bool) {
		super();
		createButton(X, Y, BG, PRS, SCL);
		DaText = new Txt(TEXT, 24, X, Y, CENTER);
		updateTextPosition();
		add(DaText);
	}

	public function createButton(X:Float, Y:Float, BG:FlxGraphic, PRS:Void->Void, SCL:Float, ?BGANIM:Bool) {
		DaButton = new FlxSprite(X, Y, BG);
		Pressed = PRS;
		StaticBG.loadGraphic(BG, BGANIM);
		StaticBG.setPosition(X, Y);
		StaticBG.scale.set(SCL, SCL);
		StaticBG.updateHitbox();
		add(DaButton);
	}

	public function updateTextPosition():Void {
		DaText.setPosition(DaButton.getGraphicMidpoint().x - DaText.width / 2, DaButton.getGraphicMidpoint().y - DaText.height / 2);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		CheckHover();
		if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed)
			Pressed();
	}

	function CheckHover() {
		if (Hover) {
			DaButton.color = 0xff159cea;
			DaButton.updateHitbox();
		} else {
			DaButton.color = 0xffffffff;
			DaButton.updateHitbox();
		}
	}
}

class Txt extends FlxText {
	public function new(TXT:String, FNTSIZE:Int, X:Float, Y:Float, ?ALIGN:FlxTextAlign = CENTER) {
		super(0, 0, 0, TXT, FNTSIZE, false);
		this.alignment = ALIGN;
		this.updateHitbox();
		this.text = TXT;
		this.antialiasing = false;
	}
}
