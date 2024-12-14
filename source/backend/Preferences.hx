package backend;

@:structInit class SaveVariables {
    public var testVarible:String = 'THIS IS A TEST STRING!!!!\nFUCK YOU!!!!!!';
}

class Preferences {
    public static var data:SaveVariables = {};

	/**
	  * # Fun Fact:
	  * ## Before this feature came My ears died every time the game built
	  * ### cause the volume always started at max
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
		for (key in Reflect.fields(data))
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));

		saveAudioSettings();

		FlxG.save.flush();
		FlxG.log.add("Settings saved!");
	}

    public static function loadSettings() {
        FlxG.save.bind('RelocationFailedSAVEDATA');
        if(FlxG.save.data.CurVolumeLevel != null) //should work?
			FlxG.sound.volume = FlxG.save.data.CurVolumeLevel;
		if (FlxG.save.data.VolumeIsMuted != null)
			FlxG.sound.muted = FlxG.save.data.VolumeIsMuted;
    }
}