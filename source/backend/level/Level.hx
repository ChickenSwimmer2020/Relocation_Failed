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
    public var objects:Map<String, FlxSprite> = new Map();

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
            var obj = new FlxSprite(object.X, object.Y).loadGraphic(Assets.image(object.IMG));
            obj.scale.set(object.ScaleX, object.ScaleY);
            obj.scrollFactor.set(object.SFX, object.SFY);
            if(object.ParrallaxBG != null && object.ParrallaxBG == true)
                //do something

            if(object.IsAnimated != null && object.IsAnimated == true)
                obj.animation.add(object.AnimName, object.AnimFrames, object.AnimFPS, object.AnimLoop, object.AnimFlipX, object.AnimFlipY);

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