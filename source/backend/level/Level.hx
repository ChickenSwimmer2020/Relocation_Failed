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
            objects.set(object.Name, obj);
            add(obj);
        }
    }
}