package substates;

class PauseMenuSubState extends FlxSubState {
    var icon:FlxText;
    
    var button_backToGame:FlxButton;
    var button_mainMenu:FlxButton;

    override function create() {
        icon = new FlxText(0, 0, 0, "R", 8, true);
        icon.setFormat(null, 48, FlxColor.BLUE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        icon.updateHitbox();
        icon.scrollFactor.set(0,0);
        add(icon);

        button_backToGame = new FlxButton(0, icon.y + 75, "Back", () -> {close();});
        add(button_backToGame);

        button_backToGame = new FlxButton(0, button_backToGame.y + 20, "Main Menu", () -> {close(); FlxG.switchState(new menu.MainMenu());});
        add(button_backToGame);
    }
}