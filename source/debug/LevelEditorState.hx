package debug;

import flixel.math.FlxPoint;
import backend.level.LevelExceptions.LevelNullException;
import openfl.Assets;
import haxe.Json;
import flixel.text.FlxInputText;
import backend.level.LevelLoader;
import sys.io.File;
import math.RFMath;
import openfl.events.MouseEvent;
import rf_flixel.ui.FlxSquareButton;
import rf_flixel.ui.FlxSquareButtonLarger;
import flixel.addons.ui.*;
import haxe.io.Path;
import sys.FileSystem;
import flixel.group.FlxGroup;

using StringTools;

class LevelEditorState extends FlxState {
	var DefaultObjectData:Array<LevelObject> = [];
	var Level:Level;
	var closeButton:FlxSquareButton;
	var saveButton:FlxButton;
	var loadButton:FlxButton;
	var curTool:String = '';
	var ToolText:FlxText;
	var cameraInfotext:FlxText;
	var LevelInputText:FlxUIInputText;
	var CameraFollow:FlxObject;

	var levelGroup:FlxGroup;
	var objectGroup:FlxSpriteGroup;
	var uiGroup:FlxSpriteGroup;

	var LevelCamera:FlxCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 2);
	var UICamera:FlxCamera;

	// ! DO NOT TOUCH
	var LevelLoad:String = '';

	//* BUTTONS
	var SelecterTool:FlxSquareButton2;
	var ObjectTool:FlxSquareButton2;
	var ItemTool:FlxSquareButton2;
	var TriggerTool:FlxSquareButton2;
	//* UI
	var TabGroups:FlxUITabMenu;
	var tabs = [
		{name: "MetaData", label: "MetaData"},
		{name: "Objects", label: "Objects"},
		{name: "tab_3", label: "Items"},
		{name: "tab_4", label: "Triggers"},
		{name: "tab_5", label: "Doors"},
		{name: "tab_6", label: "Npcs"}
	];
	var tab_group_1:FlxUI;
	var tab_group_2:FlxUI;
	//* GROUP 1 [METADATA]
	var TXT_boundries_outline:FlxUIText;
	var TXT_chapterID:FlxUIText;
	var TXT_levelID:FlxUIText;
	var TXT_lerp:FlxUIText;
	var TXT_followStyle:FlxUIText;
	var levelID_TP:FlxUITooltip;
	var BoundriesX:FlxUIInputText;
	var BoundriesY:FlxUIInputText;
	var ChapterIDStepper:FlxUINumericStepper;
	var LevelIDStepper:FlxUINumericStepper;
	var CameraLockerBox:FlxUICheckBox;
	var CameraFollowStyleDropdown:FlxUIDropDownMenu;
	var CameraFollowLerp:FlxUINumericStepper;
	var isBeatstate:FlxUICheckBox;
	var FTSlider:FlxUISlider;
	//* GROUP 2 [OBJECTS]
	var OBJ_name:FlxUIInputText;
	var name_text:FlxUIText;
	var OBJ_alpha:FlxUINumericStepper;
	var OBJ_positionX:FlxUIInputText;
	var OBJ_positionY:FlxUIInputText;
	var OBJ_scaleX:FlxUIInputText;
	var OBJ_scaleY:FlxUIInputText;
	var OBJ_scrollFactorX:FlxUINumericStepper;
	var OBJ_scrollFactorY:FlxUINumericStepper;
	var OBJ_image:FlxUIInputText;
	var image_text:FlxUIText;
	var OBJ_visible:FlxUICheckBox;
	var OBJ_collidesWithPlayer:FlxUICheckBox;
	var OBJ_isBackground:FlxUICheckBox;
	var OBJ_renderOverPlayer:FlxUICheckBox;
	var OBJ_isAnimated:FlxUICheckBox;
	var OBJ_parrallaxBG:FlxUICheckBox;
	var OBJ_imagetip:FlxUITooltip;
	var OBJ_new:FlxButton; //* values = name, image, x, y, scale:x, scale:y, scrollX, scrollY, alpha, collide with player, visible, isBG, parrallaxBG, render over player
	var InputData:Array<Dynamic> = ['', '', 0, 0, 0, 1, 1, 1, 1, 1, false, true, false, false, false]; //* oh boy here we go...
	//                             [name, image, x, y, z, sclX, sclY, scrf]
	//* GROUP 3 [ITEMS]
	//* SCROLLING
	private var currentOffset:Float = 1;
	private var scrollSpeed:Float = 0.01;
	private var minOffset:Float = -0.5;
	private var maxOffset:Float = 5;
	private var lastOffset:Float = -1;

	//* LEVEL DATA (header)
	var Boundries:Array<Float> = [];
	var Chapter:Int = 0;
	var LevelID:Int = 0;
	var CameraLocked:Bool = false;
	var CameraFollowType:String = '';
	var CameraFollowLerpN:Float = 0;
	var BeatState:Bool = false;
	var Frametime:Float = 0;

	public function new() {
		super();

		// LevelCamera;
		////FlxG.cameras.add(LevelCamera, false);
		////LevelCamera.bgColor = 0x00000000;

		CameraFollow = new FlxObject(1280 / 20, 720 / 2, 0, 0);
		add(CameraFollow);

		levelGroup = new FlxGroup();
		add(levelGroup);
		////levelGroup.camera = LevelCamera;
		objectGroup = new FlxSpriteGroup();
		add(objectGroup);
		uiGroup = new FlxSpriteGroup();
		// uiGroup.camera = Copy.copy(FlxG.camera);
		add(uiGroup);
		uiGroup.scrollFactor.set(0, 0);

		closeButton = new FlxSquareButton(1260, 0, 'X', () -> {
			FlxG.switchState(menu.MainMenu.new);
		});
		uiGroup.add(closeButton);
		saveButton = new FlxButton(1180, 0, 'Save', () -> {
			saveLevel();
		});
		uiGroup.add(saveButton);
		loadButton = new FlxButton(1100, 0, 'Load', () -> {
			loadLevel();
		});
		uiGroup.add(loadButton);

		LevelInputText = new FlxUIInputText(1100, 20, 80);
		uiGroup.add(LevelInputText);

		ToolText = new FlxText(0, 220, 0, '', 12);
		uiGroup.add(ToolText);

		cameraInfotext = new FlxText(0, 700, 0, '', 8);
		uiGroup.add(cameraInfotext);

		CreateUI();
		FlxG.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		// loadLevel();
	}

	public function CreateUI() {
		SelecterTool = new FlxSquareButton2(300, 0, '', () -> {
			ToolSwap('Selector');
		});
		SelecterTool.label.font = 'assets/fonts/SEGMDL2.TTF';
		SelecterTool.label.antialiasing = false;
		ObjectTool = new FlxSquareButton2(300, 30, '', () -> {
			ToolSwap('Object');
		});
		ObjectTool.label.font = 'assets/fonts/SEGMDL2.TTF';
		ObjectTool.label.antialiasing = false;
		ItemTool = new FlxSquareButton2(300, 60, '', () -> {
			ToolSwap('Item');
		});
		ItemTool.label.font = 'assets/fonts/SEGMDL2.TTF';
		ItemTool.label.antialiasing = false;
		TriggerTool = new FlxSquareButton2(300, 90, '', () -> {
			ToolSwap('Trigger');
		});
		TriggerTool.label.font = 'assets/fonts/SEGMDL2.TTF';
		TriggerTool.label.antialiasing = false;
		TabGroups = new FlxUITabMenu(null, tabs, true);

		//* tab group one -- metadata (the level header's data.)
		//* ignore these blocks, their for formatting.
		TXT_boundries_outline = new FlxUIText(5, 10, 0, 'Level Boundries\n    X        Y', 8);
		TXT_chapterID = new FlxUIText(90, 10, 0, 'Chapter ID', 8);
		TXT_levelID = new FlxUIText(150, 10, 0, 'Level ID', 8);
		levelID_TP = new FlxUITooltip(100, 50);
		BoundriesX = new FlxUIInputText(5, 35, 30);
		BoundriesY = new FlxUIInputText(40, 35, 30);

		TXT_lerp = new FlxUIText(130, 51.75, 0, 'Camera Lerp', 8);
		TXT_followStyle = new FlxUIText(5, 90, 0, 'Camera Follow Style', 8);

		ChapterIDStepper = new FlxUINumericStepper(100, 25, 1, 0, 0, 999999, 0, 0);
		LevelIDStepper = new FlxUINumericStepper(150, 25, 1, 0, 0, 999999, 0, 0);

		CameraLockerBox = new FlxUICheckBox(5, 51.75, null, null, 'Lock Camera', null, null, () -> {
			CameraLocked = CameraLockerBox.checked;
		});

		isBeatstate = new FlxUICheckBox(200, 51.75, null, null, 'is Beatstate?', null, null, () -> {
			BeatState = isBeatstate.checked;
		});
		FTSlider = new FlxUISlider(this, 'Frametime', 130, 80, 0, 100, 150, 15, 5, FlxColor.WHITE, FlxColor.BLACK);
		FTSlider.nameLabel.text = '      Frametime';

		CameraFollowStyleDropdown = new FlxUIDropDownMenu(5, 70, FlxUIDropDownMenu.makeStrIdLabelArray([''], true), function(pressed:String) {
			switch (pressed) {
				case '0': // ! string but int??? wtf???
					trace('CameraOptions: LOCKON');
					CameraFollowType = 'LOCKON';
				case '1':
					trace('CameraOptions: PLATFORMER');
					CameraFollowType = 'PLATFORMER';
				case '2':
					trace('CameraOptions: TOPDOWN');
					CameraFollowType = 'TOPDOWN';
				case '3':
					trace('CameraOptions: TOPDOWN_TIGHT');
					CameraFollowType = 'TOPDOWN_TIGHT';
				case '4':
					trace('CameraOptions: SCREEN_BY_SCREEN');
					CameraFollowType = 'SCREEN_BY_SCREEN';
				case '5':
					trace('CameraOptions: NO_DEAD_ZONE');
					CameraFollowType = 'NO_DEAD_ZONE';
				default:
					trace('no value detected');
					CameraFollowType = '';
			}
		});
		var CameraOptions:Array<String> = [
			'LOCKON',
			'PLATFORMER',
			'TOPDOWN',
			'TOPDOWN_TIGHT',
			'SCREEN_BY_SCREEN',
			'NO_DEAD_ZONE'
		];
		CameraFollowStyleDropdown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(CameraOptions, true));

		CameraFollowLerp = new FlxUINumericStepper(150, 72, 1, 0, 0, 999999, 0, 0);

		tab_group_1 = new FlxUI(null, TabGroups, null);
		tab_group_1.name = 'MetaData';
		tab_group_1.add(TXT_boundries_outline);
		tab_group_1.add(TXT_chapterID);
		tab_group_1.add(TXT_levelID);
		tab_group_1.add(TXT_lerp);
		tab_group_1.add(TXT_followStyle);
		tab_group_1.add(BoundriesX);
		tab_group_1.add(BoundriesY);
		tab_group_1.add(ChapterIDStepper);
		tab_group_1.add(LevelIDStepper);
		tab_group_1.add(CameraLockerBox);
		tab_group_1.add(CameraFollowStyleDropdown);
		tab_group_1.add(CameraFollowLerp);
		tab_group_1.add(isBeatstate);
		tab_group_1.add(FTSlider);
		TabGroups.addGroup(tab_group_1);
		//* tab group 2 -- objects [the object data]
		OBJ_name = new FlxUIInputText(5, 5, 100);
		name_text = new FlxUIText(5, 5, 0, 'Object Name', 8);
		name_text.color = 0x333333;
		OBJ_image = new FlxUIInputText(5, 25, 100);
		image_text = new FlxUIText(5, 25, 0, 'Image Path', 8);
		image_text.color = 0x333333;

		OBJ_alpha = new FlxUINumericStepper(230, 40, 1, 0, 0, 100, 0, 0);
		var alphaText:FlxUIText = new FlxUIText(230, 27, 0, 'Alpha', 8);
		OBJ_positionX = new FlxUIInputText(120, 15, 50);
		OBJ_positionY = new FlxUIInputText(175, 15, 50);
		var posText:FlxUIText = new FlxUIText(150, 0, 0, 'Position', 8);
		OBJ_scaleX = new FlxUIInputText(120, 40, 50);
		OBJ_scaleY = new FlxUIInputText(175, 40, 50);
		var sclText:FlxUIText = new FlxUIText(155, 27, 0, 'Scale', 8);
		OBJ_scrollFactorX = new FlxUINumericStepper(230, 15, 1, 0, 0, 100, 0, 0);
		OBJ_scrollFactorY = new FlxUINumericStepper(265, 15, 1, 0, 0, 100, 0, 0);
		var srfText:FlxUIText = new FlxUIText(230, 0, 0, 'ScrollFactor', 8);
		OBJ_collidesWithPlayer = new FlxUICheckBox(5, 50, null, null, 'Collides With Player', null, null, null);

		////OBJ_isAnimated = new FlxUICheckBox(5, 100, null, null, 'Is Animated', null, null, null);
		OBJ_isBackground = new FlxUICheckBox(5, 75, null, null, 'Is Background', null, null, null);
		OBJ_parrallaxBG = new FlxUICheckBox(100, 75, null, null, 'Parrallax BG', null, null, null);
		OBJ_renderOverPlayer = new FlxUICheckBox(200, 75, null, null, 'Render Over Player', null, null, null);
		OBJ_visible = new FlxUICheckBox(100, 55, null, null, 'Visible', null, null, null);

		OBJ_imagetip = new FlxUITooltip(120, 120, new Anchor(0, 0, "right", "top", "left", "top"));

		OBJ_new = new FlxButton(5, 105, 'New Object', () -> {
			CreateObject(InputData);
		});

		tab_group_2 = new FlxUI(null, TabGroups, null);
		tab_group_2.name = 'Objects';
		tab_group_2.add(OBJ_name);
		tab_group_2.add(OBJ_alpha);
		tab_group_2.add(alphaText);
		tab_group_2.add(OBJ_positionX);
		tab_group_2.add(OBJ_positionY);
		tab_group_2.add(posText);
		tab_group_2.add(OBJ_scaleX);
		tab_group_2.add(OBJ_scaleY);
		tab_group_2.add(sclText);
		tab_group_2.add(OBJ_scrollFactorX);
		tab_group_2.add(OBJ_scrollFactorY);
		tab_group_2.add(srfText);
		tab_group_2.add(OBJ_collidesWithPlayer);
		tab_group_2.add(OBJ_image);
		// tab_group_2.add(OBJ_isAnimated); //TODO: implement properly
		tab_group_2.add(OBJ_isBackground);
		tab_group_2.add(OBJ_parrallaxBG);
		tab_group_2.add(OBJ_renderOverPlayer);
		tab_group_2.add(OBJ_visible);
		tab_group_2.add(OBJ_new);
		tab_group_2.add(name_text);
		tab_group_2.add(image_text);
		TabGroups.addGroup(tab_group_2);

		uiGroup.add(TabGroups);

		uiGroup.add(SelecterTool);
		uiGroup.add(ObjectTool);
		uiGroup.add(ItemTool);
		uiGroup.add(TriggerTool);

		uiGroup.add(levelID_TP);
		uiGroup.add(OBJ_imagetip);
	}

	private function onMouseWheel(event:MouseEvent):Void { //* chatgpt re-wrote this to possibly cause less problems? idk, if we need to rewrite it we can.
		//* Adjust offset based on scroll direction
		currentOffset = RFMath.clamp(currentOffset + (if (event.delta < 0) -scrollSpeed else scrollSpeed),
			0.1, // ? Minimum valid zoom level (updated from -0.5)
			maxOffset);
		////levelGroup.scale.set(currentOffset, currentOffset);
		////FlxG.log.add("Zoom level set to: " + currentOffset); //keep track of the zoom properly even though we have a text for that.
	}

	public function ToolSwap(Tool:String) {
		switch (Tool) {
			case 'Selector':
				curTool = 'Selector Tool';
			case 'Object':
				curTool = 'Object Tool';
			case 'Item':
				curTool = 'Item Tool';
			case 'Trigger':
				curTool = 'Trigger Tool';
			default:
				curTool = '';
		}
	}

	override public function update(elapsed:Float) {
		if (uiGroup.camera.scroll == null)
			uiGroup.camera.scroll = FlxPoint.get();
		super.update(elapsed);

		if (FlxG.mouse.overlaps(name_text) || OBJ_name.text != '') {
			name_text.alpha = 0;
		} else if (!FlxG.mouse.overlaps(name_text) || OBJ_name.text == '') {
			name_text.alpha = 1;
		}

		if (FlxG.mouse.overlaps(image_text) || OBJ_image.text != '') {
			image_text.alpha = 0;
		} else if (!FlxG.mouse.overlaps(image_text) || OBJ_image.text == '') {
			image_text.alpha = 1;
		}

		FlxG.camera.follow(CameraFollow, LOCKON, 15);

		LevelLoad = LevelInputText.text.toLowerCase() + '.json';

		if (FlxG.mouse.overlaps(TXT_levelID) && TabGroups.selected_tab_id == 'MetaData') {
			levelID_TP.show(TXT_levelID, 'Watch out!', 'make sure to set this to the file name or save loading wont work!', true, true, true);
		} else {
			levelID_TP.hide();
		}

		if (FlxG.mouse.overlaps(OBJ_image) && TabGroups.selected_tab_id == 'Objects') {
			OBJ_imagetip.show(OBJ_image, 'Heads Up!',
				'the default path is assets, if you have a sub-folder your image is in, make sure to type\n\"[folderTitle]/[ImageTitle]\"\nminus the brackets!',
				true, true, true);
		} else {
			OBJ_imagetip.hide();
		}

		ToolText.text = curTool;
		////cameraInfotext.text = 'Zoom:${levelGroup.scale}';

		if (curTool == 'Selector Tool' && Level != null) {
			for (object in Level.objects) {
				if (!object.isBackground) {
					if (FlxG.mouse.overlaps(object)) {
						object.color = 0x1900ff;
						if (FlxG.mouse.justPressed) {
							OBJ_name.text = object.name;
							OBJ_alpha.value = object.alpha;
							OBJ_positionX.text = Std.string(object.x);
							OBJ_positionY.text = Std.string(object.y);
							OBJ_scaleX.text = Std.string(object.scale.x);
							OBJ_scaleY.text = Std.string(object.scale.y);
							OBJ_scrollFactorX.value = object.scrollFactor.x;
							OBJ_scrollFactorY.value = object.scrollFactor.y;
							OBJ_image.text = object.texture;
							OBJ_visible.checked = object.visible;
							OBJ_collidesWithPlayer.checked = object.doubleAxisCollide;
							OBJ_isBackground.checked = object.isBackground;
							OBJ_renderOverPlayer.checked = object.isForegroundSprite;
							OBJ_parrallaxBG.checked = object.parrallaxBG;
						}
					} else
						object.color = 0xffffff;
				}
			}
		}

		InputData[0] = OBJ_name.text; //* name
		InputData[1] = OBJ_image.text; //* image
		InputData[2] = OBJ_positionX.text; //* X
		InputData[3] = OBJ_positionY.text; //* Y
		InputData[4] = 0;
		InputData[5] = OBJ_scaleX.text; //* Scale X
		InputData[6] = OBJ_scaleY.text; //* Scale Y
		InputData[7] = OBJ_scrollFactorX.value; //* Scroll X
		InputData[8] = OBJ_scrollFactorY.value; //* Scroll Y
		InputData[9] = (OBJ_alpha.value / 100); //* alpha
		InputData[10] = OBJ_collidesWithPlayer.checked; //* collide with player
		InputData[11] = OBJ_visible.checked; //* visible
		InputData[12] = OBJ_isBackground.checked; //* is background
		InputData[13] = OBJ_parrallaxBG.checked; //* is parallax bg
		InputData[14] = OBJ_renderOverPlayer.checked; //* render over player

		if (FlxG.keys.anyPressed([UP, DOWN, LEFT, RIGHT, SHIFT])) {
			if (FlxG.keys.anyPressed([UP])) {
				CameraFollow.y -= 10;
			}
			if (FlxG.keys.anyPressed([DOWN])) {
				CameraFollow.y += 10;
			}
			if (FlxG.keys.anyPressed([LEFT])) {
				CameraFollow.x -= 10;
			}
			if (FlxG.keys.anyPressed([RIGHT])) {
				CameraFollow.x += 10;
			}
			if (FlxG.keys.anyPressed([UP]) && FlxG.keys.anyPressed([SHIFT])) {
				CameraFollow.y -= 100;
			}
			if (FlxG.keys.anyPressed([DOWN]) && FlxG.keys.anyPressed([SHIFT])) {
				CameraFollow.y += 100;
			}
			if (FlxG.keys.anyPressed([LEFT]) && FlxG.keys.anyPressed([SHIFT])) {
				CameraFollow.x -= 100;
			}
			if (FlxG.keys.anyPressed([RIGHT]) && FlxG.keys.anyPressed([SHIFT])) {
				CameraFollow.x += 100;
			}
		}

		@:privateAccess {
			switch (TabGroups.selected_tab_id) {
				case 'MetaData':
					TabGroups.resize(300, 150);
				case 'Objects':
					TabGroups.resize(300, 150);
				case 'tab_3':
					TabGroups.resize(300, 150);
				case 'tab_4':
					TabGroups.resize(300, 150);
				case 'tab_5':
					TabGroups.resize(300, 150);
				case 'tab_6':
					TabGroups.resize(300, 150);
				default:
					TabGroups.resize(300, 150);
			}
		}
	}

	override public function destroy() {
		super.destroy();
		FlxG.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}

	public function CreateObject(Data:Array<Dynamic>) {
		var spr:FlxSprite = new FlxSprite(Std.parseFloat(Data[2]), Std.parseFloat(Data[3])).loadGraphic(Assets.image(Data[1]), false, 0, 0);
		spr.alpha = Data[9];
		spr.scale.set(Std.parseInt(Data[5]), Std.parseInt(Data[6]));
		spr.updateHitbox();
		spr.scrollFactor.set(Data[7], Data[8]);
		objectGroup.add(spr);
		trace(Data);
		DefaultObjectData.push({
			Name: Data[0],
			IMG: Data[1],
			X: Std.parseFloat(Data[2]),
			Y: Std.parseFloat(Data[3]),
			Z: Std.parseFloat(Data[4]),
			ScaleX: Std.parseFloat(Data[5]),
			ScaleY: Std.parseFloat(Data[6]),
			SFX: Data[7],
			SFY: Data[8],
			Alpha: Data[9],
			DoubleAxisCollide: Data[10],
			VIS: Data[11],
			IsBackground: Data[12],
			RenderOverPlayer: Data[13],
			ParrallaxBG: Data[14]
		},);
		trace('New Object Added To Level\n\n$DefaultObjectData');
	}

	public function saveLevel() {
		var SaveDir:String;

		SaveDir = 'assets';
		FileSystem.createDirectory(SaveDir);
		var header:LevelHeader = {
			LevelID: 'level${LevelIDStepper.value}',
			Chapter: Chapter,
			Boundries: Boundries,
			CameraLocked: CameraLocked,
			CameraFollowStyle: CameraFollowType,
			CameraFollowLerp: CameraFollowLerpN,
			isBeatState: BeatState,
			beatstateframetime: Frametime
		}
		var level:LevelData = {
			header: header,
			objects: DefaultObjectData,
			doors: [],
			items: [],
			triggers: [],
			interactables: []
		};
		File.saveContent('$SaveDir/level${LevelIDStepper.value}.json', tjson.TJSON.encode(level, 'fancy'));
	}

	public function loadLevel() {
		var SaveDir = backend.Assets.asset(LevelLoad);
		var jsonContent:String = '';
		try {
			jsonContent = File.getContent(SaveDir);
		} catch (e) {
			trace(new LevelNullException(e.message, e.stack.toString()).toString());
			return;
		}
		var Data = tjson.TJSON.parse(jsonContent);
		// trace(Data);
		ActuallyLoadLevelDataIntoTheUI(Data); //* (HEADER) load the level directly into the ui.
		try {
			if (FileSystem.exists(SaveDir))
				CreateLevel(LevelLoad);
			else
				trace("Level doesn't exist! Looked in directory: " + SaveDir);
		} catch (e) {
			////trace(e.message, e.stack);
			trace(new LevelNullException(e.message, e.stack.toString()).toString());
		}
	}

	private function ActuallyLoadLevelDataIntoTheUI(Json:LevelData) {
		LevelIDStepper.value = Std.parseFloat(Json.header.LevelID.substr(5));
		CameraFollowLerp.value = Std.int(Json.header.CameraFollowLerp);
		switch (Json.header.CameraFollowStyle) {
			case 'LOCKON':
				CameraFollowStyleDropdown.selectedId = '0';
			case 'PLATFORMER':
				CameraFollowStyleDropdown.selectedId = '1';
			case 'TOPDOWN':
				CameraFollowStyleDropdown.selectedId = '2';
			case 'TOPDOWN_TIGHT':
				CameraFollowStyleDropdown.selectedId = '3';
			case 'SCREEN_BY_SCREEN':
				CameraFollowStyleDropdown.selectedId = '4';
			case 'NO_DEAD_ZONE':
				CameraFollowStyleDropdown.selectedId = '5';
			default:
				CameraFollowStyleDropdown.selectedId = '0';
		}
		BoundriesX.text = Std.string(Json.header.Boundries[0]);
		BoundriesY.text = Std.string(Json.header.Boundries[1]);
		CameraLockerBox.checked = Json.header.CameraLocked;
		ChapterIDStepper.value = Std.int(Json.header.Chapter);

		// assign these down here so it does it only when a file is loaded instead of EVERY. SINGLE. FRAME.
		Boundries[0] = Std.parseFloat(BoundriesX.text);
		Boundries[1] = Std.parseFloat(BoundriesY.text);
		Chapter = Std.int(ChapterIDStepper.value);
		LevelID = Std.int(LevelIDStepper.value);
		CameraLocked = CameraLockerBox.checked;
		CameraFollowLerpN = CameraFollowLerp.value;
		BeatState = Json.header.isBeatState;
		isBeatstate.checked = BeatState;
		Frametime = Json.header.beatstateframetime;
	}

	private function CreateLevel(Json:String) {
		Level = new Level(null, null, true);
        Level.levelData = LevelLoader.parseLevelData(File.getContent(backend.Assets.asset(Json)));
		Level.loadLevel();
		levelGroup.add(Level);
		Level.camera = levelGroup.camera;
		for (object in Level.objects) {
			object.camera = levelGroup.camera;
			DefaultObjectData.push({
				Name: object.name,
				Alpha: object.alpha,
				X: object.x,
				Y: object.y,
				Z: object.z,
				ScaleX: object.scale.x,
				ScaleY: object.scale.y,
				SFX: object.scrollFactor.x,
				SFY: object.scrollFactor.y,
				IMG: object.texture,
				VIS: object.visible,
				DoubleAxisCollide: object.doubleAxisCollide,
				TripleAxisCollide: object.tripleAxisCollide,
				IsBackground: object.isBackground,
				RenderOverPlayer: object.isForegroundSprite,
				ParrallaxBG: object.parrallaxBG
			},);
		}
	}
}
