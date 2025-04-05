package modding;

import flixel.util.typeLimit.OneOfFour;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxGridOverlay;
import flixel.math.FlxRandom;
import modding.ui.ModUIStar.MODStar;
import flixel.addons.display.FlxBackdrop;
import modding.ui.ModUIBox;

using flixel.util.FlxStringUtil;
using StringTools;

class ModViewerState extends FlxState{
    //state varibles
    var rand:FlxRandom = new FlxRandom();
    var pIndex:Int = 0;

    //ui shtuff
    var bgbox:FlxSprite;
    //TODO: detect how many rfm files there are and make the custom icon SHTUFF, do this. seriously.
    //TODO: scrollable areas? clipping recs? TF????
    //text
    var modstext01:FlxText;
        var modstext01_line:FlxSprite;
    var modstext02:FlxText;
        var modstext02_line:FlxSprite;
    
    public function new() {
        super();
        #if debug
            trace('loading mods...');
        #end
    }

    override public function create() {
        super.create();

        //UI GOES DOWN HERE

        bgbox = new FlxSprite(0, 0).makeGraphic(500, FlxG.height, FlxColor.WHITE);
        bgbox.alpha = 0.75;
        bgbox.screenCenter(X);
        add(bgbox);

        pIndex = members.indexOf(bgbox);

        modstext01 = new FlxText(bgbox.x, bgbox.y, 500, "Active Mods", 24, true);
        modstext01.font = null; //load the default flixel font.
        modstext01.color = FlxColor.BLACK;
        modstext01.alignment = CENTER;
        add(modstext01);

        modstext01_line = new FlxSprite(bgbox.x + 20, modstext01.y + 50).makeGraphic(440, 2, FlxColor.BLACK);
        add(modstext01_line);

        modstext02 = new FlxText(bgbox.x, bgbox.y + FlxG.height/2, 500, "Installed Mods", 24, true);
        modstext02.font = null; //load the default flixel font.
        modstext02.color = FlxColor.BLACK;
        modstext02.alignment = CENTER;
        add(modstext02);

        //modstext02_line = new FlxSprite().makeGraphic();
        //add(modstext02_line);

        var reader = new ModFileParser();

        var textbox:ModUIBox = new ModUIBox(bgbox.x, bgbox.y, {
            title: reader.readINI('assets/testing/testmod.rfm', null, 'Name', 'String'),
            description: reader.readINI('assets/testing/testmod.rfm', null, 'Description', 'String'),
            image: reader.getPackIMG('assets/testing/testmod.rfm'),
            version: reader.readINI('assets/testing/testmod.rfm', null, 'Version', 'String'),
            compatVers: [reader.readINI('assets/testing/testmod.rfm', null, 'CompatVers', 'String')],
            hasSettings: true, //TODO: add settings detection to INI files.
            settingSubState: reader.loadSubStateFromModFile('ModSettings', 'SubStates', 'assets/testing/testmod.rfm')
        });
        add(textbox);

        var textbox2:ModUIBox = new ModUIBox(bgbox.x, bgbox.y + 100, {
            title: reader.readINI('assets/testing/testmod1.rfm', null, 'Name', 'String'),
            description: reader.readINI('assets/testing/testmod1.rfm', null, 'Description', 'String'),
            image: reader.getPackIMG('assets/testing/testmod1.rfm'),
            version: reader.readINI('assets/testing/testmod1.rfm', null, 'Version', 'String'),
            compatVers: [reader.readINI('assets/testing/testmod1.rfm', null, 'CompatVers', 'String')],
            hasSettings: false, //TODO: add settings detection to INI files.
            settingSubState: reader.loadSubStateFromModFile('ModSettings', 'SubStates', 'assets/testing/testmod1.rfm')
        });
        add(textbox2);
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
        rand.currentSeed = Std.int(FlxG.elapsed) + rand.int(0, 99999);
        var STR:MODStar = cast new MODStar(rand.int(0, 1280), 720, null, 2).makeGraphic(10, 10, FlxColor.WHITE);
        insert(pIndex, STR);

        if(FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE])){
            FlxG.switchState(menu.MainMenu.new);
        }
    }
}