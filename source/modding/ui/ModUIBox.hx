package modding.ui;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxButton.FlxButtonState;
import flixel.tweens.FlxEase;
import flixel.addons.ui.FlxUITooltip;

using StringTools;

typedef ModDetails = {
    title:String,
    description:String,
    image:FlxGraphicAsset,
    version:String,
    ?compatVers:Array<String>,
    ?hasSettings:Bool,
    ?settingSubState:FlxSubState
}

class ModUIBox extends FlxSpriteGroup{
    private static var buttons:Array<FlxButton> = [];
    private static var modenabled:Bool = false;
    private static var tt:FlxUITooltip;
    private static var compat:FlxText;
    private static var compatableversions:Array<String> = [];
    private static var settings:FlxButton;

    //everything.
    private static var box:FlxSprite;
    private static var disableButton:FlxButton;
    private static var txt:Array<String> = [
        '', //down
        '', //up
        'i' //info
    ];
    private static var func:Array<Void->Void> = [
        ()->{ /*trace('move up in load order');*/ },
        ()->{ /*trace('move down in load order'); */},
        ()->{ /*trace('description or smthn'); */}
    ];
    private static var name:FlxText;
    private static var img:FlxSprite;

    private static var modIsCompatable:Int = 0; //! 0=compatable 1=needs older version 2=needs newer version

    public function new(x:Float, y:Float, modDetails:ModDetails){
        super(x, y);
        compatableversions = modDetails.compatVers;

        box = new FlxSprite(0, 0).makeGraphic(400, 100, FlxColor.BLACK);
        box.alpha = 0.5;
        add(box);

        for(i in 0...3){
            var btn:FlxButton = new FlxButton(if(i == 0) 20 else 40 * i, 80, '${txt[i]}', func[i]);
            btn.ID = i; //force set because of fucking stars bs.
            if(btn.ID == 2){ //info
                btn.x -= 20;
                btn.label.fieldWidth = 20;
                btn.loadGraphic('assets/ui/modbox/other.png', true, 20, 20);
            }else{ //literally everything else.
                btn.label.font = 'assets/fonts/SEGMDL2.ttf';
                btn.label.fieldWidth = 20;
                btn.loadGraphic('assets/ui/modbox/other.png', true, 20, 20);
            }
            //trace(btn.ID);
            btn.label.color = FlxColor.WHITE;
            buttons.push(btn);
            add(btn);
        }
        disableButton = new FlxButton(0, 80, 'X', ()->{
            modenabled = !modenabled;
            if(!modenabled){
                disableButton.loadGraphic('assets/ui/modbox/enable.png', true, 20, 20);
                disableButton.label.text = '+';
            }else{
                disableButton.loadGraphic('assets/ui/modbox/disable.png', true, 20, 20);
                disableButton.label.text = 'X';
            }
        });
        add(disableButton);
        disableButton.loadGraphic('assets/ui/modbox/disable.png', true, 20, 20);

        name = new FlxText(80, 0, box.width - 100, modDetails.title.substr(1, modDetails.title.length - 2), 24, true);
        name.font = null;
        add(name);

        compat = new FlxText(400 - 160, 80, 160, "compatable with...", 12, true);
        add(compat);
        tt = new FlxUITooltip(100, 100);
        tt.setPosition(compat.x, compat.y);
        add(tt);

        img = new FlxSprite(0, 0).loadGraphic(modDetails.image);
        img.setGraphicSize(80, 80);
        img.updateHitbox();
        add(img);

        settings = new FlxButton(80, 80, 'settings', ()->{ //create the button anyways, will still be set to visible or not visible depending on the ini settings. (hopefully)
            if(modDetails.settingSubState != null){
                var sub:FlxSubState = cast modDetails.settingSubState;
                FlxG.state.openSubState(sub);
            }
        });
        add(settings);

        //check if the current mod is compatable with the game's current version.
        if(!checkCompatability(modDetails.title, getCompatableVersions(compatableversions))){ //mod is NOT compatable
            if(modIsCompatable == 2){ //needs newer version
                FlxTween.color(compat, 1, 0xFFFFFFFF, 0xFF00FF00, { type: FlxTweenType.PINGPONG });
                for(i in 1...3){
                    buttons[i].status = FlxButtonState.DISABLED;
                }
                if(modDetails.hasSettings){
                    settings.status = FlxButtonState.DISABLED;
                }
                if(!modenabled){ //disable buttons if mod is not enabled, BUT. let you disable the mod despite anything.
                    for(i in 0...3){
                        buttons[i].status = FlxButtonState.DISABLED;
                    }
                }else{
                    for(i in 1...3){
                        buttons[i].status = FlxButtonState.DISABLED;
                    }
                }
            }else if(modIsCompatable == 1){ //needs older version.
                FlxTween.color(compat, 1, 0xFFFFFFFF, 0xFFFF0000, { type: FlxTweenType.PINGPONG });
                if(!modenabled){
                    for(i in 0...3){
                        buttons[i].status = FlxButtonState.DISABLED;
                    }
                }else{
                    for(i in 1...3){
                        buttons[i].status = FlxButtonState.DISABLED;
                    }
                }
            }
        }else if(modIsCompatable == 0){ //mod is compatable.
            //donothing, for now.
        }

        if(modDetails.hasSettings){ //do at bottom so that the game has time to try all this stuff.
            settings.visible = true;
        }else{
            settings.visible = false;
        }

    }
    override public function update(elapsed:Float){
        super.update(elapsed);
        if(FlxG.mouse.overlaps(compat)){
            if(!tt.visible && !tt.active){
                tt.show(compat,
                "compatable with versions...",
                'V${getCompatableVersions(compatableversions)}',
                true, true, true);
            }
        }else{
            if(tt.active && tt.visible){
                tt.hide();
            }
        }
    }
    public inline function getCompatableVersions(Versions:Array<String>):String //INLINE FUNCTION YAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
        return Versions.toString().substr(3, Versions.toString().length - 6).replace(',', '\n');

    public function checkCompatability(Mod:String, modCompatabilityVersions:String):Bool { //thanks chatgpt!
        var currentVersion = Application.current.meta.get('version');
        //trace('Current game version: $currentVersion');
        //trace('Mod compatibility versions:\n$modCompatabilityVersions');
    
        // Split the string into an array
        var versions = modCompatabilityVersions.split("\n");
    
        // Function to extract the version number
        function extractVersion(entry:String):String {
            var parts = entry.split("_"); // Split by "_"
            return parts[parts.length - 1]; // Last part should be the version number
        }
    
        // Function to compare two versions
        function compareVersions(v1:String, v2:String):Int {
            var parts1 = v1.split(".").map(Std.parseInt);
            var parts2 = v2.split(".").map(Std.parseInt);
    
            for (i in 0...3) { // Compare major, minor, and patch
                var num1 = parts1[i] ?? 0;
                var num2 = parts2[i] ?? 0;
                if (num1 > num2) return 1;  // v1 is newer
                if (num1 < num2) return -1; // v1 is older
            }
            return 0; // Versions are equal
        }
    
        var compatible = false;
        var newestVersion:String = currentVersion;
        var oldestVersion:String = currentVersion;
    
        for (version in versions) {
            var modVersion = extractVersion(version);
            var comparison = compareVersions(modVersion, currentVersion);
    
            if (comparison == 0) {
                compatible = true;
                modIsCompatable = 0;
            } else if (comparison > 0) {
                //trace('$Mod version $modVersion is NEWER than game version $currentVersion.');
                modIsCompatable = 2;
                newestVersion = modVersion;
            } else {
                //trace('$Mod version $modVersion is OLDER than game version $currentVersion.');
                modIsCompatable = 1;
                oldestVersion = modVersion;
            }
        }
    
        if (compatible) {
            //trace('$Mod is COMPATIBLE with game version: $currentVersion');
            return true;
        } else {
            //trace('$Mod is NOT COMPATIBLE with game version: $currentVersion');
            return false;
        }
    }

    override public function destroy(){
        super.destroy();
        buttons = [];
    }
}