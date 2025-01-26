package;

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

class Main extends Sprite{
    public static var crashTxt:String = '';

    public function new() {
        super();
        start();
    }
    
    function start()
    {
        var fromCrash = FileSystem.exists('crash.txt');
        var game:FlxGame = new FlxGame(0, 0, WindowIntro, 60, 60, false, false);
        Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleCrash);
        if (fromCrash){
            crashTxt = File.getContent('crash.txt');
            game = new FlxGame(0, 0, CrashState, 60, 60, true, false);
            FileSystem.deleteFile('crash.txt');
        }
        @:privateAccess(
            game._customSoundTray = objects.SoundTray,
            game._skipSplash = true
        )
        addChild(game);
        loadGameSaveData();
    }

    function stackToString(callStack:Array<StackItem>)
        {
            var r:String = '';
            for (stack in callStack)
            {
                switch (stack)
                {
                    case FilePos(s, file, line, column):
                        r += '$file: line $line\n';
                    default:
                        // hii
                }
            }
            return r;
        }

    function handleCrash(event:UncaughtErrorEvent):Void {
        var lastError:String = event.error;
        var lastStack:String = stackToString(CallStack.exceptionStack(true));
        var file = '${lastError}|||${lastStack}';
        File.saveContent('./crash.txt', file);
        Sys.command('start "" "./Relocation Failed.exe"');
        Sys.exit(1);
    }

    function loadGameSaveData()
    {
        if(FlxG.save.bind('RelocationFailedSAVEDATA'))
            Preferences.loadSettings();
        else Application.current.window.alert('Failed to load player save!');
    }
}