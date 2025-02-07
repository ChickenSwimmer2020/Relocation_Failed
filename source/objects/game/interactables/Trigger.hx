package objects.game.interactables;

class Trigger extends FlxSpriteGroup {
    public var Function:String;
    public var Width:Float;
    public var Height:Float;
    public var inEditor:Bool;
    public var TriggerGraphic:FlxSprite;
    public var FireOnce:Bool;

    public function new(X:Float, Y:Float, Width:Float, Height:Float, ?IsVisible:Bool = false, Func:String, ?oneShot:Bool = false, ?EditorMode:Bool = false) {
        super(0, 0);
        TriggerGraphic = new FlxSprite(X, Y).loadGraphic(Assets.image('Trigger'));
        if(IsVisible != null && IsVisible == true) {
            TriggerGraphic.alpha = 1;
        }else{
            TriggerGraphic.alpha = 0;
        }
        TriggerGraphic.width = Width;
        TriggerGraphic.height = Height;
        TriggerGraphic.setGraphicSize(Width,Height);
        TriggerGraphic.updateHitbox();
        Function = Func;
        inEditor = EditorMode;
        FireOnce = oneShot;
        add(TriggerGraphic);
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(!inEditor)   {
            for(TriggerGraphic in this){
                var trigger:FlxSprite = cast TriggerGraphic;
                if(Function != null){
                    if(Playstate.instance.Player.overlaps(trigger)) {
                        trace(Function);
                        if(FireOnce)
                            trigger.kill();
                    }
                }
            }
        }
    }
}