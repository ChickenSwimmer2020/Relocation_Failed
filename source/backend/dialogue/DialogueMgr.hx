package backend.dialogue;

import flixel.math.FlxMath;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup;
import loreline.*;
import loreline.Interpreter.TextTag;

class DialogueTag {
    public var closing:Bool = false;
    public var value:String = '';
    public var offset:Int = 0;
    public var ranThrough:Bool = false;

    public function new(tag:TextTag) {
        this.closing = tag.closing;
        this.value = tag.value;
        this.offset = tag.offset;
    }
}

class DialogueMgr extends FlxGroup{
    public var script:Script;
    public var bg:FlxSprite;
    public var box:FlxSprite;
    public var boxDims:{width:Int, height:Int};
    public var boxPadding:Int = 20;
    public var fontPath:String = '';
    public var typeText:DialogueTypeText;
    public var typeTextTop:DialogueTypeText;
    public var characterLeft:FlxSprite;
    public var characterRight:FlxSprite;
    public var characterCenter:FlxSprite;
    public var dialogueCam:FlxCamera;
    public var dialogueCamTop:FlxCamera;
    public var targetCamAngle:Float = 0;
    public var targetCamZoom:Float = 1;
    public var targetCamX:Float = 0;
    public var targetCamY:Float = 0;

    public function new(lorContent:String) {
        super();
        var finalLor = lorContent + '\n\nendOfLor';
        script = Loreline.parse(finalLor);
        dialogueCam = new FlxCamera();
        dialogueCam.bgColor = 0x00000000;
        dialogueCamTop = new FlxCamera();
        dialogueCamTop.bgColor = 0x00000000;
        FlxG.cameras.add(dialogueCam, false);
        FlxG.cameras.add(dialogueCamTop, false);
        camera = dialogueCam;
        bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x00000000);
        add(bg);
        boxDims = {width: FlxG.width - (boxPadding * 2), height: FlxG.height - 400 - boxPadding};
        box = new FlxSprite(boxPadding, 400).makeGraphic(boxDims.width, boxDims.height, 0x00000000);
        add(box);
        characterCenter = new FlxSprite(box.x + box.width/2 - 150/2, box.y - 200).makeGraphic(150, 200, 0x00000000);
        add(characterCenter);
        characterRight = new FlxSprite(box.x + box.width - 150, box.y - 200).makeGraphic(150, 200, 0x00000000);
        add(characterRight);
        characterLeft = new FlxSprite(box.x, box.y - 200).makeGraphic(150, 200, 0x00000000);
        characterLeft.flipX = true;
        add(characterLeft);
        
    }

    public var complete:Bool = false;
    public var skip:Bool = false;
    public function startDialogue() {
        try{
        Loreline.play(script,
            // on dialogue line
            (_:Interpreter, character, text, tags, done) -> {
                trace('dialogue line: ' + text);
                trace('character: ' + character);
                bg.loadGraphic(_.getCharacterField('_HEADER', 'bgAsset'));
                box.loadGraphic(_.getCharacterField('_HEADER', 'boxAsset'));
                var dialogueTags:Array<DialogueTag> = [for (tag in tags) new DialogueTag(tag)];
                typeText = new DialogueTypeText(this, dialogueTags, true, _, box.x + boxPadding * 2, box.y + boxPadding * 2, cast box.width - boxPadding / 2, text, 30);
                typeText.font = _.getCharacterField('_HEADER', 'fontPath');
                typeText.start(0.02, false, false, [], () -> {complete = true;});
                add(typeText);
                complete = false;
                skip = false;
                while(true)
                {
                    if (skip)
                    {
                        typeText.destroy();
                        done();
                        skip = false;
                        break; 
                    }
                    if (FlxG.keys.justPressed.ENTER){
                        if (!complete)
                            typeText.runThroughTags();

                        typeText.destroy();
                        done();
                        complete = false;
                        break;
                    }
                }
            },
            
            // on choice
            (_, options, callback) -> {
                for (i in 0...options.length) {
                    Sys.println((i + 1) + '. ' + options[i].text);
                }
                
                final choice:Int = 0;
                callback(choice);
            },

            // on complete
            _ -> {
                trace('e');
            });
        }catch (e) {
            trace(e.message + '\n' + e.stack);
        }
    }

    override public function update(elapsed:Float) {
        try{
        super.update(elapsed);
        dialogueCam.angle = FlxMath.lerp(dialogueCam.angle, targetCamAngle, 0.1);
        dialogueCamTop.angle = FlxMath.lerp(dialogueCamTop.angle, targetCamAngle, 0.1);
        dialogueCam.zoom = FlxMath.lerp(dialogueCam.zoom, targetCamZoom, 0.1);
        dialogueCamTop.zoom = FlxMath.lerp(dialogueCamTop.zoom, targetCamZoom, 0.1);
        dialogueCam.x = FlxMath.lerp(dialogueCam.x, targetCamX, 0.1);
        dialogueCamTop.x = FlxMath.lerp(dialogueCamTop.x, targetCamX, 0.1);
        dialogueCam.y = FlxMath.lerp(dialogueCam.y, targetCamY, 0.1);
        dialogueCamTop.y = FlxMath.lerp(dialogueCamTop.y, targetCamY, 0.1);
        }catch(e){}
    }
}