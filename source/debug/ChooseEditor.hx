package debug;

import menu.MainMenu;
import flixel.sound.FlxSound;
using StringTools;

class ChooseEditor extends FlxState {
    //for the multieditor song system.
    public static var BALLS:FlxSound;
    public static var BASS:FlxSound;
    public static var NPC:FlxSound;
    public static var AI:FlxSound;
    public static var ITEM:FlxSound;
    public static var ANIM:FlxSound;
    public static var LEVEL:FlxSound;
    public static var WEAPONS:FlxSound;
    public static var DEEPERBASS:FlxSound;
    public static var DRUMS:FlxSound;

    public var audioVolCheck:Bool = false;

    override public function create() {
        super.create();
        FlxG.sound.music.stop();
        var text:FlxText = new FlxText(0, 0, 0, "Choose Editor", 24, true);
        text.setFormat(null, 24, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        add(text);

        var editors:Array<String> = [
'Level Editor', //sound implemented!
'AI Editor', //sound implemented!
'NPC Editor', //sound implemented!
'Item Editor', //sound implemented!
'Anim Offset', //sound implemented!
'Weapon Editor']; //sound implemented!
        for(i in 0...editors.length){
            var btn:FlxButton = new FlxButton(0, if(i == 0) 20 else 20 * i, editors[i], function() {
                trace("Switching to " + editors[i]);
                FlxG.switchState(()->new debug.leveleditor.Editor.EditorState(editors[i].substr(0, editors[i].length - 7)));
            });
            if(i >= 1) btn.y += 20;
            btn.screenCenter(X);
            add(btn);
        }
        //sound playing shtuff.
        if(BALLS == null || !BALLS.alive)
            BALLS = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/BELLS.ogg', true, false); //GLOBAL
        if(BASS == null || !BASS.alive)
            BASS = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/BASS.ogg', true, false); //GLOBAL
        if(NPC == null || !NPC.alive)
            NPC = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/NPC.ogg', true, false); //NPC EDITOR
        if(AI == null || !AI.alive)
            AI = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/AI.ogg', true, false); //AI EDITOR
        if(ITEM == null || !ITEM.alive)
            ITEM = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/ITEM.ogg', true, false); //ITEM EDITOR
        if(ANIM == null || !ANIM.alive)
            ANIM = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/ANIM.ogg', true, false); //OFFSET EDITOR
        if(LEVEL == null || !LEVEL.alive)
            LEVEL = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/LEVEL.ogg', true, false); //LEVEL EDITOR
        if(WEAPONS == null || !WEAPONS.alive)
            WEAPONS = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/WEAPONS.ogg', true, false); //WEAPON EDITOR
        if(DEEPERBASS == null || !DEEPERBASS.alive)
            DEEPERBASS = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/808.ogg', true, false); //GLOBAL
        if(DRUMS == null || !DRUMS.alive)
            DRUMS = new FlxSound().loadEmbedded('assets/sound/mus/Modifier/DRUMS.ogg', true, false); //GLOBAL
        var tmr:FlxTimer = new FlxTimer();
        tmr.start(0.1, function(tmr:FlxTimer) {
            audioVolCheck = true;
            if(!BALLS.playing)
                BALLS.play();
            if(!BASS.playing)
                BASS.play();
            if(!DEEPERBASS.playing)
                DEEPERBASS.play();
            if(!DRUMS.playing)
                DRUMS.play();
            //PLAY AT 0 VOLUME
            if(!NPC.playing)
                NPC.play();     
            if(!AI.playing)
                AI.play();
            if(!ITEM.playing)
                ITEM.play();
            if(!ANIM.playing)
                ANIM.play();
            if(!LEVEL.playing)
                LEVEL.play();
            if(!WEAPONS.playing)
                WEAPONS.play();
            NPC.volume = 0; //force set volume to 0 so they arent audible.
            AI.volume = 0; //force set volume to 0 so they arent audible.
            ITEM.volume = 0; //force set volume to 0 so they arent audible.
            ANIM.volume = 0; //force set volume to 0 so they arent audible.
            LEVEL.volume = 0; //force set volume to 0 so they arent audible.
            WEAPONS.volume = 0; //force set volume to 0 so they arent audible.
        });
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
        if(audioVolCheck){
            if(BALLS != null)
                BALLS.volume = FlxG.sound.volume; //band-aid fix
            if(BASS != null)
                BASS.volume = FlxG.sound.volume;
            if(DEEPERBASS != null)
                DEEPERBASS.volume = FlxG.sound.volume;
            if(DRUMS != null)
                DRUMS.volume = FlxG.sound.volume;
            if(NPC != null)
                NPC.volume = 0; //force set volume to 0 so they arent audible.
            if(AI != null)
                AI.volume = 0; //force set volume to 0 so they arent audible.
            if(ITEM != null)
                ITEM.volume = 0; //force set volume to 0 so they arent audible.
            if(ANIM != null)
                ANIM.volume = 0; //force set volume to 0 so they arent audible.
            if(LEVEL != null)
                LEVEL.volume = 0; //force set volume to 0 so they arent audible.
            if(WEAPONS != null)
                WEAPONS.volume = 0; //force set volume to 0 so they arent audible.
        }
        if(FlxG.keys.anyJustPressed([ESCAPE])){
            audioVolCheck = false;
            if(BALLS != null)
                BALLS.kill();
            if(BASS != null)
                BASS.kill();
            if(NPC != null)
                NPC.kill();
            if(AI != null)
                AI.kill();
            if(ITEM != null)
                ITEM.kill();
            if(ANIM != null)
                ANIM.kill();
            if(LEVEL != null)
                LEVEL.kill();
            if(WEAPONS != null)
                WEAPONS.kill();
            if(DEEPERBASS != null)
                DEEPERBASS.kill();
            if(DRUMS != null)
                DRUMS.kill();
            FlxG.sound.playMusic(Assets.music('ConnectionEstablished.ogg'));
            FlxG.switchState(()->new MainMenu());
        }
    }
}