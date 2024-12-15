package backend;

@:structInit class SaveVariables {
    public var testVarible:String = 'THIS IS A TEST STRING!!!!\nFUCK YOU!!!!!!';
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
      public static function saveAudioSettings(?flush:Bool = false) { //im tired of this sonic weapon on startup
		FlxG.save.data.VolumeIsMuted = FlxG.sound.muted;
		FlxG.save.data.CurVolumeLevel = FlxG.sound.volume; //we uhm, kinda want these?

        if (flush) FlxG.save.flush();
		trace('Audio Settings Saved!\nCur Volume: ${FlxG.sound.volume}\nSave Volume: ${FlxG.save.data.CurVolumeLevel}\nMuted Status: ${FlxG.sound.muted}\nSave Muted Status: ${FlxG.save.data.VolumeIsMuted}');
	}

    public static function saveSettings() {
        // Saves all variables in the save via Reflection
		for (saveVar in Reflect.fields(save))
			Reflect.setField(FlxG.save.data, saveVar, Reflect.field(save, saveVar));
		saveAudioSettings(); // Saves muted and volume values

		FlxG.save.flush(); // Flushes data to AppData
		FlxG.log.add("Settings saved!");
	}
    
    static var CurVolumeLevel:Float = 1;
    static var VolumeIsMuted:Bool = false;
    public static function loadSettings() {
        for (saveVar in Reflect.fields(FlxG.save.data)){
            if (Reflect.hasField(Preferences, saveVar))
			    Reflect.setField(Preferences, saveVar, Reflect.field(Preferences, saveVar));
            else{
                try { Reflect.setField(save, saveVar, Reflect.field(save, saveVar)); }
                catch(_){}
            }
        }
		
        FlxG.sound.volume = CurVolumeLevel;
		FlxG.sound.muted = VolumeIsMuted;
    }
}