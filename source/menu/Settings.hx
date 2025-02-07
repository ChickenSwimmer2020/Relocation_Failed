package menu;

import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxSlider;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;

class Settings extends FlxState{
    var TabGroups:FlxUITabMenu;
    var Tracers_Check:FlxUICheckBox;
    var Back:FlxButton;
    var volume:Float = 0;
    var Saved:Bool = false;

    override public function create() {
		var tabs = [
			{name: "tab_1", label: "test1"},
			{name: "tab_2", label: "test2"},
			{name: "tab_3", label: "test3"},
			{name: "tab_4", label: "test4"}
		];
        TabGroups = new FlxUITabMenu(null, tabs, true);
        var sliderRate = new FlxUISlider(this, 'volume', 10, 10, 0.5, 3, 150, 15, 5, FlxColor.WHITE, FlxColor.BLACK);
		sliderRate.nameLabel.text = 'Volume';

        Tracers_Check = new FlxUICheckBox(10, 20, null, null, 'Bullet Tracers');

		var tab_group_1 = new FlxUI(null, TabGroups, null);
        tab_group_1.name = 'tab_1';
		tab_group_1.add(sliderRate);
        tab_group_1.add(Tracers_Check);
        TabGroups.addGroup(tab_group_1);

        Back = new FlxButton(0, 0, "Back", function() {FlxG.switchState(menu.MainMenu.new);});
        Back.screenCenter(X);

        add(TabGroups);
        add(Back);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(Tracers_Check != null) {
            Preferences.save.bulletTracers = Tracers_Check.checked; //* solar tf were you thinking, or was this me, i forgor..
            if(Preferences.save.bulletTracers != Tracers_Check.checked) { //only update if the save value is different from the checkbox state
                Preferences.saveSettings();
            }
        }
    }
}