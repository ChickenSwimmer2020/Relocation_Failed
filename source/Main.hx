package;

import menu.MainMenu;

class Main extends Sprite{

    public function new() {
        super();
        start();
    }
    
    function start()
    {
        var game:FlxGame = new FlxGame(0, 0, MainMenu, 60, 60, false, false);
        @:privateAccess
            game._customSoundTray = backend.SoundTray;
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