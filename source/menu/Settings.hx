package menu;

import flixel.addons.ui.FlxUIRadioGroup;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import rf_flixel.ui.FlxButton; //import our custom button class instead of the base one so i can change the size of the font

class Settings extends FlxState{
    var TabGroups:FlxUITabMenu;
    var Back:FlxButton;

    override public function create() {
		var tabs = [
			{name: "tab_1", label: "test1"},
			{name: "tab_2", label: "test2"},
			{name: "tab_3", label: "test3"},
			{name: "tab_4", label: "test4"}
		];
        TabGroups = new FlxUITabMenu(null, tabs, true);
        var tabs_radio_1 = new FlxUIRadioGroup(10, 10, ["test1", "test2", "test3", "test4"], ["Test Button 1", "Test Button 2", "Test Button 3", "Test Button 4"]);

		var tab_group_1 = new FlxUI(null, TabGroups, null);
		tab_group_1.add(tabs_radio_1);

        Back = new FlxButton(0, 0, "Back", 8, function() {FlxG.switchState(new menu.MainMenu());});
        Back.screenCenter(X);

        add(TabGroups);
        add(Back);
    }
}