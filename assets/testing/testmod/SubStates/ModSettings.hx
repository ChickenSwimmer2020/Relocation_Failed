import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxG;

class Settings extends FlxSubState {
    public function new() {
        super();
        
        var bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF); // Black background
        add(bg);
        
        trace("External substate loaded!");
    }
}