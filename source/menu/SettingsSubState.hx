package menu;

import openfl.geom.Rectangle;
import flixel.addons.ui.FlxUIAssets;
import flixel.addons.ui.FlxUI9SliceSprite;
import rf_flixel.ui.FlxSquareButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;

class SettingsSubState extends FlxSubState{
    var TabGroups:FlxUITabMenu;
    var Tracers:FlxUICheckBox;
    var SkipIntro:FlxUICheckBox;
    var WaterMarks:FlxUICheckBox;
    var Back:FlxSquareButton;
    var Save:FlxButton;
    var Saved:Bool = false;
    var settingsCAM:FlxCamera;

    private var instance:SettingsSubState;
    private var parstate:FlxState;
    var done:Bool = false;

    public function new(parentState:FlxState){
        super();

        this.parstate = parentState;
        this.instance = this;

        settingsCAM = new FlxCamera();
		FlxG.cameras.add(settingsCAM, false);
		settingsCAM.bgColor = 0x000000;
    }

    override public function create() {
        Preferences.loadSettings();
		var tabs = [
			{name: "tab_1", label: "General"},
			{name: "tab_2", label: "Graphics"},
			{name: "tab_3", label: "Gameplay"},
			{name: "tab_4", label: "Difficulty"}
		];
        TabGroups = new FlxUITabMenu(null, tabs, true);
        TabGroups.resize(TabGroups.width + 50, TabGroups.height);
        var sliderRate = new FlxUISlider(this, 'volume', 10, 10, 0.5, 3, 150, 15, 5, FlxColor.WHITE, FlxColor.BLACK);
		sliderRate.nameLabel.text = 'Volume';

		var tab_group_1 = new FlxUI(null, TabGroups, null);
        tab_group_1.name = 'tab_1';
        TabGroups.addGroup(tab_group_1);

        var tab_group_2 = new FlxUI(null, TabGroups, null);
        tab_group_2.name = 'tab_2';
        TabGroups.addGroup(tab_group_2);

        var tab_group_3 = new FlxUI(null, TabGroups, null);
        tab_group_3.name = 'tab_3';
        TabGroups.addGroup(tab_group_3);

        var tab_group_4 = new FlxUI(null, TabGroups, null);
        tab_group_4.name = 'tab_4';
        TabGroups.addGroup(tab_group_4);

        //* tab group 1 -- General
            var Tab1BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab1BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_1.add(Tab1BG1);
            tab_group_1.add(Tab1BG2);
            SkipIntro = new FlxUICheckBox(10, 10, null, null, 'Skip Intro');
            Tracers = new FlxUICheckBox(10, 40, null, null, 'Bullet Tracers');
            WaterMarks = new FlxUICheckBox(10, 70, null, null, 'WaterMarks');
            tab_group_1.add(SkipIntro);
            tab_group_1.add(Tracers);
            tab_group_1.add(WaterMarks);

        //* tab group 2 -- Graphics
            var Tab2BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab2BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_2.add(Tab2BG1);
            tab_group_2.add(Tab2BG2);

        //* tab groupd 3 -- Gameplay
            var Tab3BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab3BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_3.add(Tab3BG1);
            tab_group_3.add(Tab3BG2);

        //* tab group 4 -- Difficulty
            var Tab4BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab4BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_4.add(Tab4BG1);
            tab_group_4.add(Tab4BG2);



        Save = new FlxButton(TabGroups.x + 400, TabGroups.y + 246.7, "SAVE", function() { FlushToPrefs(); });
        Back = new FlxSquareButton(Save.x + 80, TabGroups.y + 246.7, "X", function() { close(); });

        add(TabGroups);
        add(Back);
        add(Save);

        for(item in this.members){
            item.camera = settingsCAM;
            if(Std.isOfType(item, FlxSprite)) {
                var daSpr:FlxSprite = cast item;
                daSpr.scrollFactor.set();
            }
        }
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        parstate.update(elapsed);
    }

    override public function destroy() {
        super.destroy();
        settingsCAM.destroy();
    }

    public function FlushToPrefs() {
        if(Preferences.save.SkipIntro != SkipIntro.checked) {
            Preferences.save.SkipIntro = SkipIntro.checked;
            Preferences.saveSettings();
        }
        if(Preferences.save.bulletTracers != Tracers.checked) {
            Preferences.save.bulletTracers = Tracers.checked;
            Preferences.saveSettings();
        }
        if(Preferences.save.WaterMarks != WaterMarks.checked) {
            Preferences.save.WaterMarks = WaterMarks.checked;
            Preferences.saveSettings();
        }
    }

    public function LoadFromPrefs(){
        @:privateAccess
            Main.loadGameSaveData();
        SkipIntro.checked = FlxG.save.data.SkipIntro;
        Tracers.checked = FlxG.save.data.bulletTracers;
        WaterMarks.checked = FlxG.save.data.WaterMarks;
    }
}