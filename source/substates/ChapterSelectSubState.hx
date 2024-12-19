package substates;

import menu.MainMenu;
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

	var done:Bool = false;

	override public function new(parentState:FlxState) {
		super();
		FlxG.cameras.add(SubStateCam);
		FlxG.cameras.add(chapterselectCamera, false);
		SubStateCam.bgColor.alpha = 0;
        chapterselectCamera.bgColor.alpha = 0;
		this.parstate = parentState;

		var Group = new FlxSpriteGroup();
		add(Group);

		BG = new FlxUI9SliceSprite(0, 0, FlxUIAssets.IMG_CHROME_FLAT, new Rectangle(0, 0, 400, 200));
		BG.x = FlxG.width / 2 - 180;
		BG.y = FlxG.height / 2 - BG.height / 2;
		BG.scale.set(0, 0.1);
		Group.add(BG);

		BG2 = new FlxUI9SliceSprite(BG.x + 10, BG.y + 20, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(0, 0, 380, 150));
		BG2.scale.set(0, 0);
		Group.add(BG2);

		xbutt = new FlxSquareButton(BG.x, BG.y, "X", () -> {
			close();
		});
		add(xbutt);

		windowtitle = new FlxText(BG.x + 5, BG.y + 5, 400, "New Game -- Chapter Select", 8, true);
		Group.add(windowtitle);

        clipSquare = new Rectangle(BG.x + 10, BG.y + 20, 380, 150);

        chapterselectCamera.flashSprite.scrollRect = clipSquare;

		var Chapter:ChapterBox = new ChapterBox(FlxG.width/2 - 180 + 15, FlxG.height/2 - BG.height/2 + 25, Assets.image('ship'), 'test chapter 01', ()->{ FlxG.switchState(new Playstate('level1')); }, false);
		add(Chapter);
		Chapter.alpha = 0;
		wait(1, ()->{ FlxTween.tween(Chapter, {alpha: 1}, 0.5, { ease: FlxEase.expoOut }); });
		doCoolTweenin();
	}

	function doCoolTweenin() {
		FlxTween.tween(BG, {"scale.x": 1}, 0.5, { ease: FlxEase.expoOut }); //main bg X
		wait(0.5, ()->{ FlxTween.tween(BG, {"scale.y": 1}, 0.5, { ease: FlxEase.expoOut }); }); //main bg Y

		FlxTween.tween(BG2, {"scale.x": 1}, 0.5, { ease: FlxEase.expoOut }); //gray bg X
		wait(0.6, ()->{ FlxTween.tween(BG2, {"scale.y": 1}, 0.5, { ease: FlxEase.expoOut }); }); //gray bg Y

		FlxTween.tween(xbutt, {x: BG.x + 380}, 0.5, { ease: FlxEase.expoOut }); 
		FlxTween.tween(xbutt.label, {x: BG.x + 380}, 0.5, { ease: FlxEase.expoOut });
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		parstate.update(elapsed);
		BG.updateHitbox();
		BG2.updateHitbox();
		windowtitle.updateHitbox();
		@:privateAccess {
			if(!done) {
				wait(0.9, ()->{
					MainMenu.instance.Button_Play.kill();
					MainMenu.instance.Button_Settings.kill();
					MainMenu.instance.Button_Load.kill();
				});
				done = true;
			}
		}
		//xbutt.updateHitbox();
	}

	override public function destroy() {
		super.destroy();
		@:privateAccess {
			MainMenu.instance.Button_Play.revive();
			MainMenu.instance.Button_Settings.revive();
			MainMenu.instance.Button_Load.revive();
		}
	}
}
