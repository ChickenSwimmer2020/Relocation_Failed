package menu.intro;

import backend.Preferences;

class Decide extends FlxState{
    override public function create(){
        super.create();
        @:privateAccess
        Main.loadGameSaveData();
        if(FlxG.save.data.SkipIntro == true && FlxG.save.data.SkipIntro != null){
            FlxG.switchState(()->new WaterMarks());
        } else {
            FlxG.switchState(()->new WindowIntro());
        }
    }
}