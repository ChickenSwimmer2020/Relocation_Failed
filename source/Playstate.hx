package;

import objects.Player;
import backend.HUD;

class Playstate extends FlxState {
    
    var Player:Player;
    var HeadsUpDispalay:HUD;
    //var Level:Level;

    override public function create() {
        super.create();
        HeadsUpDispalay = new HUD();
        Player = new Player(0, 0);
        //Level = new Level();

        //add(Level);
        add(Player);
        add(HeadsUpDispalay);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}