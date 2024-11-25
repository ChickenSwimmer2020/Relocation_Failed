package backend;

import haxe.Json;

typedef LevelObject =
{
    var Name:String;
    var X:Float;
    var Y:Float;
    var IMG:String;
}

typedef LevelData = 
{
    var objects:Array<LevelObject>;
}

class LevelLoader
{
    inline static public function ParseLevelData(FILE:String):LevelData
        return Json.parse(FILE);
}