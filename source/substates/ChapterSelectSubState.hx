package substates;

import flixel.math.FlxRect;
import objects.menu.ChapterWrapper.ChapterSelecterGroup;
import menu.MainMenu;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import objects.menu.ChapterBox;
import openfl.geom.Rectangle;
import rf_flixel.addons.ui.FlxUIAssets as FlxUIAssets;
import flixel.addons.ui.FlxUI9SliceSprite;
import rf_flixel.ui.FlxSquareButton;

using flixel.util.FlxSpriteUtil;

// TODO: REWRITE THIS, WE NEED TO DO THAT.
class ChapterSelectSubState extends FlxSubState {
	var BG:FlxUI9SliceSprite;
	var BG2:FlxUI9SliceSprite;
	var windowtitle:FlxText;
	var xbutt:FlxSquareButton;
	var FlxSprite:Rectangle;

	static var clipSquare:FlxRect;

	private var parstate:FlxState;
	private var SubStateCam:FlxCamera = new FlxCamera();
	var chapterselectCamera:FlxCamera = new FlxCamera();

	var instance:ChapterSelectSubState;

	var done:Bool = false;

	var Chapters:ChapterSelecterGroup = new ChapterSelecterGroup();

	var HC:Bool = false;

	override public function new(parentState:FlxState) {
		super();

		if(FlxG.save.data.High_Contrast_UI != null && FlxG.save.data.High_Contrast_UI == true){
            HC = true;
        }

		FlxG.cameras.add(SubStateCam);
		chapterselectCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(chapterselectCamera, false);
		chapterselectCamera.bgColor = 0x00000000;
		SubStateCam.bgColor.alpha = 0;
		this.parstate = parentState;

		this.instance = this;

		var Group = new FlxSpriteGroup();
		add(Group);

		BG = new FlxUI9SliceSprite(0, 0, if(HC) FlxUIAssets.IMG_CHROME_FLAT_HIGHCONTRAST else FlxUIAssets.IMG_CHROME_FLAT, new Rectangle(0, 0, 400, 200));
		BG.x = FlxG.width / 2 - 180;
		BG.y = FlxG.height / 2 - BG.height / 2;
		BG.scale.set(0, 0.1);
		BG.camera = chapterselectCamera;
		Group.add(BG);

		BG2 = new FlxUI9SliceSprite(BG.x + 10, BG.y + 20, if(HC) FlxUIAssets.IMG_CHROME_INSET_HIGHCONTRAST else FlxUIAssets.IMG_CHROME_INSET, new Rectangle(0, 0, 380, 150));
		BG2.scale.set(0, 0);
		BG2.camera = chapterselectCamera;
		Group.add(BG2);

		windowtitle = new FlxText(BG.x + 5, BG.y + 5, 400, "New Game -- Chapter Select", 8, true);
		Group.add(windowtitle);

		clipSquare = new FlxRect(BG.x + 10, BG.y + 20, 380, 150);

		Chapters.chapterCamera = chapterselectCamera;
		add(Chapters);
		Chapters.alpha = 0;
		wait(1, () -> {
			FlxTween.tween(Chapters, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
		});
		xbutt = new FlxSquareButton(BG.x, BG.y, "X", () -> {
			close();
			Chapters.destroy();
		});
		add(xbutt);
		if(HC){
			xbutt.loadGraphic('assets/ui/buttonSQRHC.png', true, 20, 20);
		}
		doCoolTweenin();
	}

	function doCoolTweenin() {
		FlxTween.tween(BG, {"scale.x": 1}, 0.5, {ease: FlxEase.expoOut}); // main bg X
		wait(0.5, () -> {
			FlxTween.tween(BG, {"scale.y": 1}, 0.5, {ease: FlxEase.expoOut});
		}); // main bg Y

		FlxTween.tween(BG2, {"scale.x": 1}, 0.5, {ease: FlxEase.expoOut}); // gray bg X
		wait(0.6, () -> {
			FlxTween.tween(BG2, {"scale.y": 1}, 0.5, {ease: FlxEase.expoOut});
		}); // gray bg Y

		FlxTween.tween(xbutt, {x: BG.x + 380}, 0.5, {ease: FlxEase.expoOut});
		FlxTween.tween(xbutt.label, {x: BG.x + 380}, 0.5, {ease: FlxEase.expoOut});
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		parstate.update(elapsed);
		BG.updateHitbox();
		BG2.updateHitbox();
		windowtitle.updateHitbox();
		Chapters.clipRect = clipSquare;
		for (i in Chapters.members) {
			if (Std.isOfType(i, FlxButton)) {
				var Butt = cast i;
				Butt.label.cliprect = clipSquare;
			}
		}
		@:privateAccess {
			if (!done) {
				wait(0.9, () -> {
					if (!done) {
						MainMenu.instance.Button_Play.visible = false;
						MainMenu.instance.Button_Settings.visible = false;
						MainMenu.instance.Button_Load.visible = false;
					}
				});
				done = true;
			}
		}
		// xbutt.updateHitbox();
	}

	override public function destroy() {
		super.destroy();
		FlxG.cameras.remove(chapterselectCamera);
		@:privateAccess {
			done = true;
			MainMenu.instance.Button_Play.visible = true;
			MainMenu.instance.Button_Settings.visible = true;
			MainMenu.instance.Button_Load.visible = true;
		}
	}
}
