package objects.game.interactables;

class Trigger extends FlxSprite {
    public var Function:String;
    public var Width:Float;
    public var Height:Float;

    public function new(X:Float, Y:Float, Width:Float, Height:Float, ?IsVisible:Bool = false, Func:String) {
        super(X, Y);
        if(IsVisible != null && IsVisible == true) {
            this.loadGraphic(Assets.image('Trigger'));
        }
        this.width = Width;
        this.height = Height;
        Function = Func;
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(Playstate.instance.Player != null) {
            if(Playstate.instance.Player.overlaps(this)) {
                if(Function != null)
                    trace(Function);
            }
        }
    }
}