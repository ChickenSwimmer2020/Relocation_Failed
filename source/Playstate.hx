package;

import backend.Assets;
import objects.Player;
import backend.HUD;
import backend.Level;

class Playstate extends FlxState {
    
    var Player:Player;
    var HeadsUpDispalay:HUD;
    var Level:LevelData;

    override public function create() {
        super.create();
        HeadsUpDispalay = new HUD();
        Player = new Player(0, 0);
        Level = LevelLoader.ParseLevelData(Assets.getText('assets/level1.json'));

        add(Player);
        add(HeadsUpDispalay);
        trace(Level);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}