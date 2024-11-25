package backend;

class Assets
{
    #if html5
    static public function image(Key:String):String
        return 'assets/$Key.png';
    #else
    static public function image(Key:String):FlxGraphic
        return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/$Key.png'));
    #end

    static public function sound(Key:String):FlxSoundAsset
        return cast Sound.fromFile('assets/$Key');

    static public function asset(Key:String):String
        return 'assets/$Key';
}