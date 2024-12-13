package menu;

import backend.Assets;

class Intro extends FlxSubState
{
    function endScene()
        {
            close();
        }
    override public function create()
        {
            var CutScene:FlxSprite = new FlxSprite(0,0);
            CutScene.frames = Assets.getSparrowAtlas('IntroCutScene');
            CutScene.animation.addByPrefix('CUTSCENE', 'Animation', 60, false, false, false);
            add(CutScene);
            CutScene.animation.onFinish.add(function(YoureMom)
                {
                    endScene();
                });
        }
}