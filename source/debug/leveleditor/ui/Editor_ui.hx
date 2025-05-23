package debug.leveleditor.ui;

import debug.leveleditor.ui.EditorUI_dropdown.EditorUIDropdownMenu;
import debug.leveleditor.ui.EditorUI_list.ListObject;
import debug.leveleditor.ui.EditorUI_list.EditorUIList;
import backend.level.LevelLoader.LevelObject;
import debug.leveleditor.ui.EditorUI_slider.EditorUISlider;
import debug.leveleditor.ui.EditorUI_NumericStepper.EditorUIStepper;
import tjson.TJSON;
import openfl.Assets;
import flixel.math.FlxRect;
import lime.math.Rectangle;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUIDropDownMenu;
import debug.leveleditor.Editor.EditorState;
import debug.leveleditor.ui.EditorUI_button.EditorUIButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.tweens.FlxEase;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import sys.FileSystem;
import sys.io.File;
import flixel.text.FlxInputText;
import debug.leveleditor.ui.EditorUI_tabsBox.EditorUITABBOX;

using StringTools;

class EditorUI extends FlxCamera{
    public var UI:FlxSpriteGroup;
    public var tpe:String = '';
    var backButton:EditorUIButton;
    var box:EditorUITABBOX;
    var graphicnotexist:FlxText;
    var GraphicInput:FlxInputText;
    var tmr:FlxTimer = new FlxTimer(); //central.

    //item editor
    var hasReturnCondition:FlxUICheckBox;
    var returnCondition:FlxInputText; //https://www.youtube.com/watch?v=Ea3r5fCZH9Y
    var hasStatusMessage:FlxUICheckBox;
    var StatusMessage:FlxInputText;
    var filePreview:FlxText;
    var onComplete:FlxInputText;
    var isWeapon:FlxUICheckBox;
    var itemName:FlxInputText;
    //level editor
    var CameraFollowType:String = '';
    var bpm:Int = 1;
    public var objects:FlxSpriteGroup;
    //actual ui elements
    var saveMetadata:EditorUIButton;

    var loadMetadata:EditorUIButton;

    var createObject:EditorUIButton;

    var ObjectsList:EditorUIList;

    var isBeatstate:FlxUICheckBox; //TODO: make RFUI varient
    var CameraLocked:FlxUICheckBox; //TODO: make RFUI varient
    var CameraFollowStyle:EditorUIDropdownMenu;
    var bpmslider:EditorUISlider;
    var levelBounds:FlxUIInputText; //TODO: make RFUI varient
    var cameraLerpSpeed:EditorUIStepper;
    var levelID:FlxUIInputText; //TODO: make RFUI varient
    var chapterID:FlxUIInputText; //TODO: make RFUI varient

    //OBJECT CREATION OBJECTS
    var OBJName:FlxUIInputText; //TODO: make RFUI varient
    var OBJAlpha:EditorUIStepper;
    var OBJX:FlxUIInputText; //TODO: make RFUI varient
    var OBJY:FlxUIInputText; //TODO: make RFUI varient
    var OBJZ:FlxUIInputText; //TODO: make RFUI varient
    var OBJSCLX:EditorUIStepper;
    var OBJSCLY:EditorUIStepper;
    var OBJSFX:EditorUIStepper;
    var OBJSFY:EditorUIStepper;
    var OBJIMG:FlxUIInputText; //TODO: make RFUI varient
    var OBJVIS:FlxUICheckBox; //TODO: make RFUI varient
    var OBJDoubleAxisCollide:FlxUICheckBox; //TODO: make RFUI varient
	var OBJTripleAxisCollide:FlxUICheckBox; //TODO: make RFUI varient
	var OBJIndentationPixels:EditorUIStepper;
	var OBJDynamicTranparency:FlxUICheckBox; //TODO: make RFUI varient
	var OBJIsBackground:FlxUICheckBox; //TODO: make RFUI varient
	var OBJRenderOverPlayer:FlxUICheckBox; //TODO: make RFUI varient
    var OBJRenderBehindPlayer:FlxUICheckBox; //TODO: make RFUI varient
	var OBJIsAnimated:FlxUICheckBox; //TODO: make RFUI varient
	var OBJParrallaxBG:FlxUICheckBox; //TODO: make RFUI varient

    var tooltip:FlxText;
    var tooltip2:FlxText;

    //for level saving
    var INIDATA:{
        header:String,
        id:String,
        chapter:String,
        bounds:String,
        camlock:Bool,
        camfollow:String,
        lerp:Float,
        beat:Bool,
        bpm:Float
    } = {
        header: '',
        id: '',
        chapter: '',
        bounds: '',
        camlock: false,
        camfollow: '',
        lerp: 0,
        beat: false,
        bpm: 0
    };

    public function new(x:Int, y:Int, width:Int, height:Int, zoom:Float, uiType:String = 'level'){
        super(x, y, width, height, zoom);
        UI = new FlxSpriteGroup(x, y);
        UI.camera = this;
        bgColor = 0x00000000;
        createEditorUI(uiType);

        tpe = uiType;

        backButton = new EditorUIButton(1200, 0, ()->{FlxG.switchState(()->new debug.ChooseEditor());}, {
            width: 80,
            height: 20,
            text: 'Back',
            textBaseColor: FlxColor.WHITE,
            alpha: 0.25,
            baseColor: FlxColor.WHITE,
            hoverColor: FlxColor.WHITE,
            clickColor: FlxColor.WHITE
        });
        UI.add(backButton);
    }
    public function createEditorUI(uiType:String):Void{
        // Create the UI elements based on the uiType
        switch (uiType) {
            case 'Level':
                var text:FlxText = new FlxText(0, 0, 200, "Level Editor", 24, true);
                UI.add(text);

                var metaData:FlxSpriteGroup = new FlxSpriteGroup();
                    saveMetadata = new EditorUIButton(0, 155, ()->{createLevelINI(INIDATA);}, { //TODO: warning box if you dont save a level and try to leave.
                        width: 100,
                        height: 25,
                        text: 'save',
                        textBaseColor: FlxColor.WHITE,
                        alpha: 0.5,
                        baseColor: FlxColor.BLACK,
                        hoverColor: FlxColor.CYAN,
                        clickColor: FlxColor.RED
                    });
                    metaData.add(saveMetadata);
                
                    //checkboxes
                    isBeatstate = new FlxUICheckBox(0, 50, null, null, 'BeatState', 75, null, ()->{trace('a0: ${isBeatstate.checked}');});
                    CameraLocked = new FlxUICheckBox(100, 50, null, null, 'Camera Locked', 100, null, ()->{trace('a1: ${CameraLocked.checked}');});
                    metaData.add(isBeatstate);
                    metaData.add(CameraLocked);

                    CameraFollowStyle = new EditorUIDropdownMenu(380, 0, {
                        width: 120,
                        height: 20,
                        Options: [
                            'LOCKON',
                            'PLATFORMER',
                            'TOPDOWN',
                            'TOPDOWN_TIGHT',
                            'SCREEN_BY_SCREEN',
                            'NO_DEAD_ZONE'
                        ]
                    });
                    metaData.add(CameraFollowStyle);
                    CameraFollowStyle.functions = [
                        ()->{CameraFollowStyle.setSelectedLabel('LOCKON');},
                        ()->{CameraFollowStyle.setSelectedLabel('PLATFORMER');},
                        ()->{CameraFollowStyle.setSelectedLabel('TOPDOWN');},
                        ()->{CameraFollowStyle.setSelectedLabel('TOPDOWN_TIGHT');},
                        ()->{CameraFollowStyle.setSelectedLabel('SCREEN_BY_SCREEN');},
                        ()->{CameraFollowStyle.setSelectedLabel('NO_DEAD_ZONE');}
                    ];

                    bpmslider = new EditorUISlider(0, 0, {
                        width: 380,
                        labelText: 'Beats Per Minute',
                        thickness: 5,
                        min: 0,
                        max: 400
                    });
                    ////(this, 'bpm', 0, 0, 1, 400, 150, 15, 5, FlxColor.WHITE, FlxColor.BLACK);
                    ////bpmslider.nameLabel.text = 'Beats Per Minute';
                    metaData.add(bpmslider);

                    levelBounds = new FlxUIInputText(0, 70, 120, '[1920, 1080]', 16, FlxColor.BLACK, FlxColor.WHITE, true);
                    metaData.add(levelBounds);

                    levelID = new FlxUIInputText(0, 95, 120, 'Cryo0', 16, FlxColor.BLACK, FlxColor.WHITE, true);
                    metaData.add(levelID);

                    chapterID = new FlxUIInputText(0, 120, 120, 'CryoBays', 8, FlxColor.BLACK, FlxColor.WHITE, true);
                    metaData.add(chapterID);

                    cameraLerpSpeed = new EditorUIStepper(0, 135, {
                        textboxwidth: 120,
                        textboxheight: 19.8,
                        min: 0,
                        max: 999999,
                        stepSize: 1,
                        decimals: 0,
                    });
                    cameraLerpSpeed.scrollFactor.set();
                    metaData.add(cameraLerpSpeed);

                    //TODO: make a custom font for the tool buttons.
                    //TODO: make tool buttons
                    //TODO: implement functionality.

                    //tooltips. because we need those.
                    var blackbox:FlxSprite = new FlxSprite(120, 70).makeGraphic(380, 120, FlxColor.BLACK);
                    blackbox.alpha = 0.5;
                    metaData.add(blackbox);

                    tooltip = new FlxText(120, 70, 380, '', 8, true);
                    metaData.add(tooltip);

                objects = new FlxSpriteGroup();
                    createObject = new EditorUIButton(400, 155, ()->{addObject();}, { //TODO: warning box if you dont save a level and try to leave.
                        width: 100,
                        height: 25,
                        text: 'Create',
                        textBaseColor: FlxColor.WHITE,
                        alpha: 0.5,
                        baseColor: FlxColor.BLACK,
                        hoverColor: FlxColor.CYAN,
                        clickColor: FlxColor.RED
                    });
                    OBJName = new FlxUIInputText(0, 0, 100, '', 8);
                    OBJAlpha = new EditorUIStepper(0, 14, {
                        textboxwidth: 100,
                        textboxheight: 20,
                        min: 0,
                        max: 1,
                        stepSize: 0.001,
                        decimals: 3,
                        startingValue: 1
                    });
                    OBJX = new FlxUIInputText(350, 0, 50, '0', 8); //TODO: make RFUI varient
                    OBJY = new FlxUIInputText(400, 0, 50, '0', 8); //TODO: make RFUI varient
                    OBJZ = new FlxUIInputText(450, 0, 50, '0', 8); //TODO: make RFUI varient
                    OBJSCLX = new EditorUIStepper(350, 14, {
                        textboxwidth: 75,
                        textboxheight: 20,
                        min: 0.1,
                        max: 9999,
                        stepSize: 0.1,
                        decimals: 2,
                        startingValue: 1
                    });
                    OBJSCLY = new EditorUIStepper(425, 14, {
                        textboxwidth: 75,
                        textboxheight: 20,
                        min: 0.1,
                        max: 9999,
                        stepSize: 0.1,
                        decimals: 2,
                        startingValue: 1
                    });
                    OBJSFX = new EditorUIStepper(350, 34, {
                        textboxwidth: 75,
                        textboxheight: 20,
                        min: 0,
                        max: 9999,
                        stepSize: 1,
                        decimals: 0,
                        startingValue: 1
                    });
                    OBJSFY = new EditorUIStepper(425, 34, {
                        textboxwidth: 75,
                        textboxheight: 20,
                        min: 0,
                        max: 9999,
                        stepSize: 1,
                        decimals: 0,
                        startingValue: 1
                    });
                    OBJIMG = new FlxUIInputText(100, 0, 250, '', 8); //TODO: make RFUI varient
                    OBJVIS = new FlxUICheckBox(0, 54, null, null, 'Visible', 100, null, ()->{}); //TODO: make RFUI varient
                    OBJDoubleAxisCollide = new FlxUICheckBox(100, 14, null, null, 'Double Axis Collision', 100, null, ()->{}); //TODO: make RFUI varient
                    OBJTripleAxisCollide = new FlxUICheckBox(100, 34, null, null, 'Triple Axis Collision', 100, null, ()->{}); //TODO: make RFUI varient
                    OBJIndentationPixels = new EditorUIStepper(0, 34, {
                        textboxwidth: 100,
                        textboxheight: 20,
                        min: 0,
                        max: 100,
                        stepSize: 1,
                        decimals: 0,
                        startingValue: 0
                    });
                    OBJDynamicTranparency = new FlxUICheckBox(0, 74, null, null, 'Dynamic Transparency', 100, null, ()->{}); //TODO: make RFUI varient
                    OBJIsBackground = new FlxUICheckBox(0, 94, null, null, 'Background', 100, null, ()->{}); //TODO: make RFUI varient
                    OBJRenderOverPlayer = new FlxUICheckBox(200, 14, null, null, 'Elevated Rendering', 100, null, ()->{}); //TODO: make RFUI varient
                    OBJRenderBehindPlayer = new FlxUICheckBox(200, 34, null, null, 'Below Rendering', 100, null, ()->{}); //TODO: make RFUI varient
                    OBJIsAnimated = new FlxUICheckBox(0, 114, null, null, 'Animated', 100, null, ()->{}); //TODO: make RFUI varient
                    OBJParrallaxBG = new FlxUICheckBox(0, 134, null, null, 'Parrallax', 100, null, ()->{}); //TODO: make RFUI varient



                    tooltip2 = new FlxText(200, 155, 200, 'TEST', 8, true);

                    objects.add(tooltip2);

                    objects.add(OBJName);
                    objects.add(OBJIMG);
                    objects.add(OBJAlpha);
                    objects.add(OBJX);
                    objects.add(OBJY);
                    objects.add(OBJZ);
                    objects.add(OBJSCLX);
                    objects.add(OBJSCLY);
                    objects.add(OBJSFX);
                    objects.add(OBJSFY);
                    objects.add(OBJIndentationPixels);
                    objects.add(OBJDoubleAxisCollide);
                    objects.add(OBJTripleAxisCollide);
                    objects.add(OBJRenderOverPlayer);
                    objects.add(OBJRenderBehindPlayer);
                    objects.add(OBJVIS);
                    OBJVIS.checked = true;
                    objects.add(OBJDynamicTranparency);
                    objects.add(OBJIsBackground);
                    objects.add(OBJIsAnimated);
                    objects.add(OBJParrallaxBG);

                    objects.add(createObject);

                    ObjectsList = new EditorUIList(0, 200, {
                        width: 400,
                        height: 500,
                        textP: {
                            fieldwidth: 100,
                            text: 'Objects',
                            size: 16,
                        }
                    });
                    objects.add(ObjectsList);

                var items:FlxSpriteGroup = new FlxSpriteGroup();
                var doors:FlxSpriteGroup = new FlxSpriteGroup();

                var enemies:FlxSpriteGroup = new FlxSpriteGroup();
                    var TBATEXT:FlxText = new FlxText(0, 0, enemies.width, 'TO BE IMPLEMENTED', 24, true);
                    enemies.add(TBATEXT);

                var triggers:FlxSpriteGroup = new FlxSpriteGroup();
                    var TBATEXT:FlxText = new FlxText(0, 0, enemies.width, 'TO BE IMPLEMENTED', 24, true);
                    triggers.add(TBATEXT);

                var interactables:FlxSpriteGroup = new FlxSpriteGroup();
                    var TBATEXT:FlxText = new FlxText(0, 0, enemies.width, 'TO BE IMPLEMENTED', 24, true);
                    interactables.add(TBATEXT);

                box = new EditorUITABBOX(null, 0, 100, 500, 180, ['Meta', 'Obj', 'Itm', 'Npc', 'Tri', 'Int', 'door'], [metaData, objects, items, enemies, triggers, interactables, doors]);
                UI.add(box);
            case 'Item':
                var text:FlxText = new FlxText(0, 0, 200, "Item Editor", 24, true);
                UI.add(text);

                var item:FlxSprite = new FlxSprite(1000, 500);
                item.screenCenter(XY);
                UI.add(item);

                //CREATE YOUR GROUPS OF ITEMS UP HERE SO THEY CAN BE LOADED INTO THE UI PROPERLY.

                var savebutton:FlxButton = new FlxButton(1120, 0, "save", ()->{generateItemFile();});
                UI.add(savebutton);

                var Graphics:FlxSpriteGroup = new FlxSpriteGroup();
                    //scale input
                    var txt01:FlxText = new FlxText(40, 150, 35, 'Scale:', 8, true);
                    Graphics.add(txt01);
                    var scaleInput:FlxInputText = new FlxInputText(75, 150, 20, '1, 1', 8, FlxColor.BLACK, FlxColor.WHITE, true); //TODO: make this work.
                    Graphics.add(scaleInput);
                    scaleInput.onEnter.add(function(txt:String){
                        item.scale.set(Std.parseFloat(scaleInput.text.split(',')[0]) * 10, Std.parseFloat(scaleInput.text.split(',')[1]) * 10);
                        item.updateHitbox();
                        item.screenCenter(XY);
                    });

                    item.scale.set(Std.parseFloat(scaleInput.text.split(',')[0]) * 10, Std.parseFloat(scaleInput.text.split(',')[1]) * 10); //auto do it once because of yes.
                    item.updateHitbox();
                    item.screenCenter(XY);

                    //graphic loading.
                    var txt02:FlxText = new FlxText(0, 150, 55, 'Graphic', 8, true);
                    Graphics.add(txt02);



                    GraphicInput = new FlxInputText(0, 165, 500, 'game/levelAssets/battery', 8, FlxColor.BLACK, FlxColor.WHITE, true);
                    Graphics.add(GraphicInput);

                    graphicnotexist = new FlxText(95, 150, 350, '');
                    graphicnotexist.color = FlxColor.RED;
                    Graphics.add(graphicnotexist);
                    graphicnotexist.visible = false;

                    GraphicInput.onEnter.add(function(txt:String){
                        if(item != null && item.exists){
                            if(FileSystem.exists('assets/' + GraphicInput.text + '.png'))
                                item.loadGraphic('assets/' + GraphicInput.text + '.png');
                            else{
                                graphicnotexist.alpha = 1;
                                graphicnotexist.visible = true;
                                if(!tmr.active){
                                    tmr.start(2, function(tmr:FlxTimer){
                                        tmr.start(1); //dont touch. for the visibility calculations.
                                        FlxTween.tween(graphicnotexist, {alpha: 0}, 1, { 
                                            ease: FlxEase.circInOut,
                                            onComplete: function(twn:FlxTween){
                                                graphicnotexist.visible = false;
                                            }
                                        });
                                    });
                                }else{
                                    tmr.reset(2);
                                }
                            }
                        }
                    });

                    if(item != null && item.exists){ //also run once because of yes.
                        item.loadGraphic('assets/' + GraphicInput.text + '.png'); //TODO: make this acutally choose the item graphic, because APPARENTLY the item doesnt.
                    }

                    //placeholder for animation shtuff
                    var text:FlxText = new FlxText(0, Graphics.height / 24, 500, 'ANIMATION SETTINGS\nCOMING SOON', 24, true);
                    text.alignment = CENTER;
                    Graphics.add(text);
                
                var Behavior:FlxSpriteGroup = new FlxSpriteGroup();
                    //return condition
                    hasReturnCondition = new FlxUICheckBox(0, 0, null, null, 'Has return condition', 150, null, ()->{
                        trace('item has a return condition!');
                    });
                    Behavior.add(hasReturnCondition);

                    returnCondition = new FlxInputText(0, 20, 200, 'ps.Player.suit != null;', 8, FlxColor.BLACK, FlxColor.WHITE, true);
                    Behavior.add(returnCondition);

                    hasStatusMessage = new FlxUICheckBox(0, 40, null, null, 'Has Status Message', 150, null, ()->{
                        trace('item has a status message!');
                    });
                    Behavior.add(hasStatusMessage);

                    StatusMessage = new FlxInputText(0, 60, 200, '[ITEM] aquired!', 8, FlxColor.BLACK, FlxColor.WHITE, true);
                    Behavior.add(StatusMessage);

                    onComplete = new FlxInputText(200, 0, 280, 'ps.Player.Health += 25;
wait(parent._STATMSGWAITTIME, () -> {
    ps.Hud.StatMSGContainer.CreateStatusMessage(\'Health Restored By [CHANGABLE VALUE]%!\',
parent._STATMSGTWEENTIME,
parent._STATMSGWAITTIME,
parent._STATMSGFINISHYPOS);
});', 8, FlxColor.BLACK, FlxColor.WHITE, true);
                    Behavior.add(onComplete);

                    isWeapon = new FlxUICheckBox(0, 80, null, null, 'is Weapon?', 150, null, ()->{
                        trace('item is a weapon!');
                    });
                    Behavior.add(isWeapon);
                    itemName = new FlxInputText(0, 100, 200, 'SuitBattery', 8, FlxColor.BLACK, FlxColor.WHITE, true);
                    Behavior.add(itemName);


                //create the ui box.
                box = new EditorUITABBOX({tabsAlign: 180}, 0, 0, 500, 180, ["Graphics", "Behavior"], [Graphics, Behavior]);
                box.screenCenter(X);
                UI.add(box);

                var PREVIEWBG:FlxSprite = new FlxSprite(box.x + 500, 0).makeGraphic(230, 400, FlxColor.GRAY);
                UI.add(PREVIEWBG);
                filePreview = new FlxText(box.x + 500, 0, 230, '', 8, true);
                filePreview.color = FlxColor.BLACK;
                UI.add(filePreview);
            default:
                // Handle unknown uiType
        }
    }
    override public function update(elapsed:Float){
        super.update(elapsed);
        //ITEM EDITOR
        if(graphicnotexist != null){
            graphicnotexist.text = 'GRAPHIC: \"assets/' + GraphicInput.text + '.png\" DOES NOT EXIST!';
            if(!tmr.active){
                graphicnotexist.visible = false;
            }
        }
        if(hasReturnCondition != null && returnCondition != null){
            returnCondition.visible = hasReturnCondition.checked;
        }
        if(hasStatusMessage != null && StatusMessage != null){
            StatusMessage.visible = hasStatusMessage.checked;
        }
        if(filePreview != null){// THE FILE PREVIEW LOOKS SO BAD :sob:
            filePreview.text = 'class ${itemName.text} extends ${if(!isWeapon.checked) 'BaseItem' else 'BaseWeapon'} {
public function new(parent:Item) {
super(parent);${if(hasStatusMessage.checked) '\nstatusMessage = \"${StatusMessage.text}\"' else ''}
onPickup = () -> {${onComplete.text}};
}${if(hasReturnCondition.checked)
'override function get_returnCondition():Bool
return ${returnCondition.text}' else ''
}
}
';
        }

        //LEVEL EDITOR
        if(tooltip != null && box.currentActiveTab == 'Meta'){
            //INI GENERATION.
            INIDATA = {
                header: '[Level]',
                id: levelID.text,
                chapter: chapterID.text,
                bounds: levelBounds.text,
                camlock: CameraLocked.checked,
                camfollow: CameraFollowStyle.selectedLabel,
                lerp: cameraLerpSpeed.value,
                beat: isBeatstate.checked,
                bpm: bpmslider.value
            };
            //INI GENERATION.

            @:privateAccess if(FlxG.mouse.overlaps(CameraFollowStyle.text_field)){
                tooltip.text = 'Camera Follow Style';
            }else if(FlxG.mouse.overlaps(bpmslider)){
                tooltip.text = 'Beats Per Minute\nUsed in stages with the checkbox \"Beatstate\" to control how fast the camera bops\nWhy a slider? because It\'s funny.';
            }else if(FlxG.mouse.overlaps(isBeatstate)){
                tooltip.text = 'Is Beat State\nIs the current level a beat state\nLAMENS TERMS: does camera bop on beat of song';
            }else if(FlxG.mouse.overlaps(CameraLocked)){
                tooltip.text = 'Is camera locked\nSelf explanitory';
            }else if(FlxG.mouse.overlaps(levelBounds)){
                tooltip.text = 'Level Boundries\nSelf explanitory';
            }else if(FlxG.mouse.overlaps(levelID)){
                tooltip.text = 'Level Name\nSelf explanitory';
            }else if(FlxG.mouse.overlaps(chapterID)){
                tooltip.text = 'Chapter ID\nthe chapter this level takes place in';
            }else if(FlxG.mouse.overlaps(cameraLerpSpeed)){
                tooltip.text = 'Camera Lerp Speed\nself explanitory';
            }else{
                tooltip.text = '';
            }
        }
        if(tooltip2 != null && box.currentActiveTab == 'Obj'){
            if(FlxG.mouse.overlaps(createObject)){
                tooltip2.text = 'Create a new object';
            }else if(FlxG.mouse.overlaps(OBJName)){
                tooltip2.text = 'Object name (Internal)';
            }else if(FlxG.mouse.overlaps(OBJAlpha)){
                tooltip2.text = 'Object Alpha';
            }else if(FlxG.mouse.overlaps(OBJX)){
                tooltip2.text = 'Object X pos';
            }else if(FlxG.mouse.overlaps(OBJY)){
                tooltip2.text = 'Object Y pos';
            }else if(FlxG.mouse.overlaps(OBJZ)){
                tooltip2.text = 'Object Z pos';
            }else if(FlxG.mouse.overlaps(OBJIMG)){
                tooltip2.text = 'Object (full) Image Path';
            }else if(FlxG.mouse.overlaps(OBJSCLX)){
                tooltip2.text = 'Object Scale X';
            }else if(FlxG.mouse.overlaps(OBJSCLY)){
                tooltip2.text = 'Object Scale Y';
            }else if(FlxG.mouse.overlaps(OBJSFX)){
                tooltip2.text = 'Object Scrollfactor X';
            }else if(FlxG.mouse.overlaps(OBJSFY)){
                tooltip2.text = 'Object Scrollfactor Y';
            }else if(FlxG.mouse.overlaps(OBJIndentationPixels)){
                tooltip2.text = 'Object Indentation Pixels\npixels betweel sprite and collision';
            }else if(FlxG.mouse.overlaps(OBJDynamicTranparency)){
                tooltip2.text = 'Object Dynamic Transparency\n!!NONFUNCTIONAL!!';
            }else if(FlxG.mouse.overlaps(OBJIsBackground)){
                tooltip2.text = 'Object is background sprite';
            }else if(FlxG.mouse.overlaps(OBJRenderOverPlayer)){
                tooltip2.text = 'Object Renders Over Player';
            }else if(FlxG.mouse.overlaps(OBJRenderBehindPlayer)){
                tooltip2.text = 'Object Renders Under Player';
            }else if(FlxG.mouse.overlaps(OBJIsAnimated)){
                tooltip2.text = 'Object has animation';
            }else if(FlxG.mouse.overlaps(OBJParrallaxBG)){
                tooltip2.text = 'Object is a parrallax sprite';
            }else if(FlxG.mouse.overlaps(OBJVIS)){
                tooltip2.text = 'Object is visible';
            }else if(FlxG.mouse.overlaps(OBJDoubleAxisCollide)){
                tooltip2.text = 'Object collides on two axis';
            }else if(FlxG.mouse.overlaps(OBJTripleAxisCollide)){
                tooltip2.text = 'Object collides on three axis';
            }else{
                tooltip2.text = '';
            }
        }
    }

    
    public function addObject(){
        var fakejsondata:String = '{
"Data":[
    {
        "XYZ": [${Std.parseFloat(OBJX.text)}, ${Std.parseFloat(OBJY.text)}, ${Std.parseFloat(OBJZ.text)}],
        "Visible": ${OBJVIS.checked},
        "Scale": [${OBJSCLX.value}, ${OBJSCLY.value}],
        "Scrollfactor": [${OBJSFX.value}, ${OBJSFY.value}]
        "alpha": ${OBJAlpha.value}
    }
]
}';
        var jsonfaked = TJSON.parse(fakejsondata);

        ObjectsList.addObjectToList(new ListObject(0, 20, new FlxSprite(0, 0).loadGraphic(OBJIMG.text), OBJName.text, "", jsonfaked.Data[0]), 
        {
            Name: OBJName.text,
            Alpha: OBJAlpha.value,
            X: Std.parseFloat(OBJX.text),
            Y: Std.parseFloat(OBJY.text),
            Z: Std.parseFloat(OBJZ.text),
            ScaleX: OBJSCLX.value,
            ScaleY: OBJSCLY.value,
            SFX: OBJSFX.value,
            SFY: OBJSFY.value,
            IMG: OBJIMG.text,
            VIS: OBJVIS.checked,
            DoubleAxisCollide: OBJDoubleAxisCollide.checked,
            TripleAxisCollide: OBJTripleAxisCollide.checked,
            IndentationPixels: Std.int(OBJIndentationPixels.value),
            DynamicTranparency: OBJDynamicTranparency.checked,
            IsBackground: OBJIsBackground.checked,
            RenderOverPlayer: OBJRenderOverPlayer.checked,
            RenderBehindPlayer: OBJRenderBehindPlayer.checked,
            IsAnimated: OBJIsAnimated.checked,
            ParrallaxBG: OBJParrallaxBG.checked
        });

        //reset all the inputs for object creation down here
        OBJName.text = '';
        OBJAlpha.value = 1;
        OBJX.text = '0';
        OBJY.text = '0';
        OBJZ.text = '0';
        OBJSCLX.value = 1;
        OBJSCLY.value = 1;
        OBJSFX.value = 1;
        OBJSFY.value = 1;
        OBJIMG.text = '';
        OBJVIS.checked = true;
        OBJDoubleAxisCollide.checked = false;
        OBJTripleAxisCollide.checked = false;
        OBJIndentationPixels.value = 0;
        OBJDynamicTranparency.checked = false;
        OBJIsBackground.checked = false;
        OBJRenderOverPlayer.checked = false;
        OBJRenderBehindPlayer.checked = false;
        OBJIsAnimated.checked = false;
        OBJParrallaxBG.checked = false;
    }

    public function generateItemFile(){ //TODO: implement

    }

    public function loadLevelData(){ //TODO: implement

    }

    public function createLevelINI(dat:{header:String, id:String, chapter:String, bounds:String, camlock:Bool, camfollow:String, lerp:Float, beat:Bool, bpm:Float}){
        var fr:FileReference = new FileReference();
        trace(dat);
        var splitbounds:Bool;

        if(dat.bounds.toString().startsWith('[') && dat.bounds.toString().endsWith(']'))
            splitbounds = true;
        else
            splitbounds = false;

        var filedata:String = '${dat.header}
LevelId="${dat.id}"
Chapter="${dat.chapter}"
Boundries="${splitbounds ? dat.bounds.toString().substr(1, dat.bounds.length - 2) : dat.bounds.toString()}"
CameraLocked="${dat.camlock}"
CameraFollowStyle="${dat.camfollow}"
CameraFollowLerp="${dat.lerp}"
isBeatState="${dat.beat}"
beatstateframetime="${dat.bpm}"
';
        trace(filedata);
        fr.save(filedata, 'level.ini');
    }
    
}