package backend;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

/**
 * Data Stored within the save file itself.
 */
typedef PlayerStatus = {
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

class PlayerState { // this is for player save instancing, for creating the second save file for game progress (the encrypted save file for actual game progress compared to the other one for preferences)
	// the main difference between RelocationFailedSAVEDATA.sol and RFSVE.json is that the .sol handles internal preference, EG: max frames, individual volumes, stuff like that.

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
	 * Load the player save state from the json
	 * ---
	 * @since RF_DEV_0.3.5
	 */
	public static function LoadPlayerSaveState() {
		var SaveDir:String;
		var SaveName:String = 'RFSVE.json';
		var ExecPath:String = Sys.programPath();
		var GameFolder:String = ExecPath.substring(0, ExecPath.length - 10);
		if (FlxG.save.data.SaveDirectory != null)
			SaveDir = FlxG.save.data.SaveDirectory + SaveName; // for custom save directories
		else
			SaveDir = Path.join([GameFolder, SaveName]);
		if (!FileSystem.exists('$SaveDir')) { // dynamically check if the file already exists, so we dont accidently overwrite it.
			trace('no data to load.');
		} else {
			var jsonContent = File.getContent('$GameFolder/$SaveName');
			var Data = Json.parse(jsonContent);

			var playerstatus:PlayerStatus = {
				curLvl: Data.Stats.CurRoom,
				curHealth: Data.Stats.health,
				curStamina: Data.Stats.stamina,
				playerX: Data.Stats.PosX,
				playerY: Data.Stats.PosY,
				piscap: Data.Stats.PistolAmmoCap,
				pisremain: Data.Stats.PistolAmmoRemaining,
				shtcap: Data.Stats.ShotgunAmmoCap,
				shtremain: Data.Stats.ShotgunAmmoRemaining,
				rifcap: Data.Stats.RifleAmmoCap,
				rifremain: Data.Stats.RifleAmmoRemaining,
				smgcap: Data.Stats.SMGAmmoCap,
				smgremain: Data.Stats.SMGAmmoRemaining,
			}

			loadPlayerState(playerstatus);
		}
	}

	static function loadPlayerState(Stats:PlayerStatus) {
		FlxG.switchState(new Playstate(Stats.curLvl, Stats));
	}

	/**
	 * Save the player save state to the json
	 * ---
	 * @since RF_DEV_0.3.5
	 */
	public static function SavePlayerSaveState() {
		var SaveDir:String;
		var SaveName:String = 'RFSVE.json';
		var ExecPath:String = Sys.programPath();
		var GameFolder:String = ExecPath.substring(0, ExecPath.length - 10);

		if (FlxG.save.data.SaveDirectory != null)
			SaveDir = FlxG.save.data.SaveDirectory + SaveName; // for custom save directories
		else
			SaveDir = Path.join([GameFolder, SaveName]);
		if (!FileSystem.exists('$SaveDir')) { // dynamically check if the file already exists, so we dont accidently overwrite it.
			File.write(SaveDir, false);
		} else { // SAVEJSONBEGINSHERE
			File.saveContent('$SaveDir', '{
    "Stats":{
        "health": ${Playstate.instance.Player.health},
        "stamina": ${Playstate.instance.Player.stamina},

        "hasSuit": $HasSuit,
        "PosX": ${Playstate.instance.Player.x},
        "PosY": ${Playstate.instance.Player.y},
        "CurRoom": \"${Playstate.instance.Player.CurRoom}\",

        "PistolAmmoCap": ${Playstate.instance.Player.PistolAmmoCap},
        "PistolAmmoRemaining": ${Playstate.instance.Player.PistolAmmoRemaining},

        "RifleAmmoCap": ${Playstate.instance.Player.RifleAmmoCap},
        "RifleAmmoRemaining": ${Playstate.instance.Player.RifleAmmoRemaining},

        "ShotgunAmmoCap": ${Playstate.instance.Player.ShotgunAmmoCap},
        "ShotgunAmmoRemaining": ${Playstate.instance.Player.ShotgunAmmoRemaining},

        "SMGAmmoCap": ${Playstate.instance.Player.SMGAmmoCap},
        "SMGAmmoRemaining": ${Playstate.instance.Player.SMGAmmoRemaining}
    }
}'); // ENDOFSAVEJSON
		}
	}
}
