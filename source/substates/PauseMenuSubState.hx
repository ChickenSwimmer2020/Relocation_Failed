package substates;

import menu.SettingsSubState;
import backend.save.PlayerSaveStateUtil;

class PauseMenuSubState extends FlxSubState {
	var pauseCAM:FlxCamera;
	var icon:FlxSprite;

	var button_backToGame:FlxButton;
	var button_saveGame:FlxButton;
	var button_mainMenu:FlxButton;
	var button_Settings:FlxButton;

	public static var PauseJustClosed:Bool = false;

	override function create() {
		pauseCAM = new FlxCamera();
		FlxG.cameras.add(pauseCAM, false);
		pauseCAM.bgColor = 0x000000;

		icon = new FlxSprite(0, 0, 'assets/game/PauseLogo.png');
		icon.updateHitbox();
		icon.scrollFactor.set(0, 0);
		icon.cameras = [pauseCAM];
		add(icon);

		button_backToGame = new FlxButton(0, icon.y + 75, "Back", () -> {
			close();
			FlxG.sound.music.resume();
		});
		button_backToGame.camera = pauseCAM;
		add(button_backToGame);

		button_saveGame = new FlxButton(0, button_backToGame.y + 20, "Save", () -> {
			PlayerSaveStateUtil.SavePlayerSaveState();
		});
		button_saveGame.camera = pauseCAM;
		add(button_saveGame);

		button_Settings = new FlxButton(0, button_saveGame.y + 20, "Settings", () -> {
			openSubState(new SettingsSubState(this));
		});
		button_Settings.camera = pauseCAM;
		add(button_Settings);

		button_mainMenu = new FlxButton(0, button_Settings.y + 20, "Main Menu", () -> {
			close();
			FlxG.switchState(menu.MainMenu.new);
			pauseCAM.destroy();
		});
		button_mainMenu.camera = pauseCAM;
		add(button_mainMenu);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([ESCAPE])) {
			close();
			PauseJustClosed = true;
			if (FlxG.sound.music != null && !FlxG.sound.music.playing)
				FlxG.sound.music.resume();
		}
	}
}
