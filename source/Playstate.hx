package;

import backend.Assets;
import objects.Player;
import backend.HUD;
import backend.level.*;

class Playstate extends FlxState {
    
    var Player:Player;
    var HeadsUpDispalay:HUD;
    var Level:Level;

    override public function create() {
        super.create();
        HeadsUpDispalay = new HUD();
        Player = new Player(0, 0);
        Level = new Level(LevelLoader.ParseLevelData(Assets.asset('level1.json')));
        Level.loadLevel();
        add(Level);
        add(Player);
        add(HeadsUpDispalay);
    }

    override public function update(elapsed:Float) {
        FlxG.camera.follow(Player, PLATFORMER, 15 * elapsed);
        super.update(elapsed);
    }
}