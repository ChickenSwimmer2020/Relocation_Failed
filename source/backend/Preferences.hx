package backend;

@:structInit class SaveVariables {
    public var testVarible:String = 'THIS IS A TEST STRING!!!!\nFUCK YOU!!!!!!';
}

class Preferences {
    public static var data:SaveVariables = {};

    public static function saveSettings() {
		for (key in Reflect.fields(data))
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));

		FlxG.save.flush();
		FlxG.save.bind('RelocationFailedSAVEDATA');
		FlxG.log.add("Settings saved!");
	}
    public static function loadSettings() {
        if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;
    }
}