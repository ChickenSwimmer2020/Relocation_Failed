package menu;

import flixel.addons.ui.Anchor;
import flixel.addons.ui.FlxUITooltip;
import openfl.geom.Rectangle;
import rf_flixel.addons.ui.FlxUIAssets as FlxUIAssets;
import flixel.addons.ui.FlxUI9SliceSprite;
import rf_flixel.ui.FlxSquareButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUI;
import rf_flixel.addons.ui.FlxUITabMenu as FlxUITabMenu;

class SettingsSubState extends FlxSubState{
    var TabGroups:FlxUITabMenu;

    var Tracers:FlxUICheckBox;
    var SkipIntro:FlxUICheckBox;
    var WaterMarks:FlxUICheckBox;
    var ShellEjection:FlxUICheckBox;

    var HCui:FlxUICheckBox;
    var SS:FlxUICheckBox;



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

    var HC:Bool = false;

    public var diffigroup:FlxSpriteGroup = new FlxSpriteGroup();
    public var tooltipgroup:FlxSpriteGroup = new FlxSpriteGroup();

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

        if(FlxG.save.data.High_Contrast_UI != null && FlxG.save.data.High_Contrast_UI == true){
            HC = true;
        }

        Difficulty_00_TOOLTIP = new FlxUITooltip(200, 100, new Anchor(0, 0, "right", "top", "left", "top"));

		var tabs = [
			{name: "tab_1", label: "General"},
			{name: "tab_2", label: "Graphics"},
			{name: "tab_3", label: "Accessibility"},
			{name: "tab_4", label: "Difficulty"}
		];
        TabGroups = new FlxUITabMenu(null, tabs, if(HC) true else false, true);
        TabGroups.resize(TabGroups.width + 55, TabGroups.height);
        
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
            var Tab1BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, if(HC) FlxUIAssets.IMG_CHROME_HIGHCONTRAST else FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab1BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, if(HC) FlxUIAssets.IMG_CHROME_INSET_HIGHCONTRAST else FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_1.add(Tab1BG1);
            tab_group_1.add(Tab1BG2);
            SkipIntro = new FlxUICheckBox(10, 10, null, null, 'Skip Intro');
            WaterMarks = new FlxUICheckBox(10, 70, null, null, 'Skip WaterMarks');
            tab_group_1.add(SkipIntro);
            tab_group_1.add(WaterMarks);

        //* tab group 2 -- Graphics
            var Tab2BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, if(HC) FlxUIAssets.IMG_CHROME_HIGHCONTRAST else FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab2BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, if(HC) FlxUIAssets.IMG_CHROME_INSET_HIGHCONTRAST else FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            Tracers = new FlxUICheckBox(10, 40, null, null, 'Bullet Tracers');
            ShellEjection = new FlxUICheckBox(10, 70, null, null, 'Shell Ejection');
            tab_group_2.add(Tab2BG1);
            tab_group_2.add(Tab2BG2);
            tab_group_2.add(Tracers);
            tab_group_2.add(ShellEjection);

        //* tab groupd 3 -- Accessibility
            var Tab3BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, if(HC) FlxUIAssets.IMG_CHROME_HIGHCONTRAST else FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab3BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, if(HC) FlxUIAssets.IMG_CHROME_INSET_HIGHCONTRAST else FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            HCui = new FlxUICheckBox(10, 10, null, null, 'High Contrast UI');
            SS = new FlxUICheckBox(10, 30, null, null, 'ScreenShake');
            tab_group_3.add(Tab3BG1);
            tab_group_3.add(Tab3BG2);
            tab_group_3.add(HCui);
            tab_group_3.add(SS);

        //* tab group 4 -- Difficulty
            var Tab4BG1:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x, TabGroups.y, if(HC) FlxUIAssets.IMG_CHROME_HIGHCONTRAST else FlxUIAssets.IMG_CHROME, new Rectangle(TabGroups.x, TabGroups.y, 500, 250));
            var Tab4BG2:FlxUI9SliceSprite = new FlxUI9SliceSprite(TabGroups.x + 5, TabGroups.y + 5, if(HC) FlxUIAssets.IMG_CHROME_INSET_HIGHCONTRAST else FlxUIAssets.IMG_CHROME_INSET, new Rectangle(TabGroups.x + 5, TabGroups.y + 5, 490, 225));
            tab_group_4.add(Tab4BG1);
            tab_group_4.add(Tab4BG2);
            tab_group_4.add(diffigroup);
            tab_group_4.add(tooltipgroup);
            var difficulties:Array<Int> = [0,1,2,3,4];
            var anim:Array<String> = ['BABY', 'EASY', 'NORMAL', 'HARD', 'HARDCORE'];
            var label:Array<String> = ['Baby Mode', 'Easy Mode', 'Normal Mode', '  Hard Mode', 'HardCore'];
            for(i in 0...difficulties.length){
                var daspr:FlxSprite = cast(new FlxSprite(TabGroups.x + 10 + (64 * i), TabGroups.y + 10).loadGraphic(Assets.image('game/settings/DIFF_POSTERS_SETTINGS'), true, 64, 100));
                daspr.animation.add(anim[i], [i], 1, true, false, false);
                daspr.animation.play(anim[i]);
                diffigroup.add(daspr);
                var daCheckBox:FlxUICheckBox = cast(new FlxUICheckBox(0, 0, null, null, '', 0, null, GetCheckBoxDataResult(i)));
                daCheckBox.setPosition(TabGroups.x + 32 + (64 * i), TabGroups.y + 110);
                daCheckBox.ID = i;
                diffigroup.add(daCheckBox);
                var label:FlxText = cast(new FlxText(0, 0, 0, label[i]));
                label.setPosition(TabGroups.x + 12 + (65 * i), daCheckBox.y + 15);
                diffigroup.add(label);

                //tooltips oh boy...
                var tooltip:FlxUITooltip = cast(new FlxUITooltip(200, 100, new Anchor(0, 0, "right", "top", "left", "top")));
                tooltipgroup.add(tooltip); //should create 5 different tooltips?
            }
            diffigroup.members[10].x += 5; //hard mode checkbox pos fix *band-aid fix*



        Save = new FlxButton(TabGroups.x + 400, TabGroups.y + 246.7, "SAVE", function() { FlushToPrefs(); });
        Back = new FlxSquareButton(Save.x + 80, TabGroups.y + 246.7, "X", function() { close(); });
        if(HC) Back.loadGraphic('assets/ui/buttonSQRHC.png', true, 20, 20);

        add(TabGroups);
        add(Back);
        add(Save);

        //add(Difficulty_00_TOOLTIP);

        for(item in this.members){
            item.camera = settingsCAM;
            if(Std.isOfType(item, FlxSprite) || Std.isOfType(item, FlxUITooltip)) {
                var daSpr:FlxSprite = cast item;
                daSpr.scrollFactor.set();
            }
        }
        LoadFromPrefs();

        if(HC){
            for(i in this.members){
                var item = cast i;
                if(Std.isOfType(item, FlxButton)){
                    var spr:FlxSprite = cast item;
                    spr.loadGraphic("assets/ui/buttonHC.png", true, 80, 20);
                }
            }
        }
    }
    private function GetCheckBoxDataResult(Check:Int):Void->Void{
        switch(Check){
            case 0:
                return ()->{
                    trace('Difficulty is now baby mode');
                    Preferences.save.Difficulty = 'baby,0';
                    Preferences.saveSettings();
                    for(object in diffigroup.members){
                        if(Std.isOfType(object, FlxUICheckBox)){
                            var checkbox:FlxUICheckBox = cast object;
                            if(checkbox.ID != 0){
                                checkbox.checked = false;
                            }
                        }
                    }
                };
            case 1:
                return ()->{
                    trace('Difficulty is now easy mode');
                    Preferences.save.Difficulty = 'easy,1';
                    Preferences.saveSettings();
                    for(object in diffigroup.members){
                        if(Std.isOfType(object, FlxUICheckBox)){
                            var checkbox:FlxUICheckBox = cast object;
                            if(checkbox.ID != 1){
                                checkbox.checked = false;
                            }
                        }
                    }
                };
            case 2:
                return ()->{
                    trace('Difficulty is now normal mode');
                    Preferences.save.Difficulty = 'norm,2';
                    Preferences.saveSettings();
                    for(object in diffigroup.members){
                        if(Std.isOfType(object, FlxUICheckBox)){
                            var checkbox:FlxUICheckBox = cast object;
                            if(checkbox.ID != 2){
                                checkbox.checked = false;
                            }
                        }
                    }
                };
            case 3:
                return ()->{
                    trace('Difficulty is now hard mode');
                    Preferences.save.Difficulty = 'hard,3';
                    Preferences.saveSettings();
                    for(object in diffigroup.members){
                        if(Std.isOfType(object, FlxUICheckBox)){
                            var checkbox:FlxUICheckBox = cast object;
                            if(checkbox.ID != 3){
                                checkbox.checked = false;
                            }
                        }
                    }
                };
            case 4:
                return ()->{
                    trace('Difficulty is now hardcore');
                    Preferences.save.Difficulty = 'hrd2,4';
                    Preferences.saveSettings();
                    for(object in diffigroup.members){
                        if(Std.isOfType(object, FlxUICheckBox)){
                            var checkbox:FlxUICheckBox = cast object;
                            if(checkbox.ID != 4){
                                checkbox.checked = false;
                            }
                        }
                    }
                };
            default:
                return ()->{trace('Difficulty is not recognized');};
        }
    }
    public var tooltipgroupvar_title:Array<String> = [
        'baby mode', //0
        'easy mode', //1
        'normal mode', //2
        'hard mode', //3
        'hardcore' //4
    ];
    public var tooltipgroupvar_body:Array<String> = [
        'test1', //0
        'test2', //1
        'test3', //2
        'test4', //3
        'test5' //4
    ];
    override public function update(elapsed:Float) {
        super.update(elapsed);
        parstate.update(elapsed);

        /**
            oh boy, this gets complex quickly...
            OKAY, so. essentially since i did a group system it works like this.
            diffigroup.members[0] == baby mode image object
            diffigroup.members[1] == baby mode checkbox object
            diffigroup.members[2] == baby mode label object

            diffigroup.members[3] == easy mode image object
            diffigroup.members[4] == easy mode checkbox object
            diffigroup.members[5] == easy mode label object

            diffigroup.members[6] == normal mode image object
            diffigroup.members[7] == normal mode checkbox object
            diffigroup.members[8] == normal mode label object

            diffigroup.members[9] == hard mode image object
            diffigroup.members[10] == hard mode checkbox object
            diffigroup.members[11] == hard mode label object

            diffigroup.members[12] == hardcore mode image object
            diffigroup.members[13] == hardcore mode checkbox object
            diffigroup.members[14] == hardcore mode label object

            X4 for every difficulty.
        **/

        for(object in diffigroup.members){
            if(Std.isOfType(object, FlxUITooltip)){

            }
            if(Std.isOfType(object, FlxUICheckBox)){
                var checkbox:FlxUICheckBox = cast object;
                    if(FlxG.save.data.Difficulty != ''){
                        var difficultySplit:String = FlxG.save.data.Difficulty;
                        trace('${difficultySplit.split(',')[0]}, ${difficultySplit.split(',')[1]}');
                        if(checkbox.ID == Std.parseInt(difficultySplit.split(',')[1])){
                            checkbox.checked = true;
                        }
                    }else{
                        if(difficultySelectedCheck()){
                            if(checkbox.ID == 0){
                                checkbox.checked = true;
                            }
                        }
                    }
            }
            //TODO: fix the difficulty tooltips stuff
        }

        //for(object in diffigroup.members){ //! old code, unoptimized but contains original text. do not remove
        //    if((FlxG.mouse.overlaps(diffigroup.members[0]) || FlxG.mouse.overlaps(diffigroup.members[1])) || FlxG.mouse.overlaps(diffigroup.members[2])){ //better way to do this?
        //        if (TabGroups.selected_tab_id == 'tab_4') {
        //            if(!Difficulty_00_TOOLTIP.visible && !Difficulty_00_TOOLTIP.active){
        //            Difficulty_00_TOOLTIP.show(diffigroup.members[2], 'Baby Mode',
        //                'For people new to top down shooters\n
        //    Enemy Damage -50%, Player Damage +75%\n
        //    Ammo pickups +50% ammo\n
        //    Enemy Speed -15%, Player Speed +25%\n
        //    Oxygen doesnt drain, battery takes 50% less impact\n
        //    Ammo pickups are more common\n
        //    Enemies spawn less\n
        //    Game Autosaves At every door and every 5 minutes\n
        //    achivements are disabled\n
        //    \"Aw, wook at the wittel baby!\"\n--asdfmovie8 2014',
        //                true, false, true);
        //                @:privateAccess
        //                    Difficulty_00_TOOLTIP._bodyText.fieldWidth = 200;
        //            }
        //        } else {
        //            if(Difficulty_00_TOOLTIP.visible && Difficulty_00_TOOLTIP.active)
        //                Difficulty_00_TOOLTIP.hide();
        //        }
        //    }
        //}
    }
    private function difficultySelectedCheck():Bool {
        var checksactivity:Array<Bool> = [false, false, false, false, false];
        for(object in diffigroup.members){
            if(Std.isOfType(object, FlxUICheckBox)){
                var check:FlxUICheckBox = cast object;
                if(!check.checked){
                    checksactivity.push(false);
                }else{
                    checksactivity.push(true);
                }
            }
        }
        switch(checksactivity.toString()){
            case "[false, false, false, false, false]":
                return true;
            default:
                return false; //false == good, true == bad
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
        if(Preferences.save.High_Contrast_UI != HCui.checked) {
            Preferences.save.High_Contrast_UI = HCui.checked;
            Preferences.saveSettings();
        }
        if(Preferences.save.ScreenShake != SS.checked) {
            Preferences.save.ScreenShake = SS.checked;
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

        if(FlxG.save.data.SkipWaterMarks != null) {
            WaterMarks.checked = FlxG.save.data.SkipWaterMarks;
        }else{
            WaterMarks.checked = false;
            FlxG.save.data.SkipWaterMarks = false;
        }

        if(FlxG.save.data.ShellEjection != null) {
            ShellEjection.checked = FlxG.save.data.ShellEjection;
        }else{
            ShellEjection.checked = false;
            FlxG.save.data.ShellEjection = false;
        }

        if(FlxG.save.data.High_Contrast_UI != null) {
            HCui.checked = FlxG.save.data.High_Contrast_UI;
        }else{
            HCui.checked = false;
            FlxG.save.data.High_Contrast_UI = false;
        }

        if(FlxG.save.data.ScreenShake != null) {
            SS.checked = FlxG.save.data.ScreenShake;
        }else{
            SS.checked = false;
            FlxG.save.data.ScreenShake = false;
        }
    }
}