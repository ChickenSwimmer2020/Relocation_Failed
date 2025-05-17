package debug.leveleditor;

import flixel.sound.FlxSound;
import debug.ChooseEditor;

class EditorState extends FlxState {
	public static var editorMode:String = '';
	public var StageCAM:FlxCamera;
	public var uiCAM:debug.leveleditor.ui.Editor_ui.EditorUI;

	public function new(editorType:String = 'level'){
		super();
		editorMode = editorType;
		Application.current.window.title = "Relocation Failed -- Editor";
	}

	override public function create(){
		super.create();
		StageCAM = new FlxCamera(0, 0, 0, 0, 0);
		StageCAM.bgColor = 0x00000000;
		FlxG.cameras.add(StageCAM, false);

		uiCAM = new debug.leveleditor.ui.Editor_ui.EditorUI(0, 0, 0, 0, 0, editorMode);
		uiCAM.bgColor = 0x00000000;
		FlxG.cameras.add(uiCAM, false);
		add(uiCAM.UI);
	}
	override public function update(elapsed:Float){
		super.update(elapsed);
		if(elapsed % 2 == 0){ //on every second frame, hopefully to make it not sound choppy?
			ChooseEditor.DRUMS.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.BALLS.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.BASS.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.DEEPERBASS.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.NPC.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.AI.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.ITEM.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.ANIM.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.LEVEL.time = ChooseEditor.MODIFIER.time;
			ChooseEditor.WEAPONS.time = ChooseEditor.MODIFIER.time;
		}
		switch(uiCAM.tpe){ //FOR MUSIC DO NOT TOUCH
			case 'Level': //THIS. SYSTEM. SUCKS. but it works so idfc
				ChooseEditor.BALLS.volume = FlxG.sound.volume;
				ChooseEditor.BASS.volume = FlxG.sound.volume;
				ChooseEditor.DEEPERBASS.volume = FlxG.sound.volume;
				ChooseEditor.DRUMS.volume = FlxG.sound.volume;
				ChooseEditor.NPC.volume = FlxG.sound.volume;
				ChooseEditor.AI.volume = FlxG.sound.volume;
				ChooseEditor.ITEM.volume = FlxG.sound.volume;
				ChooseEditor.ANIM.volume = FlxG.sound.volume;
				ChooseEditor.LEVEL.volume = FlxG.sound.volume;
				ChooseEditor.WEAPONS.volume = FlxG.sound.volume;
			case 'Item':
				ChooseEditor.BALLS.volume = FlxG.sound.volume;
				ChooseEditor.BASS.volume = FlxG.sound.volume;
				ChooseEditor.DEEPERBASS.volume = FlxG.sound.volume;
				ChooseEditor.DRUMS.volume = FlxG.sound.volume;
				ChooseEditor.NPC.volume = 0;
				ChooseEditor.AI.volume = 0;
				ChooseEditor.ITEM.volume = FlxG.sound.volume;
				ChooseEditor.ANIM.volume = 0;
				ChooseEditor.LEVEL.volume = 0;
				ChooseEditor.WEAPONS.volume = 0;
			case 'AI':
				ChooseEditor.BALLS.volume = FlxG.sound.volume;
				ChooseEditor.BASS.volume = FlxG.sound.volume;
				ChooseEditor.DEEPERBASS.volume = FlxG.sound.volume;
				ChooseEditor.DRUMS.volume = FlxG.sound.volume;
				ChooseEditor.NPC.volume = 0;
				ChooseEditor.AI.volume = FlxG.sound.volume;
				ChooseEditor.ITEM.volume = 0;
				ChooseEditor.ANIM.volume = 0;
				ChooseEditor.LEVEL.volume = 0;
				ChooseEditor.WEAPONS.volume = 0;
			case 'NPC':
				ChooseEditor.BALLS.volume = FlxG.sound.volume;
				ChooseEditor.BASS.volume = FlxG.sound.volume;
				ChooseEditor.DEEPERBASS.volume = FlxG.sound.volume;
				ChooseEditor.DRUMS.volume = FlxG.sound.volume;
				ChooseEditor.NPC.volume = FlxG.sound.volume;
				ChooseEditor.AI.volume = 0;
				ChooseEditor.ITEM.volume = 0;
				ChooseEditor.ANIM.volume = 0;
				ChooseEditor.LEVEL.volume = 0;
				ChooseEditor.WEAPONS.volume = 0;
			case 'Anim':
				ChooseEditor.BALLS.volume = FlxG.sound.volume;
				ChooseEditor.BASS.volume = FlxG.sound.volume;
				ChooseEditor.DEEPERBASS.volume = FlxG.sound.volume;
				ChooseEditor.DRUMS.volume = FlxG.sound.volume;
				ChooseEditor.NPC.volume = 0;
				ChooseEditor.AI.volume = 0;
				ChooseEditor.ITEM.volume = 0;
				ChooseEditor.ANIM.volume = FlxG.sound.volume;
				ChooseEditor.LEVEL.volume = 0;
				ChooseEditor.WEAPONS.volume = 0;
			case 'Weapon':
				ChooseEditor.BALLS.volume = FlxG.sound.volume;
				ChooseEditor.BASS.volume = FlxG.sound.volume;
				ChooseEditor.DEEPERBASS.volume = FlxG.sound.volume;
				ChooseEditor.DRUMS.volume = FlxG.sound.volume;
				ChooseEditor.NPC.volume = 0;
				ChooseEditor.AI.volume = 0;
				ChooseEditor.ITEM.volume = 0;
				ChooseEditor.ANIM.volume = 0;
				ChooseEditor.LEVEL.volume = 0;
				ChooseEditor.WEAPONS.volume = FlxG.sound.volume;
		}
	}
}
