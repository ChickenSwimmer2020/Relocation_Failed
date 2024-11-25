package substates;

class PausemenuSubState extends FlxSubState {
    var icon:FlxText;
    
    var button_backToGame:FlxButton;
    var button_mainMenu:FlxButton;

    override function create() {
        icon = new FlxText(0, 0, 0, "R", 8, true);
        icon.setFormat(null, 48, FlxColor.BLUE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        add(icon);

        button_backToGame = new FlxButton(0, icon.y + 75, "Back", function() {close();});
        add(button_backToGame);

        button_backToGame = new FlxButton(0, button_backToGame.y + 20, "Main Menu", function() {close(); FlxG.switchState(new menu.MainMenu());});
        add(button_backToGame);
    }
}