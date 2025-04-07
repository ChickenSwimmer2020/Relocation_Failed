package substates;

import sys.thread.Thread;
import sys.io.File;
import backend.dialogue.DialogueMgr;

class DialogueSubState extends FlxSubState {
	public var dialogue:DialogueMgr;

	override public function new(file:String = 'assets/test.lor') {
		super();
        dialogue = new DialogueMgr(File.getContent(file));
        add(dialogue);
        Thread.create(dialogue.startDialogue);
	}
}
