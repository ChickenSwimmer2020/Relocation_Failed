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
            //CutScene.loadGraphic(Assets.image('IntroCutscene'), true, 1280, 720, true);
            CutScene.frames = Assets.getSparrowAtlas('IntroCutScene');
            CutScene.animation.addByPrefix('CUTSCENE', 'Animation', 60, false, false, false);
            add(CutScene);
            CutScene.animation.finishCallback = function(YoureMom)
                {
                    endScene();
                }
        }
}