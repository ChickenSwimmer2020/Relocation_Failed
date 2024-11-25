package backend.level;

import haxe.PosInfos;
import backend.level.LevelLoader.LevelData;
import flixel.group.FlxGroup;

class Level extends FlxGroup
{
    var levelData:LevelData;
    var objects:Map<String, FlxSprite> = new Map();

    override public function new(levelData:LevelData) {
        super();
        this.levelData = levelData;
    }

    public function loadLevel(?_:PosInfos)
    {
        if (levelData == null)
            throw new LevelExceptions.LevelNullException('Level is null!', '', _);

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
                    obj.scale.set(FlxG.width, FlxG.height);
                    obj.screenCenter;
                }

            objects.set(object.Name, obj);
            add(obj);
        }
    }
}