package debug.leveleditor.ui;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;

typedef SliderParams = {
    labelText:String,
    width:Float,
    thickness:Float,
    min:Float,
    max:Float,
}

class EditorUISlider extends FlxSpriteGroup{
    @:isVar
    public var value(get, set):Float;

    private var meters:SliderParams;

    var line:FlxSprite; //the line
    var label:FlxText;
    var min:FlxText;
    var max:FlxText;
    var slider:FlxSprite;
    var maxvalue:FlxSprite;
    var curVal:FlxText;

    var isheld:Bool = false;

    /**
      * !!NOTE!! THE MAX VALUE WILL ALWAYS BE TWENTY LESS THAN WHAT YOU PUT IN. THIS IS A BUG. I AM TRYING TO FIX IT.
     **/
    public function new(x:Float, y:Float, params:SliderParams){
        super(x, y);
        meters = params;
        line = new FlxSprite(0, 15).makeGraphic(1, 1, FlxColor.WHITE);
        line.setGraphicSize(params.width, params.thickness);
        line.updateHitbox();
        add(line);
        min = new FlxText(0, 0, 0, '${Std.string(params.min)}', 8, true);
        add(min);
        max = new FlxText(0, 0, 0, '${Std.string(params.max-20)}', 8, true);
        max.x = line.width - max.width;
        add(max);

        slider = new FlxSprite(0, 13).makeGraphic(1, 1, FlxColor.fromString('#4a4e4e'));
        slider.setGraphicSize(8, params.thickness * 2);
        slider.updateHitbox();
        add(slider);

        maxvalue = new FlxSprite(0, 13);
        maxvalue.alpha = 0;
        add(maxvalue);

        label = new FlxText(min.fieldWidth + 10, 0, 0, '${params.labelText}', 8, true);
        add(label);

        curVal = new FlxText(label.width + 20, 0, 0, '$value', 8, true);
        add(curVal);
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
        if(FlxG.mouse.overlaps(slider)){
            if(FlxG.mouse.pressed){
                isheld = true;
                slider.x = FlxG.mouse.viewX;
                if(slider.x > meters.width){
                    slider.x = meters.width;
                }else if (slider.x < 0){
                    slider.x = 0;
                }
                
            }
        }
        if(isheld){
            slider.x = FlxG.mouse.viewX;
            if(slider.x > meters.width){
                slider.x = meters.width;
            }else if (slider.x < 0){
                slider.x = 0;
            }
        }
        if(!FlxG.mouse.pressed && isheld == true){
            isheld = false;
        }
        curVal.text = '$value';
        value = FlxMath.distanceBetween(slider, maxvalue);
    }


    function get_value():Float{
        return value;
    }
    function set_value(f:Float):Float{
        value = f;
        return value;
    }
}