package menu.intro;

import hlwnative.HLNativeWindow;
import backend.Preferences;

class Decide extends FlxState{
    override public function create(){
        super.create();
        HLNativeWindow.setWindowDarkMode(true); // It just looks cleaner
        @:privateAccess
        Main.loadGameSaveData();
        if(FlxG.save.data.SkipIntro == true && FlxG.save.data.SkipIntro != null){
            FlxG.switchState(()->new WaterMarks());
        } else {
            FlxG.switchState(()->new WindowIntro());
        }
    }
}