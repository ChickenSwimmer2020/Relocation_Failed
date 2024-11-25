package backend.level;

import haxe.Json;

typedef LevelObject =
{
    var Name:String;
    var X:Float;
    var Y:Float;
    var IMG:String;
    var CollidesWithPlayer:Bool;
    var isBackground:Bool;
    @:optional var parrallaxBG:Bool;
    @:optional var IsAnimated:Bool;
    @:optional var AnimFrames:Array<Int>;
    @:optional var AnimName:String;
    @:optional var AnimFPS:Int;
}

typedef LevelData = 
{
    var objects:Array<LevelObject>;
}

class LevelLoader
{
    inline static public function ParseLevelData(FILE:String):LevelData
    {
        try{
            return Json.parse(openfl.Assets.getText(FILE));
        }catch(e)
            throw new LevelExceptions.LevelParseErrorException(e.message, e.stack.toString());
    }
}