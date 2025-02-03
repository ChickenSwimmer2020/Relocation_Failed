package objects.game.hud;

import flixel.tweens.FlxEase;

//status messages on the hud! very cool like some games do.
class StatusMessageHolder extends FlxSpriteGroup {
    var BGBox:FlxSprite;
    var msgGroup:FlxSpriteGroup;
    var MSGGROUP_INDEX:Int;
    public var currentYOffset:Float = 0;
    public var doingCoolIntro:Bool = false;
    public function new(X:Float, Y:Float, createInDebugMode:Bool = false) {
        super(0, 0);
        msgGroup = new FlxSpriteGroup();
        BGBox = new FlxSprite(X, Y);
        BGBox.makeGraphic(200, 100, FlxColor.BLACK);
        if(createInDebugMode) {
            BGBox.alpha = 0.75;
        }else{
            BGBox.alpha = 0.25;
        }
        add(BGBox); //* box can hold a total of 9 messages, find a way to delete the first one for every new one created?
        add(msgGroup);
        #if debug
            trace('StatusMessageGroup area created successfully.');
        #end
    }
    public function CreateStatusMessage(Text:String, TweenTime:Float, waitTime:Float, FinishYPosition:Float, ?vars:Array<Dynamic>) {
        var StatMSG:StatusMessage = new StatusMessage(Playstate.instance.Hud.StatMSGContainer.BGBox.x, Playstate.instance.Hud.StatMSGContainer.BGBox.y + currentYOffset, Text, TweenTime, waitTime, FinishYPosition);
        msgGroup.add(StatMSG);
        currentYOffset += 10;
        if(StatMSG.exists) {
            #if debug
                trace('StatusMessage created!\n' + StatMSG);
            #end
        }
    }
    public function clearStatusMessages() {
        msgGroup.clear();
        currentYOffset = 0; // Reset the offset
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (msgGroup.countLiving() == 0) {
            currentYOffset = 0;
            clearStatusMessages();
        }
        if (msgGroup.countLiving() > 9) {
            msgGroup.group.members[0].kill();
            currentYOffset -= 10;
        }
        if(doingCoolIntro) {
            BGBox.updateHitbox();
        }
    }

    function DoCoolIntro() {
        doingCoolIntro = true;
        BGBox.scale.set(0.1,0.1);
        FlxTween.tween(BGBox, {"scale.x": 1}, 1, { ease: FlxEase.cubeOut });
        wait(1, ()->{ FlxTween.tween(BGBox, {"scale.y": 1}, 1, { ease: FlxEase.cubeOut }); });
        wait(2, ()->{
            CreateStatusMessage('running init file...', 1, 1, 10);
            wait(0.5, ()->{
                CreateStatusMessage('initilizing...', 1, 1, 10);
                wait(0.5, ()->{
                    CreateStatusMessage('insert startup dialouge here', 1, 1, 10);
                });
            });
            wait(5, ()->{
                CreateStatusMessage('System Online!', 1, 1, 10);
                doingCoolIntro = false;  
            });
        });
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
                this.destroy();
            }});
        });
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}