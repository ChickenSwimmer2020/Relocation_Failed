package backend.save;

using StringTools;

typedef Save =
{
	var name:String;
	var value:SaveType;
	var type:SaveType;
}

abstract SaveType(Dynamic) from String from Float from Int from Bool to String to Float to Int to Bool {}

class SaveUtil
{
    private static final encodingMap:Map<String, String> = [
        // Lowercase
        "a" => "m", "b" => "n", "c" => "o",
        "d" => "p", "e" => "q", "f" => "r",
        "g" => "s", "h" => "t", "i" => "u",
        "j" => "v", "k" => "w", "l" => "x",
        "m" => "y", "n" => "z", "o" => "a",
        "p" => "b", "q" => "c", "r" => "d",
        "s" => "e", "t" => "f", "u" => "g",
        "v" => "h", "w" => "i", "x" => "j",
        "y" => "k", "z" => "l",

        "0" => "&", "1" => "%",
        "2" => "@", "3" => "(",
        "4" => ")", "5" => "#",
        "6" => "^", "7" => "!",
        "8" => "}", "9" => "$"
    ];

    private static final decodingMap:Map<String, String> = [
        // Lowercase
        "m" => "a", "n" => "b", "o" => "c",
        "p" => "d", "q" => "e", "r" => "f",
        "s" => "g", "t" => "h", "u" => "i",
        "v" => "j", "w" => "k", "x" => "l",
        "y" => "m", "z" => "n", "a" => "o",
        "b" => "p", "c" => "q", "d" => "r",
        "e" => "s", "f" => "t", "g" => "u",
        "h" => "v", "i" => "w", "j" => "x",
        "k" => "y", "l" => "z",

        "&" => "0", "%" => "1",
        "@" => "2", "(" => "3",
        ")" => "4", "#" => "5",
        "^" => "6", "!" => "7",
        "}" => "8", "$" => "9"
    ];
	public static function parseSave(saveStr:String, verbose:Bool = false, outerSeperator:String = '|', innerSeperator:String = '-',
        saveSeperator:String = ':'):Array<Save>
	{
		var res:Array<Save> = [];
        // Decodes random inserts from the save string
        saveStr = saveStr.replace('\n', '');
        saveStr = saveStr.replace('8x523h39s', '');
        saveStr = saveStr.replace('2usns', '');
        saveStr = saveStr.replace('3gfhs', '');
        saveStr = saveStr.replace('3isn8sef', '');
        saveStr = saveStr.replace('83hsla', '');
        saveStr = saveStr.replace('sdvc9zx', '');
        saveStr = saveStr.replace('09sj31', '');
        saveStr = saveStr.replace('n20asd', '');

		// *beginning outer seperator* seperator *end outer seperator*
		// This is to ensure people dont accidentally use a seporator in their value, causing an incorrect parse.
        // This also encodes it very well.
		var saveVars = saveStr.split('*boOs${outerSeperator}eOos*');
		if (verbose)
			trace(saveVars);
		for (s in saveVars)
			if (s.trim() == '' || s.trim() == null || s.trim() == '\n')
				saveVars.remove(s);

		for (saveVar in saveVars)
		{
			if (saveVar == '')
				continue;
			var saveVarParts = saveVar.split('*boIS${innerSeperator}EoIs*');
			var nameStr:String = null;
			var typeStr:String = null;
			var valueStr:String = null;
			var name:String = null;
			var type:Dynamic = null;
			var value:Dynamic = null;
			for (saveVarPart in saveVarParts)
			{
				saveVarPart = saveVarPart.trim();
				var valParts = saveVarPart.split('*BoPs${saveSeperator}eOPS*');
				if (verbose)
					trace(valParts);
				if (valParts[0] == null || valParts[1] == null)
					continue;
				var saveVarPartToken = valParts[0].trim();
				var saveVarPartVal = valParts[1].trim();

				switch (saveVarPartToken)
				{
					case 'N':
						nameStr = decodeString(saveVarPartVal);
					case 'T':
						typeStr = saveVarPartVal;
					case 'V':
						valueStr = decodeString(saveVarPartVal);
					default:
						trace('Invalid save! Expected tokens: N,T,V But got $saveVarPartToken. Save may be parsed incorrectly, posssibly leading to a crash.');
				}
			}
			if (nameStr == null || typeStr == null || valueStr == null)
				throw 'PARSE FAULT';
			name = nameStr;
			type = stringToType(typeStr);
			value = stringToVal(valueStr, type);
			res.push({name: name, type: type, value: value});
			if (verbose)
				trace(res);
		}
		return res;
	}

	public static function createSave(saves:Array<Save>, outerSeperator:String = '|', innerSeperator:String = '-',
			saveSeperator:String = ':'):String
	{
		var res:StringBuf = new StringBuf();
		var os = '*boOs${outerSeperator}eOos*';
		var ins = '*boIS${innerSeperator}EoIs*';
		var ps = '*BoPs${saveSeperator}eOPS*';
		res.add(os);
		res.add(ins);
        inline function addRandom()
        {
            var rand:Float = Math.random() * 10;
            var rounded:Int = Math.round(rand);
            var rands:Array<String> = ['8x523h39s', '2usns', '3gfhs', '3isn8sef', '83hsla', 'sdvc9zx', '09sj31', 'n20asd'];
            if (rands[rounded] != null)
                res.add(rands[rounded]);
            else
                res.add('8x523h39s');
        }
		inline function addSet(token:String, value:String)
		{
			res.add(token);
			res.add(ps);
			res.add(value);
			res.add(ins);
            addRandom(); // Further encoding
		}
		for (save in saves)
		{
			addSet('N', encodeString(save.name));
			addSet('T', typeToString(save.type));
			addSet('V', encodeString(Std.string(save.value)));
			res.add(os);
		}
        var s = res.toString();
        var rebuilt:String = '';
        for (char in s.split(''))
        {
            rebuilt += char;

            // Add \n's randomly to the string to make it more difficult to read
            var rand:Float = Math.random() * 10;
            var rounded:Int = Math.round(rand);
            var rands:Array<String> = ['', '', '', '', '', '', '', '\n', '', '', ''];
            if (rands[rounded] != null)
                rebuilt += rands[rounded];
        }
		return rebuilt;
	}

	public static function typeToString(type:SaveType):String
		return Std.isOfType(type, Float) ? 'F' : Std.isOfType(type, Int) ? 'I' : Std.isOfType(type, Bool) ? 'B' : 'S';

	public static function valueToString(type:SaveType):String
		return Std.isOfType(type, Float) ? 'F' : Std.isOfType(type, Int) ? 'I' : Std.isOfType(type, Bool) ? 'B' : 'S';

	public static function stringToType(str:String):SaveType
		return str == 'B' ? true : str == 'F' ? 0.0 : str == 'I' ? 0 : str == 'S' ? '' : null;

	public static function stringToVal(str:String, type:SaveType):SaveType
	{
		inline function parseBool(str:String)
			return str == 't' ? true : false;
		if (Std.isOfType(type, String))
			return str;
		if (Std.isOfType(type, Float))
			return Std.parseFloat(str);
		if (Std.isOfType(type, Int))
			return Std.parseInt(str);
		if (Std.isOfType(type, Bool))
			return parseBool(str);
		return null;
	}

    public static function encodeLetter(letter:String):String {
        letter = letter.toLowerCase();
        return encodingMap.exists(letter) ? encodingMap[letter] : letter;
    }

    public static function decodeLetter(letter:String):String {
        letter = letter.toLowerCase();
        return decodingMap.exists(letter) ? decodingMap[letter] : letter;
    }

    public static function encodeString(text:String):String {
        return [for (i in 0...text.length) encodeLetter(text.charAt(i))].join("");
    }

    public static function decodeString(text:String):String {
        return [for (i in 0...text.length) decodeLetter(text.charAt(i))].join("");
    }
}
