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
    static public function getSpriteAngleFromMousePos():Float
        {
            //thanks chatGPT!
            var angle:Float = 0;
            var screencenterX = FlxG.width / 2;
            var screencenterY = FlxG.height / 2;
            var mouseX = FlxG.mouse.getScreenPosition(Playstate.instance.HUDCAM).x;
            var mouseY = FlxG.mouse.getScreenPosition(Playstate.instance.HUDCAM).y;
            var relativeX = mouseX - screencenterX;
            var relativeY = mouseY - screencenterY;

            angle = Math.atan2(relativeY, relativeX) * 180 / Math.PI;

            #if debug
            FlxG.watch.addQuick('CurAngle', angle);
            FlxG.watch.addQuick('screenCenterX', screencenterX);
            FlxG.watch.addQuick('screencenterY', screencenterY);
            FlxG.watch.addQuick('mouseX', FlxG.mouse.screenX);
            FlxG.watch.addQuick('mouseY', FlxG.mouse.screenY);
            FlxG.watch.addQuick('relativeX', relativeX);
            FlxG.watch.addQuick('relativeY', relativeY);
            #end
            return angle;
        }
}