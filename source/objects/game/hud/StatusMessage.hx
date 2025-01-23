package objects.game.hud;

import flixel.tweens.FlxEase;

//status messages on the hud! very cool like some games do.
class StatusMessageHolder extends FlxSpriteGroup {
    var BGBox:FlxSprite;
    public function new(X:Float, Y:Float, createInDebugMode:Bool = false) {
        super(0, 0);
        BGBox = new FlxSprite(X, Y);
        BGBox.makeGraphic(200, 100, FlxColor.BLACK);
        if(createInDebugMode) {
            BGBox.alpha = 0.75;
        }else{
            BGBox.alpha = 0.25;
        }
        add(BGBox);
        #if debug
            trace('StatusMessageGroup area created successfully.');
        #end
    }
    public function CreateStatusMessage(Text:String, TweenTime:Float, waitTime:Float, FinishYPosition:Float, ?vars:Array<Dynamic>) {
        var StatMSG:StatusMessage = new StatusMessage(Playstate.instance.Hud.StatMSGContainer.BGBox.x, Playstate.instance.Hud.StatMSGContainer.BGBox.y, Text, TweenTime, waitTime, FinishYPosition);
        add(StatMSG);
        if(StatMSG.exists) {
            #if debug
                trace('StatusMessage created!\n' + StatMSG);
            #end
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}

class StatusMessage extends FlxText {
    public function new(X:Float, Y:Float, Text:String, TweenTime:Float, waitTime:Float, FinishYPosition:Float, ?extras:Array<Dynamic>) {
        super(X, Y, 0, Text, 8, true);
        setFormat(null, 8, FlxColor.WHITE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        this.alpha = 1;
        FinishYPosition = this.y - FinishYPosition;
        this.updateHitbox();
        wait(waitTime, () -> {
            FlxTween.tween(this, {alpha: 0, y: FinishYPosition }, TweenTime, {ease: FlxEase.sineIn, onComplete: function(Twn:FlxTween) {
                this.kill();
            }});
        });
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}