package debug;

#if debug
	import objects.game.controllables.Player;
	import objects.RFPhysTriAxisSprite;
	import flixel.system.debug.watch.Tracker.TrackerProfile;
	import flixel.input.keyboard.FlxKey;

	/**
		# allows debug keys for quick and easy debugging!
		## this is a **DEBUG** feature, do not use it in release mode!
		### oh wait i forgot that it wont work if outside of debug mode-
		###### why am i even typing this????
	**/
	class DEBUG {

		public var pressed:Array<Bool> = [false, false];
		public var numberKeys:Array<Array<FlxKey>> = [
			[ONE], // no, numpad keys will do their own things solar
			[TWO],
			[THREE],
			[FOUR],
			[FIVE],
			[SIX],
			[SEVEN],
			[EIGHT],
			[NINE]
		];
		public var keyResponses:Array<() -> Void> = [
			// toggle hitboxes drawing.
			() -> {
				FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
			},
			() -> {
				trace(FlxG.save.data);
			},
			() -> {},
			() -> {},
			() -> {},
			() -> {},
			() -> {},
			() -> {},
			() -> {}
		];

		public function new()
			return;

		public function update(elapsed:Float) {
			for (keyID in 0...numberKeys.length) {
				pressed[keyID] = FlxG.keys.anyJustPressed(numberKeys[keyID]);
				if (pressed[keyID])
					keyResponses[keyID]();
			}

			FlxG.watch.addQuick('weaponInventory', Playstate.instance.Player.weaponInventory.toString());
			FlxG.watch.addQuick('Player X', Playstate.instance.Player.x);
			FlxG.watch.addQuick('Player Y', Playstate.instance.Player.y);
		}

		public function createCustomPlayerTracker(){
			FlxG.debugger.addTrackerProfile(new TrackerProfile(Player,
				["curPhysProperties", "curMovementDir", "canMove", "CurWeaponChoice", "curWeaponTypeIndex", "GotSuitFirstTime", "gunData", "isMoving",
				"stamina", "Health", "displayHealth", "useDisplayHealthAsRealHealth", "oxygen", "battery", "maxStamina", "maxHealth", "maxOxygen", "maxBattery", "AimerPOSx", 
				"AimerPOSy", "AimerPOSz", "CurRoom", "Transitioning", "doubleAxisColliding", "tripleAxisColliding"],
			[RFPhysTriAxisSprite]));
			FlxG.debugger.track(Playstate.instance.Player);
		}
	}
#end