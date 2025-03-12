package backend;

@:structInit class SaveVariables {
	/**
	 * does the player have bullet tracers enabled?
	 * ---
	 * @since RF_DEV_0.3.6
	 */
	public var bulletTracers:Bool = true;
	public var ShellEjection:Bool = true;
	public var SkipIntro:Bool = false;
	public var SkipWaterMarks:Bool = true;
	public var Difficulty:String = ''; //available dificulties: BABY, EASY, NORMAL, HARD, HARDCORE, CUSTOM






	/**CUSTOM DIFFICULTY SETTINGS GO DOWN HERE. custom can be changed from the advanced difficulty options.
		so basically any setting thats controlled by overall difficulty, like:
		Damage multipliers
		Enemy health multipliers
		Ammo appearance and ammounts
		many other things
	**/

	//ACCESSIBILITY
	public var ScreenShake:Bool = true;
	public var FlashingLights:Bool = true;
	public var ColorBlindnessMode:String = ""; //TODO: implement accessibility setting for color blindness, color blind testers needed?
	public var Captions:Bool = false; //TODO: implement captions
	public var EnemyOutlines:Bool = false;
	public var High_Contrast_UI:Bool = false; //TODO: make custom versions of ui elements with high-contrast texture. (WIP)
}

class Preferences {
	public static var save:SaveVariables = {};

	/**
	 * # Fun Fact:
	 * ## Before this feature came My ears died every time the game built cause the volume always started at max
	 * Saves the audio settings to your games save
	 * @param flush Does it save to AppData or save it in runtime to be saved later
	 * @since RF_DEV_0.1.0
	 */
	public static function saveAudioSettings(?flush:Bool = false) { // im tired of this sonic weapon on startup
		FlxG.save.data.VolumeIsMuted = FlxG.sound.muted;
		FlxG.save.data.CurVolumeLevel = FlxG.sound.volume; // we uhm, kinda want these?

		if (flush)
			FlxG.save.flush();
		#if debug
		FlxG.watch.addQuick('Current Volume:', FlxG.sound.volume);
		FlxG.watch.addQuick('Save Volume:', FlxG.save.data.CurVolumeLevel);
		FlxG.watch.addQuick('Muted State:', FlxG.sound.muted);
		FlxG.watch.addQuick('Save Muted State:', FlxG.save.data.VolumeIsMuted);
		#end
	}

	/**
	 * save the settings to the preferences SOL file
	 * ---
	 * @since RF_DEV_0.1.0
	 */
	public static function saveSettings() {
		// Saves all variables in the save via Reflection
		for (saveVar in Reflect.fields(save))
			Reflect.setField(FlxG.save.data, saveVar, Reflect.field(save, saveVar));
		saveAudioSettings(); // Saves muted and volume values

		FlxG.save.flush(); // Flushes data to AppData
		FlxG.log.add("Settings saved!");
	}

	/**
	 * Load the settings from the preferences SOL file
	 * ---
	 * @since RF_DEV_0.1.0
	 */
	public static function loadSettings() {
		for (saveVar in Reflect.fields(FlxG.save.data)) {
			if (Reflect.hasField(Preferences, saveVar))
				Reflect.setField(Preferences, saveVar, Reflect.field(Preferences, saveVar));
			else {
				try {
					Reflect.setField(save, saveVar, Reflect.field(save, saveVar));
				} catch (_) {}
			}
		}

		// you cant save the vars in the prefs, they need to be loaded from the save file :man_facepalming:
		if (FlxG.save.data.CurVolumeLevel != null)
			FlxG.sound.volume = FlxG.save.data.CurVolumeLevel;
		else
			FlxG.sound.volume = 0.5;

		if (FlxG.save.data.VolumeIsMuted != null)
			FlxG.sound.muted = FlxG.save.data.VolumeIsMuted;
		else
			FlxG.sound.muted = false;
	}
}
