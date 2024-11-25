package backend;

class Functions
{
    static inline public function GetPlatform():String
        #if html5 return "Html5"; #else #if cpp return "Windows"; #else #if hl return "HashLink/Windows"; #else return "Unknown"; #end #end #end
    
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
    static public function logToLinear(x:Float, minValue:Float = 0.001):Float {
        // Ensure x is between minValue and 1
        x = Math.max(minValue, Math.min(1, x));

        // Convert logarithmic scale to linear
        return 1 - (Math.log(x) / Math.log(minValue));
    }
}