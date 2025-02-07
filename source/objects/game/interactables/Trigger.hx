package objects.game.interactables;

class Trigger extends FlxSprite {
    public var Function:String;
    public var Width:Float;
    public var Height:Float;
    public var inEditor:Bool;

    public function new(X:Float, Y:Float, Width:Float, Height:Float, ?IsVisible:Bool = false, Func:String, ?EditorMode:Bool = false) {
        super(X, Y);
        if(IsVisible != null && IsVisible == true) {
            this.loadGraphic(Assets.image('Trigger'));
        }
        this.width = Width;
        this.height = Height;
        Function = Func;
        inEditor = EditorMode;
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(!inEditor)   {
            if(Playstate.instance.Player != null) {
                if(Playstate.instance.Player.overlaps(this)) {
                    if(Function != null)
                        trace(Function);
                }
            }
        }
    }
}