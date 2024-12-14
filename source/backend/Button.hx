package backend;

import flixel.input.touch.FlxTouchManager;
import flixel.input.touch.FlxTouch;

class Button extends FlxSprite
{
    private var StaticBG:FlxSprite = new FlxSprite(0, 0);
    private var Pressed:Void->Void;
    public var Hover:Bool = false;
    /**
     * [Custom Button Creation Function, quickly allows for scaling and stuff. now customizable!]
     * @param X X position
     * @param Y Y position
     * @param BG static graphic
     * @param PRS what to do when pressed FORMAT: [ () -> {Your Code;} ]
     * @param SCL scale of everything
     * @param BGANIM OPTIONAL. allows for addition of animation to the static graphic
     */
    public function new(X:Float, Y:Float, BG:FlxGraphic, PRS:Void->Void, SCL:Float, ?BGANIM:Bool)
        {
            super(X, Y, BG);
            Pressed = PRS;
            StaticBG.loadGraphic(BG, BGANIM);
            StaticBG.setPosition(X,Y);
            StaticBG.scale.set(SCL, SCL);
            StaticBG.updateHitbox();
        }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        CheckHover();
        #if !mobile
        if(FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed)
            Pressed();
        #else
        for (touch in FlxG.touches.justReleased()) {
            if (touch.overlaps(this) && touch.justPressed)
                Pressed();
        }
        #end
    }

    function CheckHover()
        {
            if(Hover)
                this.color = 0xff159cea;
            else
                this.color = 0xffffffff;
        }
}

class Txt extends FlxText{

    public function new(TXT:String, FNTSIZE:Int, X:Float, Y:Float, ?ALIGN:FlxTextAlign = CENTER) {
        super(X, Y, 0, TXT, FNTSIZE, false);
        this.alignment = ALIGN;
        this.updateHitbox();
        this.text = TXT;
        this.antialiasing = false;
    }
}