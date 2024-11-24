package menu;

class Settings extends FlxState {
    var Back:FlxButton;

    override public function create() {
        Back = new FlxButton(0, 0, "Back", function() {FlxG.switchState(new menu.MainMenu());});
        add(Back);
    }
}