package;

import menu.MainMenu;

class Main extends Sprite{

    public function new() {
        super();
        start();
    }
    function start()
        {

            var connected:Bool = FlxG.save.bind('RelocationFailedSAVEDATA');
            if(connected) {
                trace('save was loaded');
                loadGameSaveData();
            } else {
                trace('save wasnt loaded :(((((((((\n\n\n\nWHYYYYYYYYYYY');
            }

            var game:FlxGame = new FlxGame(0, 0, MainMenu, 60, 60, false, false);
            @:privateAccess
                game._customSoundTray = backend.SoundTray;
            addChild(game);
        }
    function loadGameSaveData() {
        Preferences.loadSettings();
    }
}