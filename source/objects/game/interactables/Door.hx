package objects.game.interactables;

import flixel.group.FlxSpriteGroup;

class Door extends FlxSpriteGroup {

    var SPR:FlxSprite;

    var WaitTime:Float = 0;
    var Level:String;
    var PlayerPos:Array<Float>;
    var hasAnim:Bool;

    var animPlayed:Bool = false;
    var PlayingOpenAnim:Bool = false;
    var interactPrompt:FlxSprite;

    public function new(X:Float, Y:Float, Graphic:String, ?isAnimated:Bool = false, ?Frame:Array<Int> = null, openAnimLength:Float = 0, LevelToLoad:String, PlayerPosition:Array<Float> = null) {
        super();
        if(Frame == null) Frame = [0, 0]; //null handling
        if(PlayerPosition == null) PlayerPosition = [0, 0];
        SPR = new FlxSprite(X,Y).loadGraphic(Assets.image(Graphic), isAnimated, Frame[0], Frame[1]);
        add(SPR);
        WaitTime = openAnimLength;
        Level = LevelToLoad;
        PlayerPos = PlayerPosition;
        if(isAnimated) {
            SPR.animation.add('idle', [0], 24, false, false, false);
            SPR.animation.add('open', [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], 24, false, false, false);
            hasAnim = true;
        }
        interactPrompt = new FlxSprite(SPR.x + 15.5, SPR.y);
        interactPrompt.loadGraphic(Assets.image('interactprompt'), false);
        add(interactPrompt);
        interactPrompt.visible = false;
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        //SPR.updateHitbox();
        //interactPrompt.updateHitbox();
        //this.updateHitbox();
        if(!PlayingOpenAnim)
            SPR.animation.play('idle');

        if(Playstate.instance.Player.overlaps(this)) {
            interactPrompt.visible = true;
            if(FlxG.keys.anyJustPressed([E])) {
                Playstate.instance.Player.Transitioning = true;
                Playstate.instance.Player.drag.set(9999999999999, 9999999999999); //instantly stop the player so that we dont get issues with the aimer disconnecting from the body like a worm or something.
                interactPrompt.visible = false;
                
                if(hasAnim) {
                    if(!animPlayed) {
                        SPR.animation.play('open', true); //make sure the anim only plays once.
                        animPlayed = true;
                        PlayingOpenAnim = true;
                    }
                }
                wait(WaitTime, ()->{
                    FlxG.switchState(new Playstate(Level, PlayerPos));
                });
            }
        }else{
            interactPrompt.visible = false;
        }
    }
}

