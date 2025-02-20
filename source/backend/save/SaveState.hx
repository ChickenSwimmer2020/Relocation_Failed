package backend.save;

import backend.macros.SaveMacro;

@:forward
abstract SaveState(Map<String, Any>) {
	public inline function new() {
		this = new Map();
	}

	/* 
		Overload the 'a.b' to get a value from this map, it
		allows for the following syntax without defining the variable in this abstract: 
		saveState.value = 3;
		trace(saveState.value);
	 */
	@:op(a.b)
	@:allow(backend.macros.SaveMacro)
	private inline function get<T>(name:String):T {
		return this.get(name);
	}

	@:op(a.b)
	@:allow(backend.macros.SaveMacro)
	private inline function set<T>(name:String, value:T):T {
		this.set(name, value);
		return value;
	}

	public function loadSaveFieldsFromArray(save:Array<SaveUtil.Save>, verbose:Bool = false, erase:Bool = true) {
		if (erase)
			this.clear();
		SaveMacro.constructSaveFieldsFromArray(cast this, save, verbose);
	}

	public function loadSaveFieldsFromString(save:String, verbose:Bool = false, erase:Bool = true) {
		if (erase)
			this.clear();
		SaveMacro.constructSaveFieldsFromString(cast this, save, verbose);
	}
}
