package menu;

import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxSlider;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;

class Settings extends FlxState{
    var TabGroups:FlxUITabMenu;
    var Back:FlxButton;
    var volume:Float = 0;

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
		var tab_group_1 = new FlxUI(null, TabGroups, null);
        tab_group_1.name = 'tab_1';
		tab_group_1.add(sliderRate);
        TabGroups.addGroup(tab_group_1);

        Back = new FlxButton(0, 0, "Back", function() {FlxG.switchState(new menu.MainMenu());});
        Back.screenCenter(X);

        add(TabGroups);
        add(Back);
    }
}