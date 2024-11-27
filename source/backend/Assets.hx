package backend;

import flixel.graphics.frames.FlxAtlasFrames;

class Assets
{
    #if html5
    static public function image(Key:String):String
        return 'assets/$Key.png';
    #else
    static public function image(Key:String):FlxGraphic
        return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/$Key.png'));
    #end

    #if html5
    static public function sound(Key:String):String
        return asset(Key);
    #else
    static public function sound(Key:String):FlxSoundAsset
        return cast Sound.fromFile('assets/$Key');
    #end

    static public function asset(Key:String):String
        return 'assets/$Key';
    
    inline static public function getSparrowAtlas(key:String):FlxAtlasFrames
            return FlxAtlasFrames.fromSparrow(key, 'images/$key' + '.xml');
}