package menu;

class ClickToPlay extends FlxState {
    var clickhere:FlxSprite;
    var clicktext:FlxText;

    override public function create() {
        clickhere = new FlxSprite(0,0).makeGraphic(150,50, FlxColor.RED);
        add(clickhere);
        clicktext = new FlxText(0, 0, 0, "Click Here To Play", 12, false);
        clicktext.setFormat(null, 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, false);
        add(clicktext);
        clickhere.screenCenter(XY);
        clicktext.screenCenter(XY);
    }
    override public function update(elapsed:Float) {
        if(FlxG.mouse.overlaps(clickhere) && FlxG.mouse.justPressed) {
            FlxG.switchState(new MainMenu());
        }
    }
}