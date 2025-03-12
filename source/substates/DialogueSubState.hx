package substates;

import openfl.Assets;
import haxe.Json;
import backend.dialogue.DialogueTypedefs;

class DialogueSubState extends FlxSubState {
	public var dialogue:Dialogue;

	override public function new(jsonPath:String) {
		super();
		var jsonData = Json.parse(Assets.getText(jsonPath));
		// cast my beloved
		dialogue = cast jsonData;

		trace(jsonData);
		close();
	}
}
