package substates;

import backend.save.PlayerSaveStateUtil;

class PauseMenuSubState extends FlxSubState {
    var pauseCAM:FlxCamera;
    var icon:FlxText;
    
    var button_backToGame:FlxButton;
    var button_saveGame:FlxButton;
    var button_mainMenu:FlxButton;

    public static var PauseJustClosed:Bool = false;

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
        button_backToGame.camera = pauseCAM;
        add(button_backToGame);

        button_saveGame = new FlxButton(0, button_backToGame.y + 20, "Save", () -> { PlayerSaveStateUtil.SavePlayerSaveState(); });
        button_saveGame.camera = pauseCAM;
        add(button_saveGame);

        button_mainMenu = new FlxButton(0, button_saveGame.y + 20, "Main Menu", () -> {close(); FlxG.switchState(new menu.MainMenu()); pauseCAM.destroy();});
        button_mainMenu.camera = pauseCAM;
        add(button_mainMenu);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        #if !mobile
        if(FlxG.keys.anyJustPressed([ESCAPE])) {
            close();
            PauseJustClosed = true;
        }
        #end
    }
}
