package backend.level.rfl;

import modding.IniParser.Ini;
import flixel.sound.FlxSound;
import lime.media.AudioBuffer;
import haxe.io.Bytes;
import haxe.io.Error;
import tjson.TJSON;
import haxe.zip.Reader;
import haxe.io.BytesInput;
import sys.io.File;

using StringTools;

typedef RFLAssets = Map<String, Dynamic>;

class RFLParser {
	/**
	 * Read data from a .RFL file easily
	 * @param file the file
	 * @param folder the folder if its somewhere different inside of assets
	 * @param LevelFile the name of the json file for the actual level stuff.
	 */
	 //TODO: re-write to work with new level system.
	inline static public function LoadRFLData(file:String):{IniData:Ini, assets:RFLAssets} {
		var bytes:Bytes = File.getBytes(file);
		var input = new BytesInput(bytes);

		var zip = new Reader(input);
		var entries = zip.read();

		var assets:RFLAssets = new Map();

		for (file in entries) {
			if (file.data != null) {
				var fileName = file.fileName;
				var data:Dynamic;
				//alright, lets fucking do this!
				//level metadata parsing
				if(fileName.endsWith('.ini')){
					data = file.data.toString();
				}
				if(fileName.endsWith('.json')){
					data = file.data.toString();
				}

                if (fileName.endsWith('.png') || fileName.endsWith('.jpg') || fileName.endsWith('.jpeg'))
                    data = BitmapData.fromBytes(file.data);
                else{
                    if (fileName.endsWith('.ogg') || fileName.endsWith('.mp3') || fileName.endsWith('.wav'))
                        data = Sound.fromAudioBuffer(AudioBuffer.fromBytes(file.data));
                    else
                        data = file.data.toString();
                }
                assets.set(file.fileName, data);
			}
		}
		return {IniData: null, assets: assets};
	}
}
