package backend.save;

import objects.game.controllables.Player;
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
	var curHealth:Int; // last Health value during save.
	var curStamina:Int; // last stamina value during save.
	var curBattery:Int; // last battery value during save.
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
	 * - Weapons should be disabled
	 * - HUD should be disabled
	 *   - Health will regen quickly, shown by a red vingget on the sides of the screen,
	 *   - stamina will be tracked by a heavy breathing sound that gets louder the lower your stamina
	 * @since RF_DEV_0.3.5
	 */
	public static var HasSuit:Bool = false;

	/**
	 * Load the player save state from the rsf
	 * ---
	 * @since RF_DEV_0.3.5
	 */
	public static function LoadPlayerSaveState(slot:Int, ?ForceLevel:String = '') {
		var SaveName:String = 'SAVE.rfs'; // rfsave file
		var ExecPath:String = Sys.programPath();
		var GameFolder:String = ExecPath.substring(0, ExecPath.length - 10);
		var GameFolderNormalized:String = Path.normalize(Path.removeTrailingSlashes(GameFolder));
		var SaveDir:String = '$GameFolderNormalized/saves/sv${slot}/$SaveName';
		if (!FileSystem.exists(SaveDir)) {
			trace('no data to load.');
		} else {
			var playerstatus:SaveState = new SaveState();
			playerstatus.loadSaveFieldsFromString(File.getContent(SaveDir));
			loadPlayerState(playerstatus, slot, ForceLevel);
		}
	}

	/**
	 * Actually load the player save state from the rsf
	 * ---
	 * @since RF_DEV_0.3.5
	 */
	static function loadPlayerState(Stats:SaveState, slot:Int, ?OverrideLevel:String = '') {
		FlxG.switchState(() -> new Playstate((OverrideLevel != '') ? OverrideLevel : Stats.cur_lvl, null, Stats,
			slot)); //* we have to use the ()-> method here because of varible passthrough. annoying.
	}

	public static function getSaveArray():Array<Save> {
		var ps:Playstate = Playstate.instance;
		var plr:Player = ps.Player;
		var data = plr.gunData;
		return [
			{name: 'save_ver', type: '', value: '${Application.current.meta.get('version')}'}, // so you didnt just use the current game version, why?
			{name: 'cur_lvl', type: '', value: ps._LEVEL},
			{name: 'cur_health', type: 0.0, value: plr.Health},
			{name: 'cur_stamina', type: 0.0, value: plr.stamina},
			{name: 'cur_battery', type: 0.0, value: plr.battery},
			{name: 'player_x', type: 0.0, value: plr.x},
			{name: 'player_y', type: 0.0, value: plr.y},
			{name: 'player_z', type: 0.0, value: plr.z},
			{name: 'piscap', type: 0, value: data.PistolAmmoCap},
			{name: 'pisremain', type: 0, value: data.PistolAmmoRemaining},
			{name: 'shtcap', type: 0, value: data.ShotgunAmmoCap},
			{name: 'shtremain', type: 0, value: data.ShotgunAmmoRemaining},
			{name: 'rifcap', type: 0, value: data.RifleAmmoCap},
			{name: 'rifremain', type: 0, value: data.RifleAmmoRemaining},
			{name: 'smgcap', type: 0, value: data.SMGAmmoCap},
			{name: 'smgremain', type: 0, value: data.SMGAmmoRemaining},
			{name: 'haspistol', type: false, value: data.hasPistol},
			{name: 'hasrifle', type: false, value: data.hasRifle},
			{name: 'hasshotgun', type: false, value: data.hasShotgun},
			{name: 'hassmg', type: false, value: data.hasSMG},
			{name: 'hassuit', type: false, value: data.hasSuit},
		];
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
		SaveDir = '$GameFolderNormalized/saves/sv${Playstate.instance.saveSlot}/';
		FileSystem.createDirectory(SaveDir);
		File.saveContent('$SaveDir/$SaveName', SaveUtil.createSave(getSaveArray()));
	}
}
