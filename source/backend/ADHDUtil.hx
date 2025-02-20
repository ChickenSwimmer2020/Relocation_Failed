package backend;

using StringTools;

class ADHDUtil { // Array Data Holder (D) Utility, By ZSolarDev and Aura
	public static function ParseAA(data:String, ?splitter:String = ',') {
		var res:Dynamic = [];
		var readyRaw = data;
		if (readyRaw.endsWith(';'))
			readyRaw = readyRaw.substring(0, readyRaw.length - 1);
		var declarations = readyRaw.split(';');
		var result = [];
		for (declaration in declarations) {
			var variables = declaration.split(splitter);
			var proc:Array<String> = [];
			for (variable in 0...variables.length) {
				proc.push(variables[variable].trim());
			}
			result.push(proc);
		}
		return result;
	}

	public static function ParseA(data:String) {
		var readyRaw = data;
		if (readyRaw.endsWith(';'))
			readyRaw = readyRaw.substring(0, readyRaw.length - 1);
		var items:Array<String> = readyRaw.split(';');
		return items;
	}
}
