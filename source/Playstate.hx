package;

import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.animation.FlxAnimationController;
import flixel.addons.effects.FlxTrail;
import backend.*;
import backend.level.*;
import objects.Player.Aimer;
import objects.*;

class Playstate extends FlxState {
    
    public static var instance:Playstate;
    //we have to create the player in a stupid way thanks to my ideas.
    public var Player:Player;
    #if !mobile
    public var Player2:Aimer;
    #else
    #end
    public var Hud:HUD;
    public var Level:Level;

    public var FGCAM:FlxCamera;
    public var HUDCAM:FlxCamera;

    public var BulletGroup:FlxGroup;
    
    override public function new() {
        super();
        instance = this;
    }

    override public function create() {
        super.create();

        BulletGroup = new FlxGroup();
        
        #if !mobile
            #if debug
                var DebuggerHelper = new backend.DEBUGKEYS();
            #end
        #end

        FGCAM = new FlxCamera();
        FlxG.cameras.add(FGCAM, false);
        FGCAM.bgColor = 0x0011FF00;

        HUDCAM = new FlxCamera();
        FlxG.cameras.add(HUDCAM, false);
        HUDCAM.bgColor = 0x0011FF00;

        Hud = new HUD(this);
        Hud.cameras = [HUDCAM];
        Player = new Player(0, 0, this);
        Player.solid = true; //collisions
        #if !mobile
        Player2 = new Aimer();
        #else
        #end
        Level = new Level(LevelLoader.ParseLevelData(Assets.asset('level1.json')));
        Level.loadLevel();

        add(Level);
        add(Player);
        #if !mobile
        add(Player2);
        #else
        #end
        add(BulletGroup);
        add(Hud);

        trace(Level.levelData);
    }

    override public function update(elapsed:Float) {
        DebuggerHelper.update();
        if(!Level.CameraLocked) { //camera locking so we can have static rooms
            FlxG.camera.follow(Player, PLATFORMER, 15 * elapsed);
            FGCAM.follow(Player, PLATFORMER, 15 * elapsed);
        }
        if(FlxG.keys.anyPressed([PAGEUP]) && FlxG.camera.zoom < 2) {
            FlxG.camera.zoom += 0.05;
            FGCAM.zoom += 0.05;
        }
        if(FlxG.keys.anyPressed([PAGEDOWN]) && FlxG.camera.zoom > 1) {
            FlxG.camera.zoom -= 0.05;
            FGCAM.zoom -= 0.05;
        }
        if(FlxG.camera.zoom > 2) FlxG.camera.zoom = 2;
        if(FGCAM.zoom > 2) FGCAM.zoom = 2;

        if(FlxG.camera.zoom < 1) FlxG.camera.zoom > 1;
        if(FGCAM.zoom < 1) FGCAM.zoom = 1;

        #if !mobile
        if(FlxG.mouse.justPressed) {
            Bullet.shoot();
        }
        for(Bullet in BulletGroup) {
            var DB:FlxSprite = cast Bullet;
            trace(DB);
            if(!DB.isOnScreen(FGCAM)) {
                DB.kill();
                trace(DB);
            }
        }
        #else
        #end
        super.update(elapsed);
    }
}