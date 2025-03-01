package;

import openfl.events.ErrorEvent;
import openfl.errors.Error;
import sys.io.File;
import sys.FileSystem;
import crash.CrashState;
import haxe.io.Path;
import sys.io.Process;
import haxe.CallStack;
import haxe.CallStack.StackItem;
import openfl.events.UncaughtErrorEvent;
import menu.intro.WindowIntro;
import openfl.Lib;

class Main extends Sprite {
	public static var crashTxt:String = '';

	public function new() {
		super();
		start();
	}

	function start() {
		#if !debug //* only on release builds
			hl.UI.closeConsole(); // It appears after a crash on release builds and looks ugly so im closing it
		#else
			FlxG.log.redirectTraces = true; //redirect ALL trace calls to the debugger's log console
		#end
		var fromCrash = FileSystem.exists('crash.txt');
		var game:FlxGame = new FlxGame(0, 0, WindowIntro, 60, 60, true, false);
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleCrash);
		if (fromCrash) {
			crashTxt = File.getContent('crash.txt');
			game = new FlxGame(0, 0, CrashState, 60, 60, true, false);
			FileSystem.deleteFile('crash.txt');
		}
		@:privateAccess game._customSoundTray = objects.SoundTray;
		addChild(game);
		loadGameSaveData();
	}

	function stackToString(callStack:Array<StackItem>) {
		var r:String = '';
		for (stack in callStack) {
			switch (stack) {
				case FilePos(_, fileName, lineNum, _):
					r += '$fileName:$lineNum\n';
				default:
					// hii
			}
		}
		return r;
	}

	function handleCrash(event:UncaughtErrorEvent):Void {
		var lastError:String;
		if (Std.isOfType(event.error, Error)) {
			lastError = cast(event.error, Error).message;
		} else if (Std.isOfType(event.error, ErrorEvent)) {
			lastError = cast(event.error, ErrorEvent).text;
		} else {
			lastError = Std.string(event.error);
		}
		var lastStack:String = stackToString(CallStack.exceptionStack(true));
		var file = '${lastError}|||${lastStack}';
		File.saveContent('./crash.txt', file);
		trace('${lastError}\n\n${lastStack}');
		Sys.command('start "" "./Relocation Failed.exe"');
		Sys.exit(1);
	}

	function loadGameSaveData() {
		if (FlxG.save.bind('RelocationFailedSAVEDATA'))
			Preferences.loadSettings();
		else
			Application.current.window.alert('Failed to load player save!');
	}
}
