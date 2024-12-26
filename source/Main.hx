package;

import menu.intro.WindowIntro;

class Main extends Sprite{

    public function new() {
        super();
        start();
    }
    
    function start()
    {
        var game:FlxGame = new FlxGame(0, 0, WindowIntro, 60, 60, false, false);
        @:privateAccess
            game._customSoundTray = objects.SoundTray;
        @:privateAccess
            game._skipSplash = true; //since we can add a custom one
        addChild(game);
        loadGameSaveData();
    }

    function loadGameSaveData()
    {
        if(FlxG.save.bind('RelocationFailedSAVEDATA'))
            Preferences.loadSettings();
        else Application.current.window.alert('Failed to load player save!');
    }
}