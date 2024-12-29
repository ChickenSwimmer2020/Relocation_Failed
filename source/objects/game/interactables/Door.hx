package objects.game.interactables;

class Door extends FlxSprite {

    var WaitTime:Float = 0;
    var Level:String;
    var PlayerPos:Array<Float>;
    var hasAnim:Bool;

    var animPlayed:Bool = false;
    var PlayingOpenAnim:Bool = false;

    public function new(X:Float, Y:Float, Graphic:String, ?isAnimated:Bool = false, ?Frame:Array<Int> = null, openAnimLength:Float = 0, LevelToLoad:String, PlayerPosition:Array<Float> = null) {
        super(X, Y);
        if(Frame == null) Frame = [0, 0]; //null handling
        if(PlayerPosition == null) PlayerPosition = [0, 0];
        loadGraphic(Assets.image(Graphic), isAnimated, Frame[0], Frame[1]);
        WaitTime = openAnimLength;
        Level = LevelToLoad;
        PlayerPos = PlayerPosition;
        if(isAnimated) {
            this.animation.add('idle', [0], 24, false, false, false);
            this.animation.add('open', [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17], 24, false, false, false);
            hasAnim = true;
        }
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(!PlayingOpenAnim)
            this.animation.play('idle');

        if(Playstate.instance.Player.overlaps(this)) {
            Playstate.instance.Player.Transitioning = true;
            Playstate.instance.Player.drag.set(9999999999999, 9999999999999); //instantly stop the player so that we dont get issues with the aimer disconnecting from the body like a worm or something.
            
            if(hasAnim) {
                if(!animPlayed) {
                    this.animation.play('open', true); //make sure the anim only plays once.
                    animPlayed = true;
                    PlayingOpenAnim = true;
                }
            }
            wait(WaitTime, ()->{
                FlxG.switchState(new Playstate(Level, PlayerPos));
            });
        }
    }
}

