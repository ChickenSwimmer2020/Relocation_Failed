package backend.dialogue;

/**
 * An animation for dialogue purpouses.
 * @since RF_DEV_0.3.7
 */
typedef DialogueAnim = {
	/**
	 * The name of the animation.
	 * @since RF_DEV_0.3.7
	 */
	var name:String;

	/**
	 * The frame width and height of each frame of the animation.
	 * @since RF_DEV_0.3.7
	 */
	var frame:Array<Float>;

	/**
	 * If true, the animation will flip horizontally.
	 * @since RF_DEV_0.3.7
	 */
	var flipX:Bool;

	/**
	 * If true, the animation will flip vertically.
	 * @since RF_DEV_0.3.7
	 */
	var flipY:Bool;

	/**
	 * The frames-per-seconds of the animation.
	 * @since RF_DEV_0.3.7
	 */
	var fps:Float;

	/**
	 * If true, the animation will loop.
	 * @since RF_DEV_0.3.7
	 */
	var looped:Bool;
}

/**
 * A character for dialogue purpouses.
 * @since RF_DEV_0.3.7
 */
typedef DialogueCharacter = {
	/**
	 * The name of the character.
	 * @since RF_DEV_0.3.7
	 */
	var name:String;

	/**
	 * The path to the texture of the character.
	 * @since RF_DEV_0.3.7
	 */
	var texPath:String;

	/**
	 * The x scale multiplier of the character.
	 * @since RF_DEV_0.3.7
	 */
	var scaleX:Float;

	/**
	 * The y scale multiplier of the character.
	 * @since RF_DEV_0.3.7
	 */
	var scaleY:Float;

	/**
	 * The x offset of the character.
	 * @since RF_DEV_0.3.7
	 */
	var xOffset:Int;

	/**
	 * The y offset of the character.
	 * @since RF_DEV_0.3.7
	 */
	var yOffset:Int;

	/**
	 * The animations of the character.
	 * * @since RF_DEV_0.3.7
	 * @since RF_DEV_0.3.7
	 */
	var anims:Array<DialogueAnim>;
}

/**
 * A text format for a text segment.
 * @since RF_DEV_0.3.7
 */
typedef DialogueTextFormat = {
	/**
	 * The color of the text.
	 * @since RF_DEV_0.3.7
	 */
	var color:String;

	/**
	 * The border color of the text.
	 * @since RF_DEV_0.3.7
	 */
	var borderColor:String;

	/**
	 * If true, the text will be underlined.
	 * @since RF_DEV_0.3.7
	 */
	var underlined:Bool;
}

typedef DialogueCharAnim = {
	/**
	 * The name of the character you want the animation to play on.
	 * @since RF_DEV_0.3.7
	 */
	var charName:String;

	/**
	 * The name of the animation you want to play on the chatacter.
	 * @since RF_DEV_0.3.7
	 */
	var animName:String;
}

/**
 * A segment of text for a dialogue string.
 * @since RF_DEV_0.3.7
 */
typedef DialogueTextSegment = {
	/**
	 * If true, the dialogue text will automatically advance to the next segment/next 
	 * dialogue string when this segment is finished displaying.
	 * @since RF_DEV_0.3.7
	 */
	var autoplayNext:Bool;

	/**
	 * The text to display in this segment.
	 * @since RF_DEV_0.3.7
	 */
	var text:String;

	/**
	 * The speed at which the text is displayed in this segment.
	 * @since RF_DEV_0.3.7
	 */
	var speed:Float;

	/**
	 * The animations to play when this segment is displayed.
	 * @since RF_DEV_0.3.7
	 */
	var animsToPlay:Array<DialogueCharAnim>;

	/**
	 * How long in seconds to pause after this text segment is displayed.
	 * @since RF_DEV_0.3.7
	 */
	var postTextPause:Float;

	/**
	 * The text format of this segment.
	 * @since RF_DEV_0.3.7
	 */
	var format:DialogueTextFormat;
}

/**
 * A sound for a dialogue string.
 * @since RF_DEV_0.3.7
 */
typedef DialogueSound = {
	/**
	 * The voice mode of the dialogue. This is either "perChar"(sound plays every time a text character
	 * is displayed), "perSegment"(sound plays when the segment is displayed), "perString"(sound plays
	 * every time a string is displayed), or "none"(no sound plays).
	 * @since RF_DEV_0.3.7
	 */
	var voiceMode:String;

	/**
	 * The path to the sound file that plays. This is only used if the voice mode is not "none".
	 * @since RF_DEV_0.3.7
	 */
	var soundPath:String;

	/**
	 * The volume of this sound.
	 * @since RF_DEV_0.3.7
	 */
	var volume:Float;
}

/**
 * A dialogue box for a dialogue string.
 * @since RF_DEV_0.3.7
 */
typedef DialogueBox = {
	/**
	 * The path to the dialogue box texture.
	 * @since RF_DEV_0.3.7
	 */
	var texPath:String;

	/**
	 * The idle animation of the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var idleAnim:DialogueAnim;

	/**
	 * The x scale multiplier of the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var scaleX:Float;

	/**
	 * The y scale multiplier of the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var scaleY:Float;

	/**
	 * The x offset of the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var xOffset:Int;

	/**
	 * The y offset of the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var yOffset:Int;
}

/**
 * A dialogue string for the dialogue.
 * @since RF_DEV_0.3.7
 */
typedef DialogueString = {
	/**
	 * The path to the dialogue box texture.
	 * @since RF_DEV_0.3.7
	 */
	var dialogueBox:DialogueBox;

	/**
	 * The path to the font texture used for the text in the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var fontTex:String;

	/**
	 * The character displaying on the left side of the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var charLeft:String;

	/**
	 * The character displaying on the right side of the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var charRight:String;

	/**
	 * The character displaying in the center of the dialogue box.
	 * @since RF_DEV_0.3.7
	 */
	var charCenter:String;

	/**
	 * The characters that play their speaking animations when this dialogue string is displayed.
	 * @since RF_DEV_0.3.7
	 */
	var speakingCharacters:Array<String>;

	/**
	 * The sounds that play when this dialogue string is displayed.
	 * @since RF_DEV_0.3.7
	 */
	var sounds:Array<DialogueSound>;

	/**
	 * Each segment of text in this dialogue string.
	 * @since RF_DEV_0.3.7
	 */
	var text:Array<DialogueTextSegment>;
}

/**
 * A song that plays via dialogue music.
 * @since RF_DEV_0.3.7
 */
typedef DialogueSong = {
	/**
	 * The volume of this song.
	 * @since RF_DEV_0.3.7
	 */
	var volume:Float;

	/**
	 * The path to this song.
	 * @since RF_DEV_0.3.7
	 */
	var path:String;

	/**
	 * If true, this song will loop.
	 * @since RF_DEV_0.3.7
	 */
	var looped:Bool;
}

/**
 * The music that plays for the dialogue.
 * @since RF_DEV_0.3.7
 */
typedef DialogueMusic = {
	/**
	 * The songs that play when this dialogue is displayed.
	 * Leave blank for no music.
	 * Each song is randomly selected from this array when the last song ends.
	 * @since RF_DEV_0.3.7
	 */
	var songs:Array<DialogueSong>;
}

/**
 * This is a dialogue.
 * @since RF_DEV_0.3.7
 */
typedef Dialogue = {
	/**
	 * The dialogue strings that make up this dialogue.
	 * @since RF_DEV_0.3.7
	 */
	var strings:Array<DialogueString>;

	/**
	 * The music that plays when this dialogue is displayed.
	 * @since RF_DEV_0.3.7
	 */
	var bgMusic:DialogueMusic;

	/**
	 * The path to the hscript file that executes when this dialogue is displayed.
	 * @since RF_DEV_0.3.7
	 */
	var hscriptPath:String;
}
