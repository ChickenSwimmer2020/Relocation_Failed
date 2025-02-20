package backend.macros;

import backend.save.SaveUtil;
import backend.save.SaveState;
import haxe.macro.Expr;

class SaveMacro {
	macro static public function buildSaveFields(object:String, field:String, verbose:Bool):Array<haxe.macro.Field> {
		var fields:Array<haxe.macro.Field> = haxe.macro.Context.getBuildFields();
		var saves:String = Reflect.field(object, field);
		if (saves != null) {
			var save = SaveUtil.parseSave(saves, verbose);
			for (saveVar in save) {
				var v:Field = {
					name: saveVar.name,
					pos: haxe.macro.Context.currentPos(),
					access: [APublic],
					kind: FVar(macro :String, macro 'NO_VALUE')
				}
				// I can't put saveVar.type directly 😔
				if (Std.isOfType(saveVar.type, String))
					v.kind = FVar(macro :String, macro $v{saveVar.value});
				if (Std.isOfType(saveVar.type, Float))
					v.kind = FVar(macro :Float, macro $v{saveVar.value});
				if (Std.isOfType(saveVar.type, Int))
					v.kind = FVar(macro :Int, macro $v{saveVar.value});
				if (Std.isOfType(saveVar.type, Bool))
					v.kind = FVar(macro :Bool, macro $v{saveVar.value});

				if (verbose)
					trace('field pushed.. ${saveVar.name}:${saveVar.type} = ${saveVar.value}');
				fields.push(v);
			}
		}
		return fields;
	}

	static public function constructSaveFieldsFromArray(saveState:SaveState, saves:Array<Save>, verbose:Bool = false) {
		for (save in saves) {
			var name:String = save.name;
			var value:SaveType = save.value;
			saveState.set(name, value);
			if (verbose)
				trace('field pushed.. $name:${save.type} = $value');
		}
	}

	static public function constructSaveFieldsFromString(saveState:SaveState, saves:String, verbose:Bool = false) {
		var savesArray:Array<Save> = SaveUtil.parseSave(saves, verbose);
		trace('Save conversion complete.. $savesArray');
		for (save in savesArray) {
			var name:String = save.name;
			var value:SaveType = save.value;
			saveState.set(name, value);
			if (verbose)
				trace('field pushed.. $name:${save.type} = $value');
		}
	}
}
