package backend;

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
     * @param TXT what text should be displayed?
     * @param TXTS what size should the font be?
     * @param BGANIM OPTIONAL. allows for addition of animation to the static graphic
     */
    public function new(X:Float, Y:Float, BG:String, PRS:Void->Void, SCL:Float, ?BGANIM:Bool)
        {
   
            Pressed = PRS;

            super(X, Y, BG);

            StaticBG.loadGraphic(BG, BGANIM);
            StaticBG.setPosition(X,Y);
            StaticBG.scale.set(SCL, SCL);
            StaticBG.updateHitbox();
        }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        CheckHover();
        if(FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed)
            {
                Pressed();
            }
    }
    inline function CheckHover()
        {
            if(Hover)
                {
                    trace('Hovering');
                    this.color = 0xff159cea;
                }
            else
                {
                    trace('Not hovering');
                    this.color = 0xffffffff;
                }
        }
}