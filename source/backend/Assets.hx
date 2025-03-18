package backend;

import flixel.sound.FlxSound;
import haxe.PosInfos;
import sys.FileSystem;
import flixel.graphics.frames.FlxAtlasFrames;

class Assets {
	/**
	 * Returns the image asset.
	 * @param Key The key of the image.
	 * @return The image asset.
	 * @since RF_DEV_0.0.9
	 */
	public static function image(Key:String, ?_:PosInfos):FlxGraphic
		return FlxGraphic.fromBitmapData(BitmapData.fromFile(asset('$Key.png')));

	/**
	 * Returns the sound asset.
	 * @param Key The key of the sound.
	 * @return The sound asset.
	 * @since RF_DEV_0.0.9
	 */
	public static function sound(Key:String):FlxSoundAsset
		return cast Sound.fromFile('assets/sound/snd/$Key');

	/**
	 * Returns the music asset.
	 * @param Key The key of the music.
	 * @return The sound music.
	 * @since RF_DEV_0.3.6
	 */
	public static function music(Key:String):FlxSoundAsset
		return cast Sound.fromFile('assets/sound/mus/$Key');

	/**
	 * Returns the path to an asset.
	 * @param Key The key of the asset.
	 * @return The path to the asset.
	 * @since RF_DEV_0.0.9
	 */
	public static function asset(Key:String):String
		return 'assets/$Key';

	/**
	 * Returns the path to a font asset.
	 * @param Key The key of the font.
	 * @return The path to the font.
	 * @since RF_DEV_0.3.5
	 */
	public static function font(Key:String):String
		return FileSystem.exists('assets/fonts/$Key.ttf') ? 'assets/fonts/$Key.ttf' : 'assets/fonts/$Key.otf';

	/**
	 * Returns the frames of a sparrow atlas.
	 * @param key 
	 * @return The frames of the sparrow atlas.
	 * @since RF_DEV_0.0.9
	 */
	inline public static function sparrowAtlas(key:String):FlxAtlasFrames
		return FlxAtlasFrames.fromSparrow(key, 'images/$key' + '.xml');
}
