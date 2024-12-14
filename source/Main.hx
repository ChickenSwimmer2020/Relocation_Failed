package;

import menu.MainMenu;

class Main extends Sprite{

    public function new() {
        super();
        start();
    }
    function start()
        {
            FlxG.save.bind('RelocationFailedSAVEDATA');

            var game:FlxGame = new FlxGame(0, 0, MainMenu, 60, 60, false, false);
            @:privateAccess
                game._customSoundTray = backend.SoundTray;
            addChild(game);
        }
    function loadGameSaveData() {
        
    }
}