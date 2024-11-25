package backend;

class Functions
{
    static inline public function GetPlatform():String
        #if html5 return "Html5"; #else #if cpp return "Windows"; #else #if hl return "HashLink"; #else return "Unknown"; #end #end #end
    
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