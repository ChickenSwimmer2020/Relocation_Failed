package backend.save;

import backend.macros.SaveMacro;
import backend.save.SaveUtil.Save;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

/**
 * Data Stored within the save file itself.
 */
typedef PlayerSaveStatus = {
	var curLvl:String; // last level player was on during save.
	var curHealth:Int; // last health value during save.
	var curStamina:Int; // last stamina value during save.
	var playerX:Float; // last x position during save.
	var playerY:Float; // last y position during save.
	// ammo stuffs.
	var piscap:Int; // last pistol ammo cap during save.
	var pisremain:Int; // last pistol ammo number during save.
	var shtcap:Int; // last shotgun ammo cap during save.
	var shtremain:Int; // last shotgun ammo number during save.
	var rifcap:Int; // last rifle ammo cap during save.
	var rifremain:Int; // last rifle ammo number during save.
	var smgcap:Int; // last smg ammo cap during save.
	var smgremain:Int; // last smg ammo number during save.
}

class PlayerSaveStateUtil { // this is for player save instancing, for creating the second save file for game progress (the encrypted save file for actual game progress compared to the other one for preferences)
	// the main difference between RelocationFailedSAVEDATA.sol and SAVE.json is that the .sol handles internal preference, EG: max frames, individual volumes, stuff like that.

	/**
	 * Does the player have the suit?
	 * ---
	 * without this:
	 * - Sprinting should be disabled
	 * - Weapons should be disabled
	 * - HUD should be disabled
	 *   - health will regen quickly, shown by a red vingget on the sides of the screen,
	 *   - stamina will be tracked by a heavy breathing sound that gets louder the lower your stamina
	 * @since RF_DEV_0.3.5
	 */
	public static var HasSuit:Bool = false;

	/**
	 * Load the player save state from the rsf
	 * ---
	 * @since RF_DEV_0.3.5
	 */
	public static function LoadPlayerSaveState(slot:Int) {
		var SaveDir:String;
		var SaveName:String = 'SAVE.rfs'; // rfsave file
		var ExecPath:String = Sys.programPath();
		var GameFolder:String = ExecPath.substring(0, ExecPath.length - 10);
        var GameFolderNormalized:String = Path.normalize(Path.removeTrailingSlashes(GameFolder));
		SaveDir = '$GameFolderNormalized/saves/sv${slot}/$SaveName';
		if (!FileSystem.exists(SaveDir)) {
			trace('no data to load.');
		} else {
			var playerstatus:SaveState = new SaveState();
            playerstatus.loadSaveFieldsFromString(File.getContent(SaveDir));
			loadPlayerState(playerstatus);
		}
	}

	static function loadPlayerState(Stats:SaveState) {
		FlxG.switchState(new Playstate(Stats.curLvl, Stats));
	}

	/**
	 * Save the player save state to the rsf
	 * ---
	 * @since RF_DEV_0.3.5
	 */
	public static function SavePlayerSaveState() {
		var SaveDir:String;
		var SaveName:String = 'SAVE.rfs'; // rfsave file
		var ExecPath:String = Sys.programPath();
		var GameFolder:String = ExecPath.substring(0, ExecPath.length - 10);
        var GameFolderNormalized:String = Path.normalize(Path.removeTrailingSlashes(GameFolder));

        var saveData:Array<Save> = [
            {name: 'saveVer', type: '', value: 'RF_DEV_0.3.5'},
            {name: 'curLvl', type: '', value: Playstate.instance._LEVEL},
            {name: 'curHealth', type: 0, value: Playstate.instance.Player.health},
            {name: 'curStamina', type: 0, value: Playstate.instance.Player.stamina},
            {name: 'playerX', type: 0.0, value: Playstate.instance.Player.x},
            {name: 'playerY', type: 0.0, value: Playstate.instance.Player.y},
            {name: 'piscap', type: 0, value: Playstate.instance.Player.PistolAmmoCap},
            {name: 'pisremain', type: 0, value: Playstate.instance.Player.PistolAmmoRemaining},
            {name: 'shtcap', type: 0, value: Playstate.instance.Player.ShotgunAmmoCap},
            {name: 'shtremain', type: 0, value: Playstate.instance.Player.ShotgunAmmoRemaining},
            {name: 'rifcap', type: 0, value: Playstate.instance.Player.RifleAmmoCap},
            {name: 'rifremain', type: 0, value: Playstate.instance.Player.RifleAmmoRemaining},
            {name: 'smgcap', type: 0, value: Playstate.instance.Player.SMGAmmoCap},
            {name: 'smgremain', type: 0, value: Playstate.instance.Player.SMGAmmoRemaining},
        ];

		SaveDir = '$GameFolderNormalized/saves/sv${Playstate.instance.saveSlot}/';
        FileSystem.createDirectory(SaveDir);
		File.saveContent('$SaveDir/$SaveName', SaveUtil.createSave(saveData));
	}
}