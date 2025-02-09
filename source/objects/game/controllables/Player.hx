package objects.game.controllables;

import openfl.events.MouseEvent;
import flixel.effects.FlxFlicker;
import backend.Functions;
import backend.Assets;
import substates.PauseMenuSubState;
import objects.game.controllables.Gun;

typedef PhysicProperties = {
    var speed:Float;
    var drag:Float;
}

enum abstract MovementDirection(String) from String to String
{
    var up = 'up';
    var down = 'down';
    var left = 'left';
    var right = 'right';
    var none = 'idle';
}

class Player extends FlxSprite {
    public var nonSprintPhysProps:PhysicProperties = {
        speed: 300,
        drag: 1000
    };
    public var sprintPhysProps:PhysicProperties = {
        speed: 375,
        drag: 5000
    };
    public var curPhysProperties:PhysicProperties;
    public var curMovementDir:MovementDirection;

    public static var flickering:Bool = false;

    public var gun:Gun = new Gun();

    public var CurWeaponChoice:Bullet.BulletType;
    public var currentWeaponIndex:Int = 0;
    public var weapons:Array<String> = ["Pistol", "Shotgun", "Rifle", "Smg"];

    public var PistolAmmoRemaining:Int = 200;
    public var RifleAmmoRemaining:Int = 500;
    public var ShotgunAmmoRemaining:Int = 75;
    public var SMGAmmoRemaining:Int = 900;

    public var PistolAmmoCap:Int = 200; //what are general ammo caps in games?
    public var RifleAmmoCap:Int = 500;
    public var ShotgunAmmoCap:Int = 75;
    public var SMGAmmoCap:Int = 900;

    //guns and current availability storage
    public var hasSuit:Bool = false;
    public var GotSuitFirstTime:Bool = false;
    public var hasPistol:Bool = false;
    public var hasRifle:Bool = false;
    public var hasShotgun:Bool = false;
    public var hasSMG:Bool = false;

	public var isMoving:Bool = false;
    public var stamina:Float = 100; //* so we used int for all of these... why?
    public var Health:Float = 100;
    public var displayHealth:Float = 100;
    public var useDisplayHealthAsRealHealth:Bool = false; //used for the hud intro animation since we cant lower Health actually.
    public var oxygen:Float = 200;
    public var battery:Float = 500;

    public var maxStamina:Float = 100;
    public var maxHealth:Float = 100;
    public var maxOxygen:Float = 200;
    public var maxBattery:Float = 500;

	public var playstate:Playstate;
    public var colliders:Array<FlxSprite> = [];
    public var colliding:Bool = false;

    public static var AimerPOSy:Float;
    public static var AimerPOSx:Float;

    public var CurRoom:String;

    public var Transitioning:Bool = false;

	public function new(xPos:Float, yPos:Float, playstate:Playstate) {
		super(xPos, yPos);
        Health = 100;
        this.playstate = playstate;
        curPhysProperties = nonSprintPhysProps;		
        loadGraphic(Assets.image('Player_LEGS'), true, 51, 51, true);
		drag.set(curPhysProperties.drag, curPhysProperties.drag);

		animation.add("idle", [0], 30, false, false, false);

		animation.add("left", [1], 30, false, false, false);
		animation.add("right", [3], 30, false, false, false);
		animation.add("up", [2], 30, false, false, false);
		animation.add("down", [4], 30, false, false, false);

        animation.add("DIAGNOAL_upleft", [5], 30, false, false, false);
        animation.add("DIAGNOAL_upright", [6], 30, false, false, false);
        animation.add("DIAGNOAL_downright", [7], 30, false, false, false);
        animation.add("DIAGNOAL_downleft", [8], 30, false, false, false);

		animation.play('idle');
        FlxG.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        CurWeaponChoice = NULL; //prevent a crash from the hud trying to read the curweaponchoice as null
        gun.changeTexture(1, 1, 'W_pistol', false, 64, 64); //placeholder, dont want a gaphic but want at minimum for the sprite to exist to prevent null access.
        gun.theGunTexture.alpha = 0;
	}

    public function collide():Bool {
        for (obj in colliders){
            var setToTrue = false;
            if (colliding)
                setToTrue = true;
            colliding = FlxObject.separate(this, obj);
            if (setToTrue)
                colliding = true;
        }
        return colliding;
    }

    function resetPauseMenu() {
        if(PauseMenuSubState.PauseJustClosed) {
            var tmr:FlxTimer = new FlxTimer();
            tmr.start(1, function(tmr:FlxTimer) {
                PauseMenuSubState.PauseJustClosed = false;
            });
        }
    }

	function checkForPauseMenu() {
		if (FlxG.keys.anyPressed([ESCAPE]) && !PauseMenuSubState.PauseJustClosed) { //so the pause menu can be closed with the escape key and not instantly reopen
			FlxG.state.openSubState(new substates.PauseMenuSubState());
            if(FlxG.sound.music != null)
                FlxG.sound.music.pause();
        }
	}

    function forceCaps() {
        if(Playstate.instance.Player.Health > Playstate.instance.Player.maxHealth) //we dont want our Health to go above 100, this should work for now until we get a better system in
            Playstate.instance.Player.Health -= 10; //SHUT UP ABOUT BEING REMOVED SOON :sob:

        //insert the suit/armor stuff here.
        if(Playstate.instance.Player.battery > Playstate.instance.Player.maxBattery)
            Playstate.instance.Player.battery = Playstate.instance.Player.maxBattery;

        if(Playstate.instance.Player.ShotgunAmmoRemaining > Playstate.instance.Player.ShotgunAmmoCap)
            Playstate.instance.Player.ShotgunAmmoRemaining = Playstate.instance.Player.ShotgunAmmoCap;

        if(Playstate.instance.Player.RifleAmmoRemaining > Playstate.instance.Player.RifleAmmoCap)
            Playstate.instance.Player.RifleAmmoRemaining = Playstate.instance.Player.RifleAmmoCap;

        if(Playstate.instance.Player.PistolAmmoRemaining > Playstate.instance.Player.PistolAmmoCap)
            Playstate.instance.Player.PistolAmmoRemaining = Playstate.instance.Player.PistolAmmoCap;

        if(Playstate.instance.Player.battery > Playstate.instance.Player.maxBattery)
            Playstate.instance.Player.battery = Playstate.instance.Player.maxBattery;
    }

    private function onMouseWheel(event:MouseEvent):Void {
        if (event.delta > 0) {
            // Scroll up
            currentWeaponIndex = (currentWeaponIndex - 1 + weapons.length) % weapons.length;
        } else if (event.delta < 0) {
            // Scroll down
            currentWeaponIndex = (currentWeaponIndex + 1) % weapons.length;
        }

        updateWeapon();
    }

    // Update the weapon
    public function updateWeapon():Void {
        trace("Selected weapon: " + weapons[currentWeaponIndex]);
        flickering = false;
        FlxFlicker.stopFlickering(Playstate.instance.Hud.ammocounter_AMMONUMONE);
        FlxFlicker.stopFlickering(Playstate.instance.Hud.ammocounter_AMMOSLASH);
        FlxFlicker.stopFlickering(Playstate.instance.Hud.ammocounter_AMMONUMTWO);
        switch(weapons[currentWeaponIndex]) {
            case 'Pistol':
                if(hasPistol) {
                    CurWeaponChoice = PISTOLROUNDS;
                    gun.changeTexture(15, 15, 'W_pistol', false, 64, 64);
                    gun.theGunTexture.alpha = 1;
                }else{
                    trace('You do not have the pistol!');
                    gun.theGunTexture.alpha = 0;
                }
            case 'Shotgun':
                if(hasShotgun) {
                    CurWeaponChoice = SHOTGUNSHELL;
                    gun.changeTexture(15, 15, 'W_shotgun', true, 128, 64);
                    gun.theGunTexture.alpha = 1;
                }else{
                    trace('You do not have the shotgun!');
                    gun.theGunTexture.alpha = 0;
                }
            case 'Rifle':
                if(hasRifle) {
                    CurWeaponChoice = RIFLEROUNDS;
                    gun.theGunTexture.alpha = 1;
                }else{
                    trace('You do not have the rifle!');
                    gun.theGunTexture.alpha = 0;
                }
            case 'Smg':
                if(hasSMG) {
                    CurWeaponChoice = SMGROUNDS;
                    gun.theGunTexture.alpha = 1;
                }else{
                    trace('You do not have the SMG!');
                    gun.theGunTexture.alpha = 0;
                }
        }
    }

	function movement() {
		if (FlxG.keys.anyPressed([SHIFT]) && stamina > 0 && isMoving){
			curPhysProperties = sprintPhysProps;
            stamina--;
        }else{
			curPhysProperties = nonSprintPhysProps;
            if(stamina < 100 && !FlxG.keys.anyPressed([SHIFT]))
                stamina++;
        }

        if (FlxG.keys.anyPressed([LEFT, A]))
            curMovementDir = left;
        else if (FlxG.keys.anyPressed([RIGHT, D]))
            curMovementDir = right;
        else if (FlxG.keys.anyPressed([UP, W]))
            curMovementDir = up;
        else if (FlxG.keys.anyPressed([DOWN, S]))
            curMovementDir = down;
        else
            curMovementDir = none;

		animation.play(curMovementDir);
		isMoving = curMovementDir != none;
        //if (isMoving) gun.moveCallback();

        var movementDirs = [FlxG.keys.anyPressed([LEFT, A]), FlxG.keys.anyPressed([RIGHT, D]), FlxG.keys.anyPressed([UP, W]), FlxG.keys.anyPressed([DOWN, S])];
        var count = 0;
        var allOn = false;
        for (dir in movementDirs) if (dir) count++;
        if (count == 4)
            allOn = true;
        for (dirID in 0...movementDirs.length)
        {
            if (movementDirs[dirID])
                switch (dirID)
                {
                    case 0 | 1:
                        if (dirID == 0 && !movementDirs[dirID+1])
                            velocity.x = -curPhysProperties.speed;
                        else if (dirID == 1 && !movementDirs[dirID-1])
                            velocity.x = curPhysProperties.speed;
                        else
                            velocity.x = 0;

                    case 2 | 3:
                        if (dirID == 2 && !movementDirs[dirID+1])
                            velocity.y = -curPhysProperties.speed;
                        else if (dirID == 3 && !movementDirs[dirID-1])
                            velocity.y = curPhysProperties.speed;
                        else
                            velocity.y = 0;
                         
                    default:
                }
        }

        if (count < 3){
            if (movementDirs[2] && movementDirs[0]) animation.play('DIAGNOAL_upleft');
            if (movementDirs[2] && movementDirs[1]) animation.play('DIAGNOAL_upright');
            if (movementDirs[3] && movementDirs[0]) animation.play('DIAGNOAL_downleft');
            if (movementDirs[3] && movementDirs[1]) animation.play('DIAGNOAL_downright');
        }
        if (movementDirs[0] && movementDirs[1] && movementDirs[3]) animation.play('down', true);
        if (movementDirs[0] && movementDirs[1] && movementDirs[2]) animation.play('up', true);

        if (allOn) animation.play('idle');
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
        if(!Transitioning) { //prevent a crash by making sure none of this stuff gets called when using a door.
            if (!collide())
    		    movement();
            colliding = false;

    		checkForPauseMenu();
            resetPauseMenu();
            forceCaps(); //so variables such as Health and ammo dont go above 100
            AimerPOSx = this.getGraphicMidpoint().x - 15;
            AimerPOSy = this.getGraphicMidpoint().y - 15;
            gun.update(elapsed);
            gun.updateTexturePosition(AimerPOSx, AimerPOSy);
            if(useDisplayHealthAsRealHealth)
                Playstate.instance.Player.displayHealth = Playstate.instance.Player.Health; //so we can get actual Health values for the Healthbar
    		#if debug
    		FlxG.watch.addQuick('Stamina', stamina);
    		FlxG.watch.addQuick('Speed', curPhysProperties.speed);
    		#end
            if (FlxG.keys.anyJustPressed([ONE, TWO, THREE, FOUR])) {
                if (FlxG.keys.anyJustPressed([ONE])) {
                    currentWeaponIndex = 0;
                } else if (FlxG.keys.anyJustPressed([TWO])) {
                    currentWeaponIndex = 1;
                } else if (FlxG.keys.anyJustPressed([THREE])) {
                    currentWeaponIndex = 2;
                } else if (FlxG.keys.anyJustPressed([FOUR])) {
                    currentWeaponIndex = 3;
                }
                updateWeapon();
            }
        }
	}
    override function destroy() {
        super.destroy();
        FlxG.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }
}