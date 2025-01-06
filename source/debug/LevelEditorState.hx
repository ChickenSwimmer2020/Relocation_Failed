package debug;

import flixel.text.FlxInputText;
import backend.level.LevelLoader.LevelData;
import haxe.Json;
import sys.io.File;
import math.RFMath;
import openfl.events.MouseEvent;
import rf_flixel.ui.FlxSquareButton;
import rf_flixel.ui.FlxSquareButtonLarger;
import flixel.addons.ui.*;
import haxe.io.Path;
import sys.FileSystem;
import backend.level.LevelLoader.LevelHeader;

using StringTools;

class LevelEditorState extends FlxState {
    var closeButton:FlxSquareButton;
    var saveButton:FlxButton;
    var loadButton:FlxButton;
    var curTool:String = '';
    var ToolText:FlxText;
    var cameraInfotext:FlxText;
    var LevelInputText:FlxUIInputText;

    //DO NOT TOUCH
    var LevelLoad:String = '';

    //BUTTONS
    var SelecterTool:FlxSquareButton2;
    var ObjectTool:FlxSquareButton2;
    var ItemTool:FlxSquareButton2;
    var TriggerTool:FlxSquareButton2;
    //UI
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
    //GROUP 1 [METADATA]
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
    //GROUP 2 [OBJECTS]
        var OBJ_name:FlxUIInputText;
        var OBJ_alpha:FlxUINumericStepper;
        var OBJ_positionX:FlxUIInputText;
        var OBJ_positionY:FlxUIInputText;
        var OBJ_scaleX:FlxUINumericStepper;
        var OBJ_scaleY:FlxUINumericStepper;
        var OBJ_scrollFactorX:FlxUINumericStepper;
        var OBJ_scrollFactorY:FlxUINumericStepper;
        var OBJ_image:FlxUIInputText;
        var OBJ_visible:FlxUICheckBox;
        var OBJ_collidesWithPlayer:FlxUICheckBox;
        var OBJ_isBackground:FlxUICheckBox;
        var OBJ_renderOverPlayer:FlxUICheckBox;
        var OBJ_isAnimated:FlxUICheckBox;
        var OBJ_parrallaxBG:FlxUICheckBox;
    //GROUP 3 [ITEMS]
    //SCROLLING
    private var currentOffset:Float = 1;
    private var scrollSpeed:Float = 0.01;
    private var minOffset:Float = -0.5;
    private var maxOffset:Float = 5;
    private var lastOffset:Float = -1;




    //LEVEL DATA (header)
    var Boundries:Array<Float> = [];
    var Chapter:Int = 0;
    var Level:Int = 0;
    var CameraLocked:Bool = false;
    var CameraFollowType:String = '';
    var CameraFollowLerpN:Float = 0;
    

    public function new() {
        super();

        closeButton = new FlxSquareButton(1260, 0, 'X', ()->{ FlxG.switchState(new menu.MainMenu()); });
        add(closeButton);
        saveButton = new FlxButton(1180, 0, 'Save', ()->{ saveLevel(); });
        add(saveButton);
        loadButton = new FlxButton(1100, 0, 'Load', ()->{ loadLevel(); });
        add(loadButton);

        LevelInputText = new FlxUIInputText(1100, 20, 80);
        add(LevelInputText);

        ToolText = new FlxText(0, 220, 0, '', 12);
        add(ToolText);

        cameraInfotext = new FlxText(0, 700, 0, '', 8);
        add(cameraInfotext);

        CreateUI();
        FlxG.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    public function CreateUI() {
        SelecterTool = new FlxSquareButton2(300, 0, '', ()->{ ToolSwap('Selector'); });
        SelecterTool.label.font = 'assets/fonts/SEGMDL2.TTF';
        SelecterTool.label.antialiasing = false;
        ObjectTool = new FlxSquareButton2(300, 30, '', ()->{  ToolSwap('Object'); });
        ObjectTool.label.font = 'assets/fonts/SEGMDL2.TTF';
        ObjectTool.label.antialiasing = false;
        ItemTool = new FlxSquareButton2(300, 60, '', ()->{    ToolSwap('Item'); });
        ItemTool.label.font = 'assets/fonts/SEGMDL2.TTF';
        ItemTool.label.antialiasing = false;
        TriggerTool = new FlxSquareButton2(300, 90, '', ()->{ ToolSwap('Trigger'); });
        TriggerTool.label.font = 'assets/fonts/SEGMDL2.TTF';
        TriggerTool.label.antialiasing = false;
        TabGroups = new FlxUITabMenu(null, tabs, true);

        //tab group one -- metadata (the level header's data.)                   //ignore these blocks, their for formatting.
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

            CameraLockerBox = new FlxUICheckBox(5, 51.75, null, null, 'Lock Camera', null, null, ()->{ CameraLocked = CameraLockerBox.checked; });

            CameraFollowStyleDropdown = new FlxUIDropDownMenu(5, 70, FlxUIDropDownMenu.makeStrIdLabelArray([''], true), function(pressed:String) {
                switch(pressed) {
                    case '0': //string but int??? wtf???
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
            var CameraOptions:Array<String> = ['LOCKON', 'PLATFORMER', 'TOPDOWN', 'TOPDOWN_TIGHT', 'SCREEN_BY_SCREEN', 'NO_DEAD_ZONE'];
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
            TabGroups.addGroup(tab_group_1);
        //tab group 2 -- objects [the object data]
            OBJ_name = new FlxUIInputText(5, 5, 100);
            OBJ_name.name = 'Name';
            OBJ_alpha = new FlxUINumericStepper(50, 25, 1, 0, 0, 100, 0, 0);
                var alphaText:FlxUIText = new FlxUIText(5, 25, 0, 'Alpha', 8);
            OBJ_positionX = new FlxUIInputText(120, 5, 50);
            OBJ_positionY = new FlxUIInputText(175, 5, 50);
                var posText:FlxUIText = new FlxUIText(5, 45, 0, 'Position\nX        Y', 8);



            tab_group_2 = new FlxUI(null, TabGroups, null);
            tab_group_2.name = 'Objects';
            tab_group_2.add(OBJ_name);
            tab_group_2.add(OBJ_alpha);
            tab_group_2.add(alphaText);
            tab_group_2.add(OBJ_positionX);
            tab_group_2.add(OBJ_positionY);
            tab_group_2.add(posText);
            TabGroups.addGroup(tab_group_2);
        
        add(TabGroups);

        add(SelecterTool);
        add(ObjectTool);
        add(ItemTool);
        add(TriggerTool);

        add(levelID_TP);
    }

    private function onMouseWheel(event:MouseEvent):Void { //chatgpt re-wrote this to possibly cause less problems? idk, if we need to rewrite it we can.
        // Adjust offset based on scroll direction
        currentOffset = RFMath.clamp(
            currentOffset + (if (event.delta < 0) -scrollSpeed else scrollSpeed),
            0.1, // Minimum valid zoom level (updated from -0.5)
            maxOffset
        );
        FlxG.camera.zoom = currentOffset;
        FlxG.log.add("Zoom level set to: " + currentOffset); //keep track of the zoom properly even though we have a text for that.
    }

    public function ToolSwap(Tool:String) {
        switch(Tool) {
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
        super.update(elapsed);

        LevelLoad = LevelInputText.text + '.json';

        if(FlxG.mouse.overlaps(TXT_levelID) && TabGroups.selected_tab_id == 'MetaData') {
            levelID_TP.show(TXT_levelID, 'Watch out!', 'make sure to set this to the file name or save loading wont work!', true, true, true);
        }else{
            levelID_TP.hide();
        }
        ToolText.text = curTool;
        cameraInfotext.text = 'Zoom:${FlxG.camera.zoom}';

        @:privateAccess {
        switch(TabGroups.selected_tab_id)
            {
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


        //actually asign level values to the steppers and input. I SOMEHOW FORGOT TO DO THIS :man_facepalming:
        Boundries[0] = Std.parseFloat(BoundriesX.text);
        Boundries[1] = Std.parseFloat(BoundriesY.text);
        Chapter = Std.int(ChapterIDStepper.value);
        Level = Std.int(LevelIDStepper.value);
        CameraLocked = CameraLockerBox.checked;
        CameraFollowLerpN = CameraFollowLerp.value;
    }
    override public function destroy() {
        super.destroy();
        FlxG.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    public function saveLevel() { 
        //TODO: make this work properly and save to custom json location.
		var SaveDir:String;
		var SaveName:String = 'Level$Level.json';

		SaveDir = 'assets';
        FileSystem.createDirectory(SaveDir);
		File.saveContent('$SaveDir/$SaveName', '{
    "header":{
    "LevelID": "level$Level",
    "Chapter": $Chapter,
    "Boundries": [${Boundries[0]}, ${Boundries[1]}],
    "CameraLocked": ${CameraLocked},
    "CameraFollowStyle": "$CameraFollowType",
    "CameraFollowLerp": $CameraFollowLerpN
    }
}');
	}

    public function loadLevel() {
		var SaveDir = Path.join(['assets/', LevelLoad]);

		if (!FileSystem.exists('$SaveDir')) { // dynamically check if the file already exists, so we dont accidently overwrite it.
			trace('no data to load.');
		} else {
            var jsonContent = File.getContent('assets/$LevelLoad');
            var Data = Json.parse(jsonContent);
            //trace(Data);
            ActuallyLoadLevelDataIntoTheUI(Data);
		}
    }
    private function ActuallyLoadLevelDataIntoTheUI(Json:LevelData) {
        LevelIDStepper.value = Std.parseFloat(Json.header.LevelID.substr(5));
        CameraFollowLerp.value = Std.int(Json.header.CameraFollowLerp);
        switch(Json.header.CameraFollowStyle) {
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
    }
}