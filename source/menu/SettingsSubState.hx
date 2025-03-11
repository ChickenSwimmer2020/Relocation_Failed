package menu;

import flixel.addons.ui.Anchor;
import flixel.addons.ui.FlxUITooltip;
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
    var ShellEjection:FlxUICheckBox;


    //baby
    var Difficulty_00:FlxUICheckBox;
    var Difficulty_00_IMG:FlxSprite;
    var Difficulty_00_LABEL:FlxText;
    var Difficulty_00_TOOLTIP:FlxUITooltip;

    //easy
    var Difficulty_01:FlxUICheckBox;
    var Difficulty_01_IMG:FlxSprite;
    var Difficulty_01_LABEL:FlxText;
    var Difficulty_01_TOOLTIP:FlxUITooltip;

    //normal
    var Difficulty_02:FlxUICheckBox;
    var Difficulty_02_IMG:FlxSprite;
    var Difficulty_02_LABEL:FlxText;
    var Difficulty_02_TOOLTIP:FlxUITooltip;

    //hard
    var Difficulty_03:FlxUICheckBox;
    var Difficulty_03_IMG:FlxSprite;
    var Difficulty_03_LABEL:FlxText;
    var Difficulty_03_TOOLTIP:FlxUITooltip;

    //hardcore
    var Difficulty_04:FlxUICheckBox;
    var Difficulty_04_IMG:FlxSprite;
    var Difficulty_04_LABEL:FlxText;
    var Difficulty_04_TOOLTIP:FlxUITooltip;

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

        Difficulty_00_TOOLTIP = new FlxUITooltip(200, 100, new Anchor(0, 0, "right", "top", "left", "top"));

		var tabs = [
			{name: "tab_1", label: "General"},
			{name: "tab_2", label: "Graphics"},
			{name: "tab_3", label: "Accessibility"},
			{name: "tab_4", label: "Difficulty"}
		];
        TabGroups = new FlxUITabMenu(null, tabs, true);
        TabGroups.resize(TabGroups.width + 50, TabGroups.height);

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
            WaterMarks = new FlxUICheckBox(10, 70, null, null, 'WaterMarks');
            tab_group_1.add(SkipIntro);
            tab_group_1.add(WaterMarks);

        //* tab group 2 -- Graphics
            var Tab2BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab2BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            Tracers = new FlxUICheckBox(10, 40, null, null, 'Bullet Tracers');
            ShellEjection = new FlxUICheckBox(10, 70, null, null, 'Shell Ejection');
            tab_group_2.add(Tab2BG1);
            tab_group_2.add(Tab2BG2);
            tab_group_2.add(Tracers);
            tab_group_2.add(ShellEjection);

        //* tab groupd 3 -- Accessibility
            var Tab3BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab3BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_3.add(Tab3BG1);
            tab_group_3.add(Tab3BG2);

        //* tab group 4 -- Difficulty
            var Tab4BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab4BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_4.add(Tab4BG1);
            tab_group_4.add(Tab4BG2);
                Difficulty_00 = new FlxUICheckBox(TabGroups.x + 32, TabGroups.y + 110, null, null, '');
                Difficulty_00_IMG = new FlxSprite(TabGroups.x + 10, TabGroups.y + 10);
                Difficulty_00_IMG.loadGraphic(Assets.image('game/settings/DIFF_POSTERS_SETTINGS'), true, 64, 100);
                Difficulty_00_IMG.animation.add('BABY', [0], 1, true, false, false);
                Difficulty_00_LABEL = new FlxText(TabGroups.x + 12, Difficulty_00.y + 15, 0, "Baby Mode");

                Difficulty_01 = new FlxUICheckBox(TabGroups.x + 94, TabGroups.y + 110, null, null, '');
                Difficulty_01_IMG = new FlxSprite(TabGroups.x + 70, TabGroups.y + 10);
                Difficulty_01_IMG.loadGraphic(Assets.image('game/settings/DIFF_POSTERS_SETTINGS'), true, 64, 100);
                Difficulty_01_IMG.animation.add('EASY', [1], 1, true, false, false);
                Difficulty_01_IMG.animation.play('EASY');
                Difficulty_01_LABEL = new FlxText(TabGroups.x + 80, Difficulty_00.y + 15, 0, "Easy Mode");
            tab_group_4.add(Difficulty_00);
            tab_group_4.add(Difficulty_00_IMG);
            tab_group_4.add(Difficulty_00_LABEL);

            tab_group_4.add(Difficulty_01);
            tab_group_4.add(Difficulty_01_IMG);
            tab_group_4.add(Difficulty_01_LABEL);



        Save = new FlxButton(TabGroups.x + 400, TabGroups.y + 246.7, "SAVE", function() { FlushToPrefs(); });
        Back = new FlxSquareButton(Save.x + 80, TabGroups.y + 246.7, "X", function() { close(); });

        add(TabGroups);
        add(Back);
        add(Save);

        add(Difficulty_00_TOOLTIP);

        for(item in this.members){
            item.camera = settingsCAM;
            if(Std.isOfType(item, FlxSprite) || Std.isOfType(item, FlxUITooltip)) {
                var daSpr:FlxSprite = cast item;
                daSpr.scrollFactor.set();
            }
        }
        LoadFromPrefs();
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        parstate.update(elapsed);

        if ( (FlxG.mouse.overlaps(Difficulty_00_LABEL) || FlxG.mouse.overlaps(Difficulty_00_IMG)) && TabGroups.selected_tab_id == 'tab_4') {
            if(!Difficulty_00_TOOLTIP.visible && !Difficulty_00_TOOLTIP.active){
			Difficulty_00_TOOLTIP.show(Difficulty_00_LABEL, 'Baby Mode',
				'For people new to top down shooters\n
Enemy Damage -50%, Player Damage +75%\n
Ammo pickups +50% ammo\n
Enemy Speed -15%, Player Speed +25%\n
Oxygen doesnt drain, battery takes 50% less impact\n
Ammo pickups are more common\n
Enemies spawn less\n
Game Autosaves At every door and every 5 minutes\n
achivements are disabled\n
\"Aw, wook at the wittel baby!\"\n--asdfmovie8 2014',
				true, false, true);
                @:privateAccess
                    Difficulty_00_TOOLTIP._bodyText.fieldWidth = 200;
            }
		} else {
            if(Difficulty_00_TOOLTIP.visible && Difficulty_00_TOOLTIP.active)
			    Difficulty_00_TOOLTIP.hide();
		}
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
        if(Preferences.save.SkipWaterMarks != WaterMarks.checked) {
            Preferences.save.SkipWaterMarks = WaterMarks.checked;
            Preferences.saveSettings();
        }
        if(Preferences.save.ShellEjection != ShellEjection.checked) {
            Preferences.save.ShellEjection = ShellEjection.checked;
            Preferences.saveSettings();
        }
    }

    public function LoadFromPrefs(){
        @:privateAccess
            Main.loadGameSaveData();

        if(FlxG.save.data.SkipIntro != null) {
            SkipIntro.checked = FlxG.save.data.SkipIntro;
        }else{
            SkipIntro.checked = false;
            FlxG.save.data.SkipIntro = false;
        }

        if(FlxG.save.data.Tracers != null) {
            Tracers.checked = FlxG.save.data.bulletTracers;
        }else{
            Tracers.checked = false;
            FlxG.save.data.bulletTracers = false;
        }

        if(FlxG.save.data.WaterMarks != null) {
            WaterMarks.checked = FlxG.save.data.WaterMarks;
        }else{
            WaterMarks.checked = false;
            FlxG.save.data.WaterMarks = false;
        }

        if(FlxG.save.data.ShellEjection != null) {
            ShellEjection.checked = FlxG.save.data.ShellEjection;
        }else{
            ShellEjection.checked = false;
            FlxG.save.data.ShellEjection = false;
        }
    }
}