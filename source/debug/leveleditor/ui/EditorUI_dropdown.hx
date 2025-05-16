package debug.leveleditor.ui;

import flixel.tweens.FlxEase;
import debug.leveleditor.ui.EditorUI_button.EditorUIButton;

typedef DropDownParameters = {
    width:Float,
    height:Float,
    Options:Array<String>
} 

//TODO: both fix and finish this custom dropdown.

class EditorUIDropdownMenu extends FlxSpriteGroup{
    private var text_field:FlxText;
    private var button:EditorUIButton;
    private var sqaure:EditorUIButton;
    private var texts:Array<EditorUIButton> = [];
    private var textBG2:FlxSprite;
    public function new(x:Float, y:Float, p:DropDownParameters){
        super(x,y);

        var textBG1:FlxSprite = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.BLACK);
        textBG1.setGraphicSize(p.width, p.height);
        textBG1.updateHitbox();
        add(textBG1);
        textBG2 = new FlxSprite(1, 1).makeGraphic(1, 1, FlxColor.WHITE);
        textBG2.setGraphicSize(p.width - 2, p.height - 2);
        textBG2.updateHitbox();
        add(textBG2);

        for(i in 0...p.Options.length){
            var txt:EditorUIButton = new EditorUIButton(0, 0, ()->{}, {
                width: p.width,
                height: 20,
                text: p.Options[i],
                textSize: 9,
                textBaseColor: FlxColor.BLACK,
                textHoverColor: FlxColor.WHITE,
                baseColor: FlxColor.WHITE,
                hoverColor: FlxColor.BLUE,
                clickColor: FlxColor.BLACK
            }); //p.width, p.Options[i], 9, true);
            add(txt);
            texts.push(txt); //so we can access the texts later;
        }
        texts[0].active = false;
        texts[0].visible = false;
        texts[0].alpha = 0;

        text_field = new FlxText(1, 4, p.width, p.Options[1], 8, true);
        text_field.color = FlxColor.BLACK;
        add(text_field);

        for(j in 0...texts.length){
            texts[j].y = text_field.y;
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


    }

    var down:Bool = false;
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
                FlxTween.tween(texts[i], {y: textBG2.y + 10 * (i * 2)}, 0.2, {ease: FlxEase.cubeOut});
            }
        }
    }
}