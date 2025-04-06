package debug.leveleditor;

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
}
