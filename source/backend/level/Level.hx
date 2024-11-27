package backend.level;

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
        MapBounds = new FlxRect(0,0,levelHeader.Boundries[0],levelHeader.Boundries[1]);

        for (object in levelData.objects){
            var obj = cast(new LevelSprite(object.X, object.Y).loadGraphic(Assets.image(object.IMG)), LevelSprite);
            obj.scale.set(object.ScaleX, object.ScaleY);
            obj.scrollFactor.set(object.SFX, object.SFY);
            if (object.CollidesWithPlayer != null) 
                obj.isCollider = object.CollidesWithPlayer;

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
}