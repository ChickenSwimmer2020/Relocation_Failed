package objects;

import flixel.addons.ui.FlxUIAssets;
import openfl.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.group.FlxGroup;

class ChapterBox extends FlxSpriteGroup {

    var whenClicked:Void->Void;
    var BG:FlxUI9SliceSprite;
    var BGInner:FlxUI9SliceSprite;
    var ChapterName:FlxText;
    var Button:FlxButton;

    var weHasImage:Bool = false;

    public function new(X:Float, Y:Float, IMG:FlxGraphic, Name:String, onClick:Void->Void) {
        super();
        whenClicked = onClick;

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
            ChapterIMG.setGraphicSize(100, 90);
            ChapterIMG.updateHitbox();
            add(ChapterIMG);
        }
    }
}
