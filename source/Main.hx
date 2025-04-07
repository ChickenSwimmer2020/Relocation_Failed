package;

import haxe.PosInfos;
import openfl.events.NativeProcessExitEvent;
import openfl.events.ErrorEvent;
import openfl.errors.Error;
import sys.io.File;
import sys.FileSystem;
import crash.CrashState;
import haxe.CallStack;
import haxe.CallStack.StackItem;
import openfl.events.UncaughtErrorEvent;
import menu.intro.Decide;
import openfl.Lib;

using StringTools;

class Main extends Sprite {
	public static var crashTxt:String = '';
	var dateNow:String = Date.now().toString();
	public static var CrashFileName:String = ''; //for opening the file with space instead of just copying message.
	

	public function new() {
		super();
        haxe.Log.trace = (v:Dynamic, ?infos:PosInfos) -> {
            #if (debug || modded)
                var str = haxe.Log.formatOutput(v, infos);
                #if js
                if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
                    (untyped console).log(str);
                #elseif lua
                untyped __define_feature__("use._hx_print", _hx_print(str));
                #elseif sys
                Sys.println(str);
                #else
                throw new haxe.exceptions.NotImplementedException()
                #end
            #end
        }
		start();
	}

	function start() {
		#if !debug //* only on release builds
			hl.UI.closeConsole(); // It appears after a crash on release builds and looks ugly so im closing it
		#end
		

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		
		var fromCrash = FileSystem.exists('idied.rfDUMP');
		trace('${dateNow.substr(0, dateNow.length - 9)}');
		var game:FlxGame = new FlxGame(0, 0, Decide, 60, 60, true, false);
		#if modded
		if(!FileSystem.exists('mods'))
			FileSystem.createDirectory('mods'); //TODO: auto mod loading system directly from the menu and/or main file itself.
		#end
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleCrash);
		Lib.current.loaderInfo.addEventListener(NativeProcessExitEvent.EXIT, onExit);
		if (fromCrash) {
			crashTxt = File.getContent('crash/crash${File.getContent('./idied.RFDUMP')}.txt');
			game = new FlxGame(0, 0, CrashState, 60, 60, true, false);
		}
		if(FileSystem.exists('idied.rfDUMP')){
			CrashFileName = File.getContent('./idied.rfDUMP');
		}
		@:privateAccess game._customSoundTray = objects.SoundTray;
		addChild(game);
		loadGameSaveData();
	}
	static function onExit(event:NativeProcessExitEvent):Void{
		if(FileSystem.exists('idied.rfDUMP')) {
			FileSystem.deleteFile('idied.rfDUMP');
		}
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
		if(!FileSystem.exists('crash'))
			FileSystem.createDirectory('crash');
		File.saveContent('./crash/crash$dateNow.txt', file);
		File.saveContent('./idied.rfDUMP', dateNow);
		trace('${lastError}\n\n${lastStack}');
		Sys.command('start "" "./Relocation Failed.exe"');
		Sys.exit(1);
	}

	static function loadGameSaveData() {
		if (FlxG.save.bind('RelocationFailedSAVEDATA'))
			Preferences.loadSettings();
		else
			Application.current.window.alert('Failed to load player save!');
	}
}
