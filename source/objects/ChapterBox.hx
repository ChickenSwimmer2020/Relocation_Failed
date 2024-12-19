package objects;

import flixel.addons.ui.FlxUIAssets;
import openfl.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.group.FlxGroup;

class ChapterBox extends FlxSpriteGroup {

    var ClickyWickyUwU:Void->Void;
    var BG:FlxUI9SliceSprite;
    var BGInner:FlxUI9SliceSprite;
    var ChapterName:FlxText;
    var BUTT:FlxButton;

    var weHasImage:Bool = false;

    public function new(X:Float, Y:Float, IMG:FlxGraphic, Name:String, onClick:Void->Void) {
        super();
        ClickyWickyUwU = onClick;

        BG = new FlxUI9SliceSprite(X, Y, FlxUIAssets.IMG_CHROME_FLAT, new Rectangle(0, 0, 100, 140));
        BGInner = new FlxUI9SliceSprite(X, Y + 15, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(0, 0, 100, 90));
        ChapterName = new FlxText(X, Y + 3, 100, Name, 8, false);
        ChapterName.alignment = CENTER;
        BUTT = new FlxButton(X + 10, Y + 110, 'Play', ()->{ ClickyWickyUwU(); });
        add(BG);
        add(BGInner);
        add(ChapterName);
        add(BUTT);
        if(IMG != null) {
            weHasImage = true;
            var FurryPorn:FlxSprite = new FlxSprite(X, Y + 15, IMG);
            FurryPorn.setGraphicSize(100, 90);
            FurryPorn.updateHitbox();
            add(FurryPorn);
        }
    }
}