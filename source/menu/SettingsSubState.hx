package menu;

import flixel.system.FlxAssets.FlxGraphicAsset;
import substates.PauseMenuSubState;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxRainbowEffect;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import openfl.events.MouseEvent;
import flixel.addons.ui.Anchor;
import flixel.addons.ui.FlxUITooltip;
import openfl.geom.Rectangle;
import rf_flixel.addons.ui.FlxUIAssets as FlxUIAssets;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUI;
import rf_flixel.addons.ui.FlxUITabMenu as FlxUITabMenu;
import flixel.group.FlxGroup;
import Lambda;

class SettingsSubState extends FlxSubState{

    var TabGroups:FlxUITabMenu;

    var Tracers:FlxUICheckBox;
    var SkipIntro:FlxUICheckBox;
    var WaterMarks:FlxUICheckBox;
    var ShellEjection:FlxUICheckBox;

    var HCui:FlxUICheckBox;
    var SS:FlxUICheckBox;

    var Back:FlxButton;
    var Save:FlxButton;
    var Saved:Bool = false;
    var settingsCAM:FlxCamera;

    private var instance:SettingsSubState;
    private var parstate:FlxState;
    var done:Bool = false;

    var HC:Bool = false;

    public var diffigroup:FlxSpriteGroup = new FlxSpriteGroup();
    public var tooltipgroup:FlxTypedSpriteGroup<FlxUITooltip> = new FlxTypedSpriteGroup<FlxUITooltip>();

    public var DifficultiesCreated:Bool = false;

    public function new(parentState:FlxState){
        super();

        this.parstate = parentState;
        this.instance = this;

        settingsCAM = new FlxCamera();
		FlxG.cameras.add(settingsCAM, false);
		settingsCAM.bgColor = 0x000000;
    }

    public var TT0:FlxUITooltip;
    public var TT1:FlxUITooltip;
    public var TT2:FlxUITooltip;
    public var TT3:FlxUITooltip; 
    public var TT4:FlxSprite;
    public var TT4T:FlxText;
    public var TT4T2:FlxText;

    public var graphic_names:Array<FlxGraphicAsset>;
    public var slice9tab:Array<Int>;
    public var slice9_names:Array<Array<Int>>;

    override public function create() {
        Preferences.loadSettings();

        if(FlxG.save.data.High_Contrast_UI != null && FlxG.save.data.High_Contrast_UI == true){
            HC = true;
        }

        //Difficulty_00_TOOLTIP = new FlxUITooltip(200, 100, new Anchor(0, 0, "right", "top", "left", "top"));

		var tabs = [
			{name: "tab_1", label: "General"},
			{name: "tab_2", label: "Graphics"},
			{name: "tab_3", label: "Accessibility"},
			{name: "tab_4", label: "Difficulty"}
		];
        @:privateAccess
        if(FlxG.state is Playstate){
            TabGroups = new FlxUITabMenu(null, null, tabs, if(HC) true else false, null, false, null, null, true);
            if (TabGroups.length > 3) {
                // Disable the fourth tab (index 3, as arrays are 0-indexed)
                var fourthTab = TabGroups.getTab(3);
                if (fourthTab != null) {
                    // Disable the tab (make it unpressable)
                    fourthTab.active = false;
                }
            }
        }else
        TabGroups = new FlxUITabMenu(null, null, tabs, if(HC) true else false, null, false, null, null, false);
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
                var daspr = new FlxSprite(TabGroups.x + 10 + (64 * i), TabGroups.y + 10).loadGraphic(Assets.image('game/settings/DIFF_POSTERS_SETTINGS'), true, 64, 100);
                daspr.animation.add(anim[i], [i], 1, true, false, false);
                daspr.animation.play(anim[i]);
                diffigroup.add(daspr);
                var daCheckBox = new FlxUICheckBox(0, 0, null, null, '', 0, null, GetCheckBoxDataResult(i));
                daCheckBox.setPosition(TabGroups.x + 32 + (65 * i), TabGroups.y + 110);
                diffigroup.add(daCheckBox);
                var label = new FlxText(0, 0, 0, label[i]);
                label.setPosition(TabGroups.x + 12 + (65 * i), daCheckBox.y + 15);
                diffigroup.add(label);

                var tooltip = new FlxUITooltip(200, 100, createAnchor(i));
                tooltipgroup.add(tooltip);
            }
            diffigroup.members[10].x += 0.5; //hard mode checkbox pos fix *band-aid fix*




        Save = new FlxButton(TabGroups.x + 400, TabGroups.y + 246.7, "SAVE", function() { FlushToPrefs(); });
        Back = new FlxButton(Save.x + 80, TabGroups.y + 246.7, "X", function() { close(); });
        Back.loadGraphic("assets/ui/buttonSQR.png", true, 20, 20);
        Back.label.fieldWidth = 20;

        add(TabGroups);
        add(Back);
        add(Save);

        LoadFromPrefs();

        if(HC){
            for(i in this.members){
                var item = cast i;
                if(Std.isOfType(item, FlxButton)){
                    var spr:FlxSprite = cast item;
                    spr.loadGraphic("assets/ui/buttonHC.png", true, 80, 20);
                }
            }
            Back.loadGraphic('assets/ui/buttonSQRHC.png', true, 20, 20);
            Back.label.fieldWidth = 20;
        }
        DifficultiesCreated = true;
        TT0 = tooltipgroup.members[0];
        TT1 = tooltipgroup.members[1];
        TT2 = tooltipgroup.members[2];
        TT3 = tooltipgroup.members[3];
        tooltipgroup.members[4].kill();
        
        TT4 = new FlxSprite(500, 0).makeGraphic(780, 720, FlxColor.BLACK);
        TT4.alpha = 0.5;
        add(TT4);
        TT4T = new FlxText(500, 0, 0, "", 12, true);
        TT4T.setFormat(null, 14, FlxColor.WHITE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        add(TT4T);
        TT4T2 = new FlxText(500, -20, 0, "", 12, true);
        TT4T2.setFormat(null, 14, FlxColor.WHITE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        add(TT4T2);

        graphic_names = [FlxUIAssets.IMG_TAB_DISABLED];
        slice9tab = FlxStringUtil.toIntArray(FlxUIAssets.SLICE9_TAB);
        slice9_names = [slice9tab, slice9tab, slice9tab, slice9tab, slice9tab, slice9tab]; //for the tab disabling on playstate so difficulty cant be changed mid-game

        for(item in this.members){
            item.camera = settingsCAM;
            if(Std.isOfType(item, FlxSprite) || Std.isOfType(item, FlxUITooltip)) {
                var daSpr:FlxSprite = cast item;
                daSpr.scrollFactor.set();
            }
        }
    }
    private function createAnchor(Cur:Int):Anchor{
        switch(Cur){
            case 2:
                return new Anchor(0, 0, "right", "top", "left", "top");
            case 3:
                return new Anchor(0, 0, "left", "top", "right", "top");
            default:
                return new Anchor(0, 0, "right", "top", "left", "top");
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
        'For people new to top down shooters\n
Enemy Damage -50%
Player Damage +75%
Ammo pickups +50% ammo
Enemy Speed -15%
Player Speed +25%
Oxygen doesnt drain
battery takes 50% less impact
Ammo pickups are more common
Enemies spawn less
Game Autosaves At every door and every 5 minutes
achivements are disabled
\"Aw, wook at the wittel baby!\"\n--asdfmovie8 2014', //0
        'For people who have played some top down shooters\n
Enemy Damage -25%
Player Damage +25%
Ammo pickups +5% ammo
Enemy Speed -5%
Player Speed +10%
Oxygen Drains 50% slower
Battery takes 25% less impact
Ammo pickups spawn slightly more
Enemies spawn slightly less
Game Autosaves at every door and every 10 minutes
Quote:\"...\"\n--CaveStory+ 2011', //1
        'The definitive way to enjoy Relocation-Failed
Game Autosaves at every door and every 15 minutes\n
TBA
TBA
TBA
TBA
TBA
', //2
        'For those wanting a challenge\n
TBA
Game autosaves every 20 minutes;
        ', //3
        'For those wanting to fight the gods themselves\n
Enemies do +75% damage, player does -15% damage
Enemies move +50% faster, player moves -12% slower
Ammo spawns incredibly rarely, conserve it, guns must be reloaded
Enemies can hear your footsteps, enemies can see your flashlight beam
Guns have a 12% chance to jam with every shot
Shotgun must be manually pumped, weapons have durability, fog of war is enabled
Stamina Drains 25% faster, oxygen drains 75% faster, battery takes 75% more impact
player will bleed if hit with an enemy melee attack
----------------------------------------------------
Game doesnt autosave
Backtracking is completely disabled, if you miss an item, you\'re ${if(FlxG.save.data.AdultMode != null && FlxG.save.data.AdultMode == true) 'fucked.\nGame will openly insult you if you die.' else 'done.'}
Your save will be deleted if you die' //4
    ];
    public var checksactivity:Array<Bool> = [];
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
        if(DifficultiesCreated == true){
            for(tooltip in tooltipgroup.members){
                if(Std.isOfType(tooltip, FlxUITooltip)){
                    if(Lambda.exists([for (i in 0...3) diffigroup.members[i]], obj -> FlxG.mouse.overlaps(obj)) && TabGroups.selected_tab_id == 'tab_4'){
                        if(!TT0.visible && !TT0.active){
                            TT0.show(diffigroup.members[1], tooltipgroupvar_title[0], tooltipgroupvar_body[0], true, false, true);
                            @:privateAccess
                            TT0._bodyText.fieldWidth = 200;
                        }
                    }else{
                        if(TT0.visible && TT0.active){
                            TT0.hide();
                        }
                    } //baby mode tooltip

                    if(Lambda.exists([for (i in 3...6) diffigroup.members[i]], obj -> FlxG.mouse.overlaps(obj)) && TabGroups.selected_tab_id == 'tab_4'){
                        if(!TT1.visible && !TT1.active){
                            TT1.show(diffigroup.members[4], tooltipgroupvar_title[1], tooltipgroupvar_body[1], true, false, true);
                            @:privateAccess
                            TT1._bodyText.fieldWidth = 200;
                        }
                    }else{
                        if(TT1.visible && TT1.active){
                            TT1.hide();
                        }
                    } //easy mode tooltip

                    if(Lambda.exists([for (i in 6...9) diffigroup.members[i]], obj -> FlxG.mouse.overlaps(obj)) && TabGroups.selected_tab_id == 'tab_4'){
                        if(!TT2.visible && !TT2.active){
                            TT2.show(diffigroup.members[7], tooltipgroupvar_title[2], tooltipgroupvar_body[2], true, false, true);
                            @:privateAccess
                            TT2._bodyText.fieldWidth = 200;
                        }
                    }else{
                        if(TT2.visible && TT2.active){
                            TT2.hide();
                        }
                    } //normal mode tooltip

                    if(Lambda.exists([for (i in 9...12) diffigroup.members[i]], obj -> FlxG.mouse.overlaps(obj)) && TabGroups.selected_tab_id == 'tab_4'){
                        if(!TT3.visible && !TT3.active){
                            TT3.show(diffigroup.members[10], tooltipgroupvar_title[3], tooltipgroupvar_body[3], true, false, true);
                            @:privateAccess
                            TT3._bodyText.fieldWidth = 200;
                        }
                    }else{
                        if(TT3.visible && TT3.active){
                            TT3.hide();
                        }
                    } //hard mode tooltip

                    if(Lambda.exists([for (i in 12...14) diffigroup.members[i]], obj -> FlxG.mouse.overlaps(obj)) && TabGroups.selected_tab_id == 'tab_4'){
                        if(!TT4.visible && !TT4T.visible && !TT4T2.visible){
                            TT4.visible = true;
                            TT4T.visible = true;
                            TT4T2.visible = true;
                            if(TT4T.text == '')
                                TT4T.text = tooltipgroupvar_title[4];
                            if(TT4T2.text == '')
                                TT4T2.text = tooltipgroupvar_body[4];
                        }
                    }else{
                        if(TT4.visible && TT4T.visible && TT4T2.visible){
                            TT4.visible = false;
                            TT4T.visible = false;
                            TT4T2.visible = false;
                        }
                    } //hardcore tooltip
                }
            }
            for(object in diffigroup.members){
                if(Std.isOfType(object, FlxUICheckBox)){
                    var checkbox:FlxUICheckBox = cast object;
                        if(FlxG.save.data.Difficulty != ''){
                            var difficultySplit:String = FlxG.save.data.Difficulty;
                            //trace('${difficultySplit.split(',')[0]}, ${difficultySplit.split(',')[1]}'); //bogs the console, keep disabled
                            if(checkbox.ID == Std.parseInt(difficultySplit.split(',')[1])){
                                checkbox.checked = true;
                            }//TODO: add fallback for difficulty selection to automatically select normal mode if a difficulty is not selected or found from the save file
                        }//else{
                        //    if(FlxG.save.data.Difficulty == ''){
                        //        if(difficultySelectedCheck()){
                        //            if(checkbox.ID == 0){
                        //                checkbox.checked = true;
                        //            }
                        //        }
                        //    }
                        //}
                }
            }
        }
    }
    //private function difficultySelectedCheck():Bool {
    //    for(object in diffigroup.members){
    //        if(Std.isOfType(object, FlxUICheckBox)){
    //            var check:FlxUICheckBox = cast object;
    //            if(!check.checked){
    //                if(checksactivity.length < 5)
    //                    checksactivity.push(false);
    //            }else{
    //                if(checksactivity.length < 5)
    //                    checksactivity.push(true);
    //            }
    //        }
    //        trace(checksactivity.toString());
    //    }
    //    switch(checksactivity.toString()){
    //        case "false, false, false, false, false":
    //            return true;
    //        default:
    //            return false; //false == good, true == bad
    //    }
    //}

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