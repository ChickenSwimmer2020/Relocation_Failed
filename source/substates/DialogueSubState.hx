package substates;

import sys.thread.Thread;
import sys.io.File;
import backend.dialogue.DialogueMgr;

class DialogueSubState extends FlxSubState {
	public var dialogue:DialogueMgr;

	override public function new() {
		super();
        dialogue = new DialogueMgr(File.getContent("assets/test.lor"));
        add(dialogue);
        Thread.create(dialogue.startDialogue);
	}
}
