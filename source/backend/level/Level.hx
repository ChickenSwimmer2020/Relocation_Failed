package backend.level;

import objects.Player;
import flixel.math.FlxRect;
import backend.level.LevelLoader.LevelHeader;
import backend.level.LevelExceptions.LevelNullException;
import haxe.PosInfos;
import backend.level.LevelLoader.LevelData;
import flixel.group.FlxGroup;

class Level extends FlxGroup
{
    public var levelData:LevelData;
    public var levelHeader:LevelHeader;
    public var objects:Map<String, LevelSprite> = new Map();
    public var colliders:Array<LevelSprite>;

    public var LevelID:String;
    public var ChapterID:Int;
    public var MapBounds:FlxRect;
    public var CameraLocked:Bool = false;

    public var CameraLerp:Float;
    public var CameraFollowStyle:String;

    override public function new(levelData:LevelData) {
        super();
        this.levelData = levelData;
    }

    public function loadLevel(?_:PosInfos)
    {
        if (levelData == null)
            throw new LevelExceptions.LevelNullException('Level is null!', '', _);

        levelHeader = levelData.header;

        if (levelHeader == null)
            throw new LevelExceptions.LevelNullException('Level header is null!', '', _);
        

        LevelID = levelHeader.LevelID;
        ChapterID = levelHeader.Chapter;
        CameraLocked = levelHeader.CameraLocked;
        MapBounds = new FlxRect(0,0,levelHeader.Boundries[0],levelHeader.Boundries[1]);

        CameraLerp = levelHeader.CameraFollowLerp;
        CameraFollowStyle = levelHeader.CameraFollowStyle;

        for (object in levelData.objects){
            var obj = cast(new LevelSprite(object.X, object.Y).loadGraphic(Assets.image(object.IMG)), LevelSprite);
            obj.scale.set(object.ScaleX, object.ScaleY);

            if(object.ScaleX > 1 || object.ScaleX < 1 || (object.ScaleY > 1 || object.ScaleY < 1)) //stupid `On static platforms, null can't be useds as basic type Float` error.
                    obj.updateHitbox(); //since we're doing collision stuff, hitboxes actually need to update now

            obj.scrollFactor.set(object.SFX, object.SFY);
            if (object.CollidesWithPlayer != null) {
                obj.isCollider = object.CollidesWithPlayer;
                obj.isForeGroundSprite = object.RenderOverPlayer; //so we can have fg sprites NOT collide at all and possibly cause crashes
            }

            if(!object.VIS)
                obj.alpha = 0.00000001; //so that the collision can still be done

            if(object.RenderOverPlayer)
                obj.cameras = [Playstate.instance.FGCAM];

            if(object.ParrallaxBG != null)
                //do something

            if(object.IsAnimated != null)
                if (object.IsAnimated)
                    for (anim in object.Anims)
                        obj.animation.add(anim.AnimName, anim.AnimFrames, anim.AnimFPS, anim.AnimLoop, anim.AnimFlipX, anim.AnimFlipY);


            if (object.IsBackground != null)
                if(object.IsBackground)
                    {
                        obj.setPosition(0, 0);
                        obj.setGraphicSize(levelHeader.Boundries[0],levelHeader.Boundries[1]);
                        obj.scrollFactor.set(0,0);
                        obj.screenCenter(XY);
                    }

            objects.set(object.Name, obj);
            add(obj);
        }
    }
}

class LevelSprite extends FlxSprite
{
    public var isCollider:Bool = false;
    public var isForeGroundSprite:Bool = false;

    override public function update(elapsed:Float) { //WORKING COLLISION?!?!?!
        if(this.isCollider) {
            Playstate.instance.Player.CheckCollision(this); //only detects...
            this.moves = false; //how can the player even fucking move the damn sprite????
            this.solid = true; //make object have collision
            this.immovable = true; //why did the box even move????
        }
        if(this.isForeGroundSprite) { //make sure to disable collision if the sprite is on the foreground, even if it is on a sperate camera.
            this.solid = false; //override the last one hopefully
        }
    }
}