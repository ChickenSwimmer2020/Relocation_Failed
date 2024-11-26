package substates;

class PauseMenuSubState extends FlxSubState {
    var pauseCAM:FlxCamera;
    var icon:FlxText;
    
    var button_backToGame:FlxButton;
    var button_mainMenu:FlxButton;

    override function create() {
        pauseCAM = new FlxCamera();
        FlxG.cameras.add(pauseCAM, false);
        pauseCAM.bgColor = 0x000000;

        icon = new FlxText(0, 0, 0, "R", 8, true);
        icon.setFormat(null, 48, FlxColor.BLUE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        icon.updateHitbox();
        icon.scrollFactor.set(0,0);
        icon.cameras = [pauseCAM];
        add(icon);

        button_backToGame = new FlxButton(0, icon.y + 75, "Back", () -> {close();});
        button_backToGame.cameras = [pauseCAM];
        add(button_backToGame);

        button_mainMenu = new FlxButton(0, button_backToGame.y + 20, "Main Menu", () -> {close(); FlxG.switchState(new menu.MainMenu()); pauseCAM.destroy();});
        button_mainMenu.cameras = [pauseCAM];
        add(button_mainMenu);
    }
}