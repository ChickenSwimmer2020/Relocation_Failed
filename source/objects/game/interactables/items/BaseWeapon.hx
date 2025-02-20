package objects.game.interactables.items;

import objects.game.controllables.Player;

enum WeaponType {
	PISTOL;
	RIFLE;
	SHOTGUN;
	SMG;
	BASE;
}

class BaseWeapon extends BaseItem {
	public var weaponType:WeaponType = BASE;
	public var ammoRemaining(default, set):Int = 0;
	public var ammoCap:Int = 0;

	function set_ammoRemaining(val:Int):Int {
		ammoRemaining = val;
		if (ammoRemaining > ammoCap)
			ammoRemaining = ammoCap;
		return val;
	}

	public function onSelected(plr:Player) {
		plr.CurWeaponChoice = NULL;
		plr.gun.changeTexture(0, 0, '', false, 0, 0);
	}

	override function get_returnCondition():Bool {
		var mapFull:Bool = true;
		for (weapon in ps.Player.weaponInventory) {
			if (weapon == null) {
				mapFull = false;
				break;
			}
		}
		return ps.Player.suit != null && !mapFull;
	}
}
