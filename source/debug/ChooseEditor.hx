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
    public static var MODIFIER:FlxSound; //FOR SYNCING

    public var audioVolCheck:Bool = false;
    public var fixSync:Bool = false;

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
        if(MODIFIER == null || !MODIFIER.alive)
            MODIFIER = new FlxSound().loadEmbedded('assets/sound/mus/Modifier.ogg', true, false); //SYNCING
        var tmr:FlxTimer = new FlxTimer();
        tmr.start(0.1, function(tmr:FlxTimer) {
            audioVolCheck = true;
            fixSync = true;
            if(!MODIFIER.playing)
                MODIFIER.play();
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
            MODIFIER.volume = 0.0001;
            tmr.destroy(); //prevent an memory leak by destroying the timer, it gets recreated anyways.
        });
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
        if(fixSync){
            //syncing (I CANT BE-FUCKING-LIVE I HAVE TO DO THIS MANUALLY. FLIXEL. YOUR FUCKING STUPID SOMTIMES ISTFG.)
            if(elapsed % 2 == 0){ //on every second frame, hopefully to make it not sound choppy?
                if(DRUMS != null || DRUMS.exists){
                    DRUMS.time = MODIFIER.time;
                    if(BALLS != null)
                        BALLS.time = MODIFIER.time;
                    if(BASS != null)
                        BASS.time = MODIFIER.time;
                    if(DEEPERBASS != null)
                        DEEPERBASS.time = MODIFIER.time;
                    if(NPC != null)
                        NPC.time = MODIFIER.time;
                    if(AI != null)
                        AI.time = MODIFIER.time;
                    if(ITEM != null)
                        ITEM.time = MODIFIER.time;
                    if(ANIM != null)
                        ANIM.time = MODIFIER.time;
                    if(LEVEL != null)
                        LEVEL.time = MODIFIER.time;
                    if(WEAPONS != null)
                        WEAPONS.time = MODIFIER.time;
                }
            }
        }
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
            if(MODIFIER != null)
                MODIFIER.volume = 0.0001; //so its BARELY audible under the actual song mechanics, but we still need this for syncing
        }
        trace(MODIFIER.time);
        if(FlxG.keys.anyJustPressed([ESCAPE])){
            audioVolCheck = false;
            fixSync = false;
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
            if(MODIFIER != null)
                MODIFIER.kill();
            FlxG.sound.playMusic(Assets.music('ConnectionEstablished.ogg'));
            FlxG.switchState(()->new MainMenu());
        }
    }
}