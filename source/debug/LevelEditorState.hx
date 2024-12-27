package debug;

import math.RFMath;
import flixel.group.FlxGroup;
import openfl.events.MouseEvent;
import rf_flixel.ui.FlxSquareButton;
import flixel.addons.ui.*;

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
    var TXT_boundries_outline:FlxUIText;
    var TXT_chapterID:FlxUIText;
    var TXT_levelID:FlxUIText;
    var levelID_TP:FlxUITooltip;
    var BoundriesX:FlxUIInputText;
    var BoundriesY:FlxUIInputText;
    var ChapterIDStepper:FlxUINumericStepper;
    //SCROLLING
    private var currentOffset:Float = 1;
    private var scrollSpeed:Float = 0.01;
    private var minOffset:Float = -0.5;
    private var maxOffset:Float = 5;
    private var lastOffset:Float = -1;
    

    public function new() {
        super();

        closeButton = new FlxSquareButton(1260, 0, 'X', ()->{ FlxG.switchState(new menu.MainMenu()); });
        add(closeButton);
        saveButton = new FlxButton(1180, 0, 'Save', ()->{ /**save when we can!**/ });
        add(saveButton);

        ToolText = new FlxText(0, 220, 0, '', 12);
        add(ToolText);

        cameraInfotext = new FlxText(0, 700, 0, '', 8);
        add(cameraInfotext);

        CreateUI();
        FlxG.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    public function CreateUI() {
        var TabGroups:FlxUITabMenu;
        SelecterTool = new FlxSquareButton(200, 0, 'S', ()->{ ToolSwap('Selector'); });
        ObjectTool = new FlxSquareButton(200, 20, 'O', ()->{  ToolSwap('Object'); });
        ItemTool = new FlxSquareButton(200, 40, 'I', ()->{    ToolSwap('Item'); });
        TriggerTool = new FlxSquareButton(200, 60, 'T', ()->{ ToolSwap('Trigger'); });
        var tabs = [
			{name: "MetaData", label: "MetaData"},
			{name: "tab_2", label: "Objects"},
			{name: "tab_3", label: "Items"},
			{name: "tab_4", label: "Triggers"}
		];
        TabGroups = new FlxUITabMenu(null, tabs, true);

        //tab group one -- metadata (the level header's data.)                   //ignore these blocks, their for formatting.
            TXT_boundries_outline = new FlxUIText(5, 10, 0, 'Level Boundries\n    X        Y', 8);
            TXT_chapterID = new FlxUIText(90, 10, 0, 'Chapter ID', 8);
            TXT_levelID = new FlxUIText(150, 10, 0, 'Level ID', 8);
                levelID_TP = new FlxUITooltip(100, 50);
            BoundriesX = new FlxUIInputText(5, 35, 30);
            BoundriesY = new FlxUIInputText(40, 35, 30);

            ChapterIDStepper = new FlxUINumericStepper(100, 25, 1, 0, 0, 999999, 0, 0);

    		var tab_group_1 = new FlxUI(null, TabGroups, null);
            tab_group_1.name = 'MetaData';
            tab_group_1.add(TXT_boundries_outline);
            tab_group_1.add(TXT_chapterID);
            tab_group_1.add(TXT_levelID);
    		tab_group_1.add(BoundriesX);
            tab_group_1.add(BoundriesY);
            tab_group_1.add(ChapterIDStepper);
            TabGroups.addGroup(tab_group_1);
        
        add(TabGroups);

        add(SelecterTool);
        add(ObjectTool);
        add(ItemTool);
        add(TriggerTool);

        add(levelID_TP);
    }

    private function onMouseWheel(event:MouseEvent):Void {
        // Adjust offset based on scroll direction
        currentOffset = RFMath.clamp(
            currentOffset + (if (event.delta < 0) scrollSpeed else -scrollSpeed),
            minOffset,
            maxOffset
        );
        FlxG.camera.zoom = currentOffset;
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
    }
    override public function destroy() {
        super.destroy();
        FlxG.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }
}