package debug.leveleditor.ui;

import debug.leveleditor.ui.EditorUI_button;

typedef StepperParams = {
    textboxwidth:Float,
    textboxheight:Float,
    min:Float,
    max:Float,
    stepSize:Float,
    decimals:Int,
    ?startingValue:Float
}

class EditorUIStepper extends FlxSpriteGroup{
    public var value(default, set):Float = 0;
    public var step:Float = 0;
    private var text_field:FlxText;
    private var metes:StepperParams;
    public function new(x:Float, y:Float, Params:StepperParams){
        super(x, y);

        metes = Params;
        step = Params.stepSize;

        var textBG1:FlxSprite = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.BLACK);
        textBG1.setGraphicSize(Params.textboxwidth, Params.textboxheight);
        textBG1.updateHitbox();
        add(textBG1);
        var textBG2:FlxSprite = new FlxSprite(1, 1).makeGraphic(1, 1, FlxColor.WHITE);
        textBG2.setGraphicSize(Params.textboxwidth - 2, Params.textboxheight - 2);
        textBG2.updateHitbox();
        add(textBG2);
        text_field = new FlxText(1, 0, Params.textboxwidth, '0', 16, true);
        text_field.color = FlxColor.BLACK;
        add(text_field);

        if(Params.startingValue != null)
            set_value(Params.startingValue);

        var plus:EditorUIButton = new EditorUIButton(textBG1.width - Params.textboxwidth/4, 0, ()->{ ugh('+'); }, {
            width: Params.textboxwidth/4,
            height: Params.textboxheight,
            text: '+',
            textBaseColor: FlxColor.WHITE,
            alpha: 0.25,
            baseColor: FlxColor.BLACK,
            hoverColor: FlxColor.BLACK,
            clickColor: FlxColor.BLACK
        });
        add(plus);
        var minus:EditorUIButton = new EditorUIButton(textBG1.width - Params.textboxwidth/4 - plus.width, 0, ()->{ ugh('-'); }, {
            width: Params.textboxwidth/4,
            height: Params.textboxheight,
            text: '-',
            textBaseColor: FlxColor.WHITE,
            alpha: 0.25,
            baseColor: FlxColor.BLACK,
            hoverColor: FlxColor.BLACK,
            clickColor: FlxColor.BLACK
        });
        add(minus);
    }

    private function ugh(form:String){
        if(form == '+')
            set_value(value + step);
        else if(form == '-')
            set_value(value - step);
    }

    private function set_value(f:Float):Float
        {
            value = f;
            if (value < metes.min)
            {
                value = metes.min;
            }
            if (value > metes.max)
            {
                value = metes.max;
            }
            
            if (text_field != null)
            {
                var displayValue:Float = value;
                text_field.text = decimalize(displayValue, metes.decimals);
            }
            return value;
        }
    private inline function decimalize(f:Float, digits:Int):String
        {
            var tens:Float = Math.pow(10, digits);
            return Std.string(Math.round(f * tens) / tens);
        }
}