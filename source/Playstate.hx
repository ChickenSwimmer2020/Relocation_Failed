package;

import backend.Assets;
import objects.Player;
import backend.HUD;
import backend.level.*;

class Playstate extends FlxState {
    
    public static var instance:Playstate;
    public var Player:Player;
    public var Hud:HUD;
    public var Level:Level;
    
    override public function new() {
        super();
        instance = this;
    }

    override public function create() {
        super.create();

        Hud = new HUD(this);
        Player = new Player(0, 0, this);
        Level = new Level(LevelLoader.ParseLevelData(Assets.asset('level1.json')));
        Level.loadLevel();

        add(Level);
        add(Player);
        add(Hud);

        trace(Level.levelData);
    }

    override public function update(elapsed:Float) {
        FlxG.camera.follow(Player, PLATFORMER, 15 * elapsed);
        super.update(elapsed);
    }
}