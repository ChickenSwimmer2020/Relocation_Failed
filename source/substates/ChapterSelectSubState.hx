package substates;

import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import objects.ChapterBox;
import openfl.geom.Rectangle;
import flixel.addons.ui.FlxUIAssets;
import flixel.addons.ui.FlxUI9SliceSprite;
import rf_flixel.ui.FlxSquareButton;

class ChapterSelectSubState extends FlxSubState {
	var BG:FlxUI9SliceSprite;
	var BG2:FlxUI9SliceSprite;
	var windowtitle:FlxText;
	var xbutt:FlxSquareButton;
	var clipSquare:Rectangle;

	private var parstate:FlxState;
	private var SubStateCam:FlxCamera = new FlxCamera();
	var chapterselectCamera:FlxCamera = new FlxCamera();

	override public function new(parentState:FlxState) {
		super();
		FlxG.cameras.add(SubStateCam);
		FlxG.cameras.add(chapterselectCamera, false);
		SubStateCam.bgColor.alpha = 0;
        chapterselectCamera.bgColor.alpha = 0;
		this.parstate = parentState;

		var Group = new FlxSpriteGroup();
		add(Group);

		Group.scale.set(0, 0);

		FlxTween.tween(Group, {"scale.x": 1, "scale.y": 0.2}, 0.5, { ease: FlxEase.expoOut });
		wait(0.5, ()->{ FlxTween.tween(Group, {"scale.y": 1}, 0.5, { ease: FlxEase.expoOut }); });

		BG = new FlxUI9SliceSprite(0, 0, FlxUIAssets.IMG_CHROME_FLAT, new Rectangle(0, 0, 400, 200));
		BG.x = FlxG.width / 2 - 180;
		BG.y = FlxG.height / 2 - BG.height / 2;
		Group.add(BG);

		BG2 = new FlxUI9SliceSprite(BG.x + 10, BG.y + 20, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(0, 0, 380, 150));
		Group.add(BG2);

		xbutt = new FlxSquareButton(BG.x + 380, BG.y, "X", () -> {
			close();
		});
		xbutt.scale.set(0, 0);
		xbutt.label.scale.set(0, 0);
		add(xbutt);

		wait(0.5, ()->{ FlxTween.tween(xbutt, {"scale.x": 1, "scale.y": 1}, 0.5, { ease: FlxEase.expoOut }); FlxTween.tween(xbutt.label, {"scale.x": 1, "scale.y": 1}, 0.5, { ease: FlxEase.expoOut }); });

		windowtitle = new FlxText(BG.x + 5, BG.y + 5, 400, "New Game -- Chapter Select", 8, true);
		Group.add(windowtitle);

        clipSquare = new Rectangle(BG.x + 10, BG.y + 20, 380, 150);

        chapterselectCamera.flashSprite.scrollRect = clipSquare;

		var Chapter:ChapterBox = new ChapterBox(FlxG.width/2 - 180 + 15, FlxG.height/2 - BG.height/2 + 25, Assets.image('ship'), 'test chapter 01', ()->{ FlxG.switchState(new Playstate('level1')); });
		add(Chapter);
		Chapter.alpha = 0;
		wait(1, ()->{ FlxTween.tween(Chapter, {alpha: 1}, 0.5, { ease: FlxEase.expoOut }); });
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		parstate.update(elapsed);
		BG.updateHitbox();
		BG2.updateHitbox();
		windowtitle.updateHitbox();
		//xbutt.updateHitbox();
	}
}
