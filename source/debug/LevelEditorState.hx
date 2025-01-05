package debug;

import sys.io.File;
import math.RFMath;
import flixel.group.FlxGroup;
import openfl.events.MouseEvent;
import rf_flixel.ui.FlxSquareButton;
import flixel.addons.ui.*;
import sys.FileSystem;

class LevelEditorState extends FlxState {
    var closeButton:FlxSquareButton;
    var saveButton:FlxButton;
    var curTool:String = '';
    var ToolText:FlxText;
    var cameraInfotext:FlxText;

    //BUTTONS
    var SelecterTool:FlxSquareButton;
    var ObjectTool:FlxSquareButton;
    var ItemTool:FlxSquareButton;
    var TriggerTool:FlxSquareButton;
    //UI
    var TabGroups:FlxUITabMenu;
    var tabs = [
        {name: "MetaData", label: "MetaData"},
        {name: "tab_2", label: "Objects"},
        {name: "tab_3", label: "Items"},
        {name: "tab_4", label: "Triggers"}
    ];
    var tab_group_1:FlxUI;
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

        ToolText = new FlxText(0, 220, 0, '', 12);
        add(ToolText);

        cameraInfotext = new FlxText(0, 700, 0, '', 8);
        add(cameraInfotext);

        CreateUI();
        FlxG.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    public function CreateUI() {
        SelecterTool = new FlxSquareButton(200, 0, 'S', ()->{ ToolSwap('Selector'); });
        ObjectTool = new FlxSquareButton(200, 20, 'O', ()->{  ToolSwap('Object'); });
        ItemTool = new FlxSquareButton(200, 40, 'I', ()->{    ToolSwap('Item'); });
        TriggerTool = new FlxSquareButton(200, 60, 'T', ()->{ ToolSwap('Trigger'); });
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
        if(FlxG.mouse.overlaps(TXT_levelID)) {
            levelID_TP.show(TXT_levelID, 'Watch out!', 'make sure to set this to the file name or save loading wont work!', true, true, true);
        }else{
            levelID_TP.hide();
        }
        ToolText.text = curTool;
        cameraInfotext.text = 'Zoom:${FlxG.camera.zoom}';

        if(TabGroups.selected_tab_id == 'MetaData') {
            @:privateAccess
            TabGroups.resize(TabGroups.get_width(), 150);
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
}