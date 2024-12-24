package;

import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup;
import backend.*;
import backend.level.*;
import objects.game.controllables.*;
import objects.game.HUD;

class Playstate extends FlxTransitionableState {
    
    public static var instance:Playstate;
    //we have to create the player in a stupid way thanks to my ideas.
    public var Player:Player;
    #if !mobile
    public var Player2:Aimer;
    public var AimerGroup:FlxSpriteGroup = new FlxSpriteGroup();
    #else 
    #end
    public var Hud:HUD;
    public var Level:Level;
    public var colliders:Array<FlxSprite> = [];

    public var FGCAM:FlxCamera;
    public var HUDCAM:FlxCamera;

    public var followStyle:FlxCameraFollowStyle;

    public var _LEVEL:String;

    public var BulletGroup:FlxGroup;
    #if !mobile
        #if debug
            public var DebuggerHelper = new backend.DEBUGKEYS();
        #end
    #end
    
    override public function new(levelToLoad:String = 'level1') {
        super();
        instance = this;
        _LEVEL = levelToLoad;
    }

    override public function create() {
        super.create();

        BulletGroup = new FlxGroup();
        
        

        FGCAM = new FlxCamera();
        FlxG.cameras.add(FGCAM, false);
        FGCAM.bgColor = 0x0011FF00;

        HUDCAM = new FlxCamera();
        FlxG.cameras.add(HUDCAM, false);
        HUDCAM.bgColor = 0x0011FF00;

        Hud = new HUD(this);
        Hud.cameras = [HUDCAM];
        #if !mobile
        Player2 = new Aimer();
        #else
        #end
        Level = new Level(LevelLoader.ParseLevelData(Assets.asset('$_LEVEL.json')));
        Level.loadLevel();
        
        for (obj in Level.objects)
            if (obj.isCollider && !obj.isForeGroundSprite)
                colliders.push(obj);
        Player.colliders = colliders;

        add(Level);
        add(Player);
        #if !mobile
        add(Player2);
        add(AimerGroup);
        #else
        #end
        add(BulletGroup);
        add(Hud);
    }

    override public function update(elapsed:Float) {
        #if debug
            DebuggerHelper.update(elapsed);
        #end
        switch(Level.CameraFollowStyle) {
            case 'LOCKON':
                followStyle = LOCKON;
            case 'PLATFORMER':
                followStyle = PLATFORMER;
            case 'TOPDOWN':
                followStyle = TOPDOWN;
            case 'TOPDOWN_TIGHT':
                followStyle = TOPDOWN_TIGHT;
            case 'SCREEN_BY_SCREEN':
                followStyle = SCREEN_BY_SCREEN;
            case 'NO_DEAD_ZONE':
                followStyle = NO_DEAD_ZONE;
            default:
                followStyle = null;
        }
        if(!Level.CameraLocked) { //camera locking so we can have static rooms
            FlxG.camera.follow(Player, followStyle, Level.CameraLerp * elapsed);
            FGCAM.follow(Player, followStyle, Level.CameraLerp * elapsed);
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

        if(FlxG.camera.zoom < 1) FlxG.camera.zoom = 1;
        if(FGCAM.zoom < 1) FGCAM.zoom = 1;

        #if !mobile
        AimerGroup.setPosition(Player2.x, Player2.y);
        Playstate.instance.AimerGroup.angle = Player2.angle + 1;
        #else
        #end
        super.update(elapsed);
    }
}