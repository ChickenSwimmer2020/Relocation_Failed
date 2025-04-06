package debug.leveleditor.ui;

import flixel.tweens.FlxEase;
import sys.FileSystem;
import sys.io.File;
import flixel.text.FlxInputText;
import debug.leveleditor.ui.EditorUI_tabsBox.EditorUITABBOX;

using StringTools;

class EditorUI extends FlxCamera{
    public var UI:FlxSpriteGroup;
    public var tpe:String = '';
    var backButton:FlxButton;
    var box:EditorUITABBOX;
    var graphicnotexist:FlxText;
    var GraphicInput:FlxInputText;
    var tmr:FlxTimer = new FlxTimer(); //central.
    public function new(x:Int, y:Int, width:Int, height:Int, zoom:Float, uiType:String = 'level'){
        super(x, y, width, height, zoom);
        UI = new FlxSpriteGroup(x, y);
        UI.camera = this;
        bgColor = 0x00000000;
        createEditorUI(uiType);

        tpe = uiType;

        backButton = new FlxButton(1200, 0, "Back", function() {
            FlxG.switchState(()->new debug.ChooseEditor());
        });
        UI.add(backButton);
    }
    public function createEditorUI(uiType:String):Void{
        // Create the UI elements based on the uiType
        switch (uiType) {
            case 'Level':
                var text:FlxText = new FlxText(0, 0, 200, "Level Editor", 24, true);
                UI.add(text);
            case 'Item':
                var text:FlxText = new FlxText(0, 0, 200, "Item Editor", 24, true);
                UI.add(text);

                var item:FlxSprite = new FlxSprite(1000, 500);
                item.screenCenter(XY);
                UI.add(item);

                //CREATE YOUR GROUPS OF ITEMS UP HERE SO THEY CAN BE LOADED INTO THE UI PROPERLY.

                var savebutton:FlxButton = new FlxButton(1120, 0, "save", ()->{});
                UI.add(savebutton);

                var Graphics:FlxSpriteGroup = new FlxSpriteGroup();
                    //scale input
                    var txt01:FlxText = new FlxText(40, 150, 35, 'Scale:', 8, true);
                    Graphics.add(txt01);
                    var scaleInput:FlxInputText = new FlxInputText(75, 150, 20, '1, 1', 8, FlxColor.BLACK, FlxColor.WHITE, true);
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
                        item.loadGraphic('assets/' + GraphicInput.text + '.png');
                    }

                    //placeholder for animation shtuff
                    var text:FlxText = new FlxText(0, Graphics.height / 24, 500, 'ANIMATION SETTINGS\nCOMING SOON', 24, true);
                    text.alignment = CENTER;
                    Graphics.add(text);
                
                var Behavior:FlxSpriteGroup = new FlxSpriteGroup();
                    

                //create the ui box.
                box = new EditorUITABBOX({tabsAlign: 180}, 0, 0, 500, 180, ["Graphics", "Behavior"], [Graphics, Behavior]);
                box.screenCenter(X);
                UI.add(box);
            default:
                // Handle unknown uiType
        }
    }
    override public function update(elapsed:Float){
        super.update(elapsed);
        if(graphicnotexist != null){
            graphicnotexist.text = 'GRAPHIC: \"assets/' + GraphicInput.text + '.png\" DOES NOT EXIST!';
            if(!tmr.active){
                graphicnotexist.visible = false;
            }
        }
    }
    
    public function generateItemFile(){

    }
}