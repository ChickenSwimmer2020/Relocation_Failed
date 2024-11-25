package backend;

class Functions
{
    static inline public function GetPlatform():String
        #if Browser return "Html5"; #else #if Computer return "Windows"; #else return "Unknown"; #end #end
    
    static public function DoButtonShtuff(Button:String)
        {
            switch(Button)
                {
                    case 'Play':
                        FlxG.switchState(new Playstate());
                    case 'Settings':
                        FlxG.switchState(new menu.Settings());
                    default:
                        trace('BUTTON TYPE WASNT DECLARED.');
                }
        }
}