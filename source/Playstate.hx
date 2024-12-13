package;

import backend.Assets;
import objects.Player;
import backend.HUD;
import backend.level.*;

class Playstate extends FlxState {
    
    public static var instance:Playstate;
    //we have to create the player in a stupid way thanks to my ideas.
    public var Player:Player;
    //public var Player2:Aimer;
    public var Hud:HUD;
    public var Level:Level;

    public var FGCAM:FlxCamera;
    public var HUDCAM:FlxCamera;
    
    override public function new() {
        super();
        instance = this;
    }

    override public function create() {
        super.create();

        FGCAM = new FlxCamera();
        FlxG.cameras.add(FGCAM, false);
        FGCAM.bgColor = 0x0011FF00;

        HUDCAM = new FlxCamera();
        FlxG.cameras.add(HUDCAM, false);
        HUDCAM.bgColor = 0x0011FF00;

        Hud = new HUD(this);
        Hud.cameras = [HUDCAM];
        Player = new Player(0, 0, this);
        //Player2 = new Aimer();
        Level = new Level(LevelLoader.ParseLevelData(Assets.asset('level1.json')));
        Level.loadLevel();

        add(Level);
        add(Player);
        //add(Player2);
        add(Hud);

        trace(Level.levelData);
    }

    override public function update(elapsed:Float) {
        if(!Level.CameraLocked) { //camera locking so we can have static rooms
            FlxG.camera.follow(Player, PLATFORMER, 15 * elapsed);
            FGCAM.follow(Player, PLATFORMER, 15 * elapsed);
        }
        super.update(elapsed);
    }
}