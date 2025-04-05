//#if modded
package modding;

import flixel.util.typeLimit.OneOfFour;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.utils.ByteArray;
import flixel.sound.FlxSound;
import lime.media.AudioBuffer;
import haxe.io.Bytes;
import haxe.io.Error;
import tjson.TJSON;
import haxe.zip.Reader;
import haxe.io.BytesInput;
import sys.io.File;

import hscript.Parser;
import hscript.Interp;

import modding.IniParser;

using StringTools;

typedef IniParseOutputType = OneOfFour<Bool, String, Float, Int>;

class ModFileParser{
    public function new(){
        //donothing
    }
    public function parseRFM(Path:String):Array<String>{
        var bytes:Bytes = File.getBytes(Path);
		var input = new BytesInput(bytes);
		var zip = new Reader(input);
		var entries = zip.read();

        var IniData:Map<String, Map<String, String>> = []; //get the data from mod.ini

        var AssetsSubFolders:Array<String> = []; //get assets subfolders, internal items come next.

        var Scripts:Array<String> = []; //get the folders, items come next.

		for (file in entries) {
            var filename:String = file.fileName;
            var fileData:Dynamic;
            if(filename.endsWith("/")){
                trace('subfolder found!\n\n${file.fileName}\n');
                if (file.fileName.startsWith(file.fileName + "/") && !file.fileName.endsWith("/")) {
                    trace("File in subfolder: " + file.fileName);
                    trace("File data" + file.data);
                }
            }
		}
        //just as a test for now.
        return [IniData.toString()/*, AssetsSubFolders.toString(), Scripts.toString()*/];
    }

    public function readINI(Path:String, ?header:String = 'MetaData', key:String, type:OneOfFour<String, Bool, Int, Float>):Dynamic{
        var bytes:Bytes = File.getBytes(Path);
		var input = new BytesInput(bytes);
		var zip = new Reader(input);
		var entries = zip.read();

        var IniData:Map<String, Map<String, String>> = []; //get the data from mod.ini
		for (file in entries) {
            var filename:String = file.fileName;
            var fileData:Dynamic;
            if(filename.endsWith('.ini')){
                var ini:haxe.zip.Entry = cast file;

                var data:String = ini.data.toString();
                IniData = IniManager.loadFromString(data);
            }
		}
        //just as a test for now.
        if(header != null){
            //APPARENTLY, i cant use a switch case because its not an enum. this is fucking stupid.
            @:privateAccess
            if(Std.isOfType(type, String)){
                return IniData[header][key];
            }else if (Std.isOfType(type, Int)){
                return Std.parseInt(IniData[header][key]);
            }else if(Std.isOfType(type, Float)){    
                return Std.parseFloat(IniData[header][key]);
            }else if(Std.isOfType(type, Bool)){ //TODO: make bools actually read properly.
                trace(IniData[header][key]);
                if(IniData[header][key] == 'true')
                    return true;
                else
                    return false;
                ////return IniData[header][key] == 'true' ? true : false;
            }else{
                FlxG.log.add('invalid return type for ini datafile. returning null...');
                return null;
            }
        }else
            return IniData['MetaData'][key];
    }

    public function getPackIMG(zipPath:String):BitmapData {
        var bytes:Bytes = File.getBytes(zipPath);
        var input = new BytesInput(bytes);
        var zip = new Reader(input);
        var entries = zip.read();
        var data:Dynamic = null;
    
        for (file in entries) {
            if (file.fileName == 'pack.png')
                data = BitmapData.fromBytes(file.data);
        }

        trace(data);
        return data;
    }

    public function loadSubStateFromModFile(subState:String, path:String, mod:String):FlxSubState{
        var bytes:Bytes = File.getBytes(mod);
		var input = new BytesInput(bytes);
		var zip = new Reader(input);
		var entries = zip.read();
        var substatedata:String = '';
        var prs:Parser = new Parser();
        var ntr:Interp = new Interp();
        for(file in entries){
            if(file.fileName.endsWith('$path/')){
                if(file.fileName == '$subState.hxc'){
                    substatedata = file.data.toString();
                }
            }
        }
        var ast = prs.parseString(substatedata);
        ntr.execute(ast);
        var substateClass:Dynamic = Reflect.field(ntr.variables, "Settings");
        return substateClass;
    }
}
//#end