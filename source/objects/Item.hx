package objects;

enum ItemType 
{
    //health
    _HEALTHPACK; //full health refill
    _STIMPACK; //refil a determinate ammount of health depending on current health value
    //ammo stuff
    _BOXOFBUCKSHELL; //gives +50 buckshot
    _BUCKSHELL; //gives + 25 buckshot
    _BOXOF9MM; //gives +100 9MM
    _9MMMAG; //gives +25 9MM
    _RIFLEROUNDSBOX; //gives +100 7.62x51MM NATO
    _RIFLEROUNDSMAG; //gives +25 7.62x51MM NATO
    //misc
    _OXYGENTANK; //gives oxygen (FOR THE HULL BREACH AREAS ONLY.)
    _SUITBATTERY; //gives +15% armor battery
}

class Item {
    public var itemType:ItemType;
}