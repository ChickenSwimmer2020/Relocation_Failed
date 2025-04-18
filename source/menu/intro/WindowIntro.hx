package menu.intro;

import objects.game.interactables.Item;
import haxe.io.Error;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import sys.thread.Thread;
import objects.game.interactables.ai.Task.TaskInterface;
import lime.math.Vector2;
#if hl import hlwnative.HLNativeWindow; #end
import lime.ui.Window;

class WindowIntro extends FlxState {
	var window:Window;

	public static var oldWindowDimensions:Vector2;
	public static var oldWindowPosition:Vector2;

	override public function create() {
		super.create();
		Thread.create(() -> {
			Assets.image("intro/StudioLogo"); // cache the studio logos so it doesnt lag when doing stuff.
			Assets.image("intro/studiotext");
            for (item in Item.itemClasses){ // ensure to compile all items.
                var itm = Type.createInstance(item, [null]);
                itm.remove();
                itm.destroy();
            }
            try{
            for (task in TaskInterface.taskClasses) // ensure to compile all tasks.
                Type.createInstance(task, [null]);
            }catch(_){} // Ignore it, its prob compiled alr
		});
		HLNativeWindow.setWindowDarkMode(true); // It just looks cleaner
		window = Application.current.window;
		window.focus();
		@:privateAccess
		window.__attributes.alwaysOnTop = true; // keep the window on top so you cant accidently click off during the fade and break the illusion
		oldWindowDimensions = new Vector2(window.width, window.height);
		oldWindowPosition = new Vector2(window.x, window.y);
		window.borderless = true;
		window.x = 0;
		window.width = Std.int(window.display.bounds.width);
		window.height = Std.int(window.display.bounds.height);
		window.y = window.height;
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		wait(2, () -> {
			FlxTween.tween(window, {y: 1}, 2, {
				ease: FlxEase.circOut,
				onComplete: (_) -> { // keep the 0 to a 1 so that my laptop doesnt have an anerysm
					FlxG.switchState(() -> new IntroState(true)); //* varible passthrough, so we have to use ()->new IntroState.
				}
			});
		});
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		window.focus();
	}
}
