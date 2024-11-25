package backend.level;

import haxe.Json;

typedef LevelObject =
{
    var Name:String;
    var Alpha:Float;
    var X:Float;
    var Y:Float;
    var ScaleX:Float;
    var ScaleY:Float;
    var SFX:Float;
    var SFY:Float;
    var IMG:String;
    var CollidesWithPlayer:Bool;
    var IsBackground:Bool; //automatically scales across entire screen
    var ?IsAnimated:Bool;
    var ?ParrallaxBG:Bool;

    //animation data if added
    var ?AnimFrames:Array<Int>;
    var ?AnimName:String;
    var ?AnimFPS:Int;
    var ?AnimLoop:Bool;
    var ?AnimFlipX:Bool;
    var ?AnimFlipY:Bool;
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