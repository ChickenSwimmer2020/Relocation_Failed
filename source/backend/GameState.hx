package backend;
/**
 * the game state class, used for storing global variables about the player and what they have, such as preserving inventory data and other thnigs between levels.
 */
class GameState {
    public static var PlayerHealth:Float = 100;
    public static var PlayerOxygen:Float = 100;
    public static var PlayerArmor:Float = 100;
    public static var PlayerSprint:Float = 100;
    public static var PlayerPistolAmmo:Float = 0;
    public static var PlayerShotgunAmmo:Float = 0;
    public static var PlayerRifleAmmo:Float = 0;
    public static var PlayerSMGAmmo:Float = 0;
    //public static var PlayerHasSuit:Bool = false;
    public static var PlayerHasPistol:Bool = false;
    public static var PlayerHasShotgun:Bool = false;
    public static var PlayerHasRifle:Bool = false;
    public static var PlayerHasSMG:Bool = false;
    public static var dataArray:Array<Dynamic> = [];
    /**
     * save game state to the varibles so that they can be loaded later.
     * @param State (array of dynamics) the state to save, in order: PlayerHealth, PlayerOxygen, PlayerArmor, PlayerSprint, PlayerPistolAmmo, PlayerShotgunAmmo, PlayerRifleAmmo, PlayerSMGAmmo, PlayerHasSuit, PlayerHasPistol, PlayerHasShotgun, PlayerHasRifle, PlayerHasSMG
     */
    public static function saveState(State:Array<Dynamic>) {
        PlayerHealth = State[0];
        PlayerOxygen = State[1];
        PlayerArmor = State[2];
        PlayerSprint = State[3];
        PlayerPistolAmmo = State[4];
        PlayerShotgunAmmo = State[5];
        PlayerRifleAmmo = State[6];
        PlayerSMGAmmo = State[7];
        var randomvarbeacuseidontwantacrash = State[8];
        PlayerHasPistol = State[9];
        PlayerHasShotgun = State[10];
        PlayerHasRifle = State[11];
        PlayerHasSMG = State[12];
        dataArray = [State[0], State[1], State[2], State[3], State[4], State[5], State[6], State[7], State[8], State[9], State[10], State[11], State[12]];
    };
    public static function loadState(State:Array<Dynamic>) {
        Playstate.instance.Player.Health = State[0];
        Playstate.instance.Player.oxygen = State[1];
        Playstate.instance.Player.battery = State[2];
        Playstate.instance.Player.stamina = State[3];
        Playstate.instance.Player.PistolAmmoRemaining = State[4];
        Playstate.instance.Player.ShotgunAmmoRemaining = State[5];
        Playstate.instance.Player.RifleAmmoRemaining = State[6];
        Playstate.instance.Player.SMGAmmoRemaining = State[7];
        var randomvarbeacuseidontwantacrash = State[8];
        Playstate.instance.Player.hasPistol = State[9];
        Playstate.instance.Player.hasShotgun = State[10];
        Playstate.instance.Player.hasRifle = State[11];
        Playstate.instance.Player.hasSMG = State[12];
    }
}