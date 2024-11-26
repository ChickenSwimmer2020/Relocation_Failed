package backend.level;

import haxe.Json;

typedef LevelHeader = 
{
    var LevelID:String; //levels internal name
    var Chapter:Int; //what chapter it takes place in
    var Boundries:Array<Float>; //the boundries of the level, how far can the player move before being stopped?
}

typedef AnimData = {
    var ?AnimFrames:Array<Int>; //anim frames
    var ?AnimName:String; //anim name
    var ?AnimFPS:Int; //anim FPS
    var ?AnimLoop:Bool; //should anim loop
    var ?AnimFlipX:Bool; //should anim be flipped on the x axis
    var ?AnimFlipY:Bool; //should the anim be flipped on the y axis
}

typedef LevelObject =
{
    var Name:String; //internal name
    var Alpha:Float; //how transparent is the object
    var X:Float; //X positional value
    var Y:Float; //Y positional value
    var ScaleX:Float; //X scale factor
    var ScaleY:Float; //Y scale factor
    var SFX:Float; //X scroll factor
    var SFY:Float; //Y scroll factor
    var IMG:String; //what image do we load
    var ?CollidesWithPlayer:Bool; //should it collide with player?
    var ?IsBackground:Bool; //automatically scales across entire screen
    var ?IsAnimated:Bool; //should it be animated?
    var ?ParrallaxBG:Bool; //should it be a parrallax?
    var ?Anims:Array<AnimData>; // animation data if needed
}

typedef LevelData = 
{
    var objects:Array<LevelObject>;
    var header:LevelHeader;
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