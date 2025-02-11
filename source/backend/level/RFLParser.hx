package backend.level;

import haxe.io.Error;
import tjson.TJSON;
import haxe.zip.Reader;
import haxe.io.BytesInput;
import sys.io.File;


class RFLParser {
    /**
     * Read data from a .RFL file easily
     * @param file the file
     * @param folder the folder if its somewhere different inside of assets
     * @param LevelFile the name of the json file for the actual level stuff.
     */
    inline static public function LoadRFLData(file:String, ?folder:String = '', LevelFile:String):String {
    	var input = new BytesInput(File.getBytes('assets/${folder}${file}.RFL'));

    	var zip = new Reader(input);
    	var entries = zip.read();

        var jsonData:Dynamic = null;
        var jsonString:String = '';

    	for(file in entries){
    		if(file.fileName == '${LevelFile}.json' && file.data != null){
    			jsonString = file.data.toString(); // Read all data into a string
    			jsonData = jsonString;
    			trace('RelocationFailedLevel File parsed... got data: ' + jsonData);
    		}else if (file.data == null){
                trace('Couldnt get json data! did you add the main json?');
                jsonData = null;
            }
            
    	}
        return jsonData;
    }
}