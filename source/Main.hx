package;

import flixel.math.FlxRect;
import menu.ClickToPlay;

class Main extends Sprite{

    public function new() {
        super();
        start();
    }
    function start()
        {
            var game:FlxGame = new FlxGame(0, 0, ClickToPlay, 60, 60, false, false);
            @:privateAccess
                game._customSoundTray = backend.SoundTray;
            addChild(game);
        }
}