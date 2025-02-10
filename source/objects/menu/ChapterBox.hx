package objects.menu;

import flixel.math.FlxPoint;
import flixel.ui.FlxButton.FlxButtonState;
import flixel.addons.ui.FlxUIAssets;
import openfl.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;

using flixel.util.FlxSpriteUtil;

class ChapterBox extends FlxSpriteGroup {

    var whenClicked:Void->Void;
    var BG:FlxUI9SliceSprite;
    var BGInner:FlxUI9SliceSprite;
    var ChapterName:FlxText;
    var Button:FlxButton;

    var weHasImage:Bool = false;
    var Lock:FlxUI9SliceSprite;
    var dalock:FlxSprite;
    var isLocked:Bool;
    var created:Bool = false;

    public function new(X:Float, Y:Float, IMG:FlxGraphic, Name:String, onClick:Void->Void, locked:Bool) {
        super();
        whenClicked = onClick;
        isLocked = locked;

        Lock = new FlxUI9SliceSprite(X, Y, FlxUIAssets.IMG_CHROME_LIGHT, new Rectangle(0, 0, 100, 140));

        BG = new FlxUI9SliceSprite(X, Y, FlxUIAssets.IMG_CHROME_FLAT, new Rectangle(0, 0, 100, 140));
        BGInner = new FlxUI9SliceSprite(X, Y + 15, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(0, 0, 100, 90));
        ChapterName = new FlxText(X, Y + 3, 100, Name, 8, false);
        ChapterName.alignment = CENTER;
        Button = new FlxButton(X + 10, Y + 110, 'Play', ()->{ whenClicked(); });
        add(BG);
        add(BGInner);
        add(ChapterName);
        add(Button);
        if(IMG != null) {
            weHasImage = true;
            var ChapterIMG:FlxSprite = new FlxSprite(X, Y + 15, IMG);
            ChapterIMG.setGraphicSize(900, 90); //well, i wish i knew this function existed. much better than setscale because i can define exact dimensions.
            ChapterIMG.updateHitbox();
            ChapterIMG.scrollFactor.set(0,0);
            add(ChapterIMG);
        }
        if(locked) {
            add(Lock);
            wait(1.2, ()->{ Lock.alpha = 0.8; });
        }
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(isLocked) {
            Button.status = FlxButtonState.DISABLED;
            if(!created) {
                dalock = new FlxSprite(0, 0, Assets.image('ChapterLock'));
                add(dalock);
                created = true;
            }
            if(dalock != null)
                dalock.setPosition(Lock.width/2, Lock.getGraphicMidpoint().y - dalock.height/2);
        }
    }
}
