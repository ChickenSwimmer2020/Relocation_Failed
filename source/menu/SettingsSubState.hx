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
    var Tracers_Check:FlxUICheckBox;
    var Back:FlxSquareButton;
    var Save:FlxButton;
    var volume:Float = 0;
    var Saved:Bool = false;

    private var instance:SettingsSubState;
    private var parstate:FlxState;
    var done:Bool = false;

    public function new(parentState:FlxState){
        super();

        this.parstate = parentState;
        this.instance = this;
    }

    override public function create() {
		var tabs = [
			{name: "tab_1", label: "General"},
			{name: "tab_2", label: "Graphics"},
			{name: "tab_3", label: "Gameplay"},
			{name: "tab_4", label: "TBA"}
		];
        TabGroups = new FlxUITabMenu(null, tabs, true);
        TabGroups.resize(TabGroups.width + 50, TabGroups.height);
        var sliderRate = new FlxUISlider(this, 'volume', 10, 10, 0.5, 3, 150, 15, 5, FlxColor.WHITE, FlxColor.BLACK);
		sliderRate.nameLabel.text = 'Volume';

        Tracers_Check = new FlxUICheckBox(10, 20, null, null, 'Bullet Tracers');

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

        //* tab group 4 -- TBA
            var Tab4BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab4BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_4.add(Tab4BG1);
            tab_group_4.add(Tab4BG2);



        Save = new FlxButton(TabGroups.x + 400, TabGroups.y + 246.7, "SAVE", function() { /*makesave*/});
        Back = new FlxSquareButton(Save.x + 80, TabGroups.y + 246.7, "X", function() { close(); });

        add(TabGroups);
        add(Back);
        add(Save);
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        parstate.update(elapsed);

        @:privateAccess { //this makes it so that the main menu buttons are not usable while the settings menu is open.
			if(!done) {
				wait(0.9, ()->{
                    if (!done){
					    MainMenu.instance.Button_Play.visible = false;
					    MainMenu.instance.Button_Settings.visible = false;
					    MainMenu.instance.Button_Load.visible = false;
                    }
				});
				done = true;
			}
		}

        if(Tracers_Check != null) {
            Preferences.save.bulletTracers = Tracers_Check.checked; //* solar tf were you thinking, or was this me, i forgor..
            if(Preferences.save.bulletTracers != Tracers_Check.checked) { //only update if the save value is different from the checkbox state
                Preferences.saveSettings();
            }
        }
    }

    override public function destroy() { //force re-enable the main menu buttons.
		super.destroy();
		@:privateAccess {
            done = true;
            MainMenu.instance.Button_Play.visible = true;
            MainMenu.instance.Button_Settings.visible = true;
            MainMenu.instance.Button_Load.visible = true;
		}
	}
}