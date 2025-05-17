package debug.leveleditor.ui;

import flixel.tweens.FlxEase;
import debug.leveleditor.ui.EditorUI_button.EditorUIButton;

typedef DropDownParameters = {
    width:Float,
    height:Float,
    Options:Array<String>,
} 

class EditorUIDropdownMenu extends FlxSpriteGroup{
    private var text_field:FlxText;
    private var button:EditorUIButton;
    private var sqaure:EditorUIButton;
    private var texts:Array<DropdownItem> = [];
    private var funcs:Array<Void->Void> = [];
    private var textBG2:FlxSprite;

    @:isVar public var selectedLabel(get, set):String;   
    public var down:Bool = true;
    public var functions:Array<Void->Void> = [];

    public function new(x:Float, y:Float, p:DropDownParameters){
        super(x,y);

        for(i in 0...p.Options.length){
            var txt:DropdownItem = new DropdownItem(0, 0, p.width, p.Options[i], functions[i]);
            add(txt);
            texts.push(txt); //so we can access the texts later;
        }

        var textBG1:FlxSprite = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.BLACK);
        textBG1.setGraphicSize(p.width, p.height);
        textBG1.updateHitbox();
        add(textBG1);
        textBG2 = new FlxSprite(1, 1).makeGraphic(1, 1, FlxColor.WHITE);
        textBG2.setGraphicSize(p.width - 2, p.height - 2);
        textBG2.updateHitbox();
        add(textBG2);

        text_field = new FlxText(1, 4, p.width, p.Options[0], 8, true);
        text_field.color = FlxColor.BLACK;
        add(text_field);

        for(j in 0...texts.length){
            texts[j].y = textBG2.y;
        }

        sqaure = new EditorUIButton(textBG1.width - p.width/4, 0, ()->{ dropdown(); }, {
            width: p.width/4,
            height: p.height,
            text: '^',
            textSize: 12,
            textBaseColor: FlxColor.WHITE,
            alpha: 0.25,
            baseColor: FlxColor.BLACK,
            hoverColor: FlxColor.BLACK,
            clickColor: FlxColor.BLACK
        });
        add(sqaure);

        sqaure.txt.angle = 180;
    }

    override public function update(elapsed:Float){
        super.update(elapsed);

        for(i in 0...texts.length){
            var itm = cast texts[i];
            itm.setdown(down);
            texts[i].func = functions[i];
        }
    }

    
    private function dropdown(){
        down = !down;
        if(down){ //go up
            FlxTween.tween(sqaure.txt, {angle: 180}, 0.2, {ease: FlxEase.cubeOut});
            for(i in 0...texts.length){
                FlxTween.tween(texts[i], {y: textBG2.y}, 0.2, {ease: FlxEase.cubeOut});
            }
        }else if(!down){ //go down
            FlxTween.tween(sqaure.txt, {angle: 0}, 0.2, {ease: FlxEase.cubeOut});
            for(i in 0...texts.length){
                if(i == 0){
                    FlxTween.tween(texts[i], {y: textBG2.y + 20}, 0.2, {ease: FlxEase.cubeOut});
                }else{
                    FlxTween.tween(texts[i], {y: textBG2.y + 20 + 10 * (i * 2)}, 0.2, {ease: FlxEase.cubeOut});
                }
            }
        }
    }

    public function setSelectedLabel(cur:String){
        selectedLabel = cur;
        dropdown(); //reset to go up
        text_field.text = selectedLabel;
        trace('selected label: ' + selectedLabel);
        trace('inputted label: ' + cur);
    }

    function set_selectedLabel(s:String):String{
        selectedLabel = s;
        return selectedLabel;
    }
    function get_selectedLabel():String{
        return selectedLabel;
    }
}

class DropdownItem extends FlxSpriteGroup{
    private var bg:FlxSprite;
    private var label:FlxText;
    public var func:Void->Void;
    private var down:Bool = false;
    public function new(x:Float, y:Float, width:Float, Label:String, onClick:Void->Void){
        super(x, y);

        bg = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.WHITE);
        bg.setGraphicSize(width, 20);
        bg.updateHitbox();
        add(bg);

        label = new FlxText(0, 0, width, '${Label}', 8, false);
        add(label);

        func = onClick;
    }

    override public function update(elapsed:Float){
        super.update(elapsed);

        if(!down){
            if(!bg.active){
                bg.active = true;
                bg.visible = true;
            }
            if(!label.active){
                label.active = true;
                label.visible = true;
            }

            if(FlxG.mouse.overlaps(bg) || FlxG.mouse.overlaps(label)){
                bg.color = FlxColor.BLUE;
                label.color = FlxColor.WHITE;
                if(FlxG.mouse.justPressed){
                    func();
                }
            }else{
                bg.color = FlxColor.WHITE;
                label.color = FlxColor.BLACK;
            }
        }else{
            wait(0.2, ()->{
                if(bg.active){
                    bg.active = false;
                    bg.visible = false;
                }
                if(label.active){
                    label.active = false;
                    label.visible = false;
                }
            });
        }
    }

    function setdown(b:Bool){
        down = b;
    }
}