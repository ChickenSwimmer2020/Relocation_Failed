package objects.game.interactables.ai;

import flixel.system.FlxAssets.FlxGraphicAsset;

class AiBody {
    public var ai:Ai;
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var rotation:Float;
    public var scaleX:Float;
    public var scaleY:Float;
    public var width:Float;
    public var height:Float;
    public var visible:Bool;
    public var alpha:Float;
    public var color:Int;
    public var flipX:Bool;
    public var flipY:Bool;
    public var graphicAsset:FlxGraphicAsset;
    public var _spr:FlxSprite;
}