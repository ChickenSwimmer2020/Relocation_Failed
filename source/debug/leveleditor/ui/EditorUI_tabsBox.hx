package debug.leveleditor.ui;

import flixel.math.FlxPoint;

typedef TabBoxOptions = {
    ?tabsAlign:Float
}

class EditorUITABBOX extends FlxSpriteGroup{
    public var tabs:Array<{spr:FlxSprite, name:String}> = [];
    public var currentActiveTab:String = '';
    public var tbmnu:Array<FlxSpriteGroup> = [];


    /**
     * create a new instance of a RFUI tab menu
     * @param x menu X position
     * @param y menu Y position
     * @param width menu width
     * @param height menu height
     * @param TabsNames the names of the tabs. also functions as how many tabs to make.
     * @param TabsMenus the actual groups of items for the tabs. created externally in the parent state because they cant be made in here.
     * @param verticalTabs //does the menu use vertical tabs instead of horizontal tabs?
     */
    public function new(?Options:TabBoxOptions, x:Float, y:Float, width:Float, height:Float, TabsNames:Array<String>, TabsMenus:Array<FlxSpriteGroup>, ?verticalTabs:Bool = false){ //TODO: add vertical tabs support.
        super(x, y);

        var bgSpr:FlxSprite = new FlxSprite(0, 0, null).makeGraphic(cast width, cast height, FlxColor.GRAY);
        add(bgSpr);

        currentActiveTab = TabsNames[0]; //set the default to prevent crashes.
        tbmnu = TabsMenus; //get the tabs

        for(i in 0...TabsNames.length){
            var tab:FlxSprite = new FlxSprite(0, 0, null).makeGraphic(cast bgSpr.width / TabsNames.length, 20, FlxColor.fromString("0xFF4F4F4F"));
            tab.x = x + bgSpr.width / TabsNames.length * i;
            if(Options != null){
                if(Options.tabsAlign != null){
                    tab.y = Options.tabsAlign;
                }
            }else{
                tab.y -= 20;
            }
            tab.updateHitbox();
            add(tab);
            tabs.push({spr:tab, name:TabsNames[i]});
            //trace(tabs);


            var tabText:FlxText = new FlxText(tab.x, 0 -20, cast bgSpr.width / TabsNames.length, TabsNames[i], 12, true);
            tabText.setFormat(null, 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
            if(Options != null){
                if(Options.tabsAlign != null){
                    tabText.y = Options.tabsAlign;
                }
            }else{
                tabText.y - 20;
            }
            insert(members.indexOf(tab) + 1, tabText);
        }
        for(i in 0...TabsMenus.length){
            add(TabsMenus[i]); //create the groups so they actually render
        }
    }
    override public function update(elapsed:Float):Void{
        super.update(elapsed);
        FlxG.watch.addQuick('activeTab: ', currentActiveTab);
        for(i in 0...tabs.length){
            var tab:FlxSprite = tabs[i].spr;
            var tabText:FlxText = cast members[members.indexOf(tab) + 1];
            if(currentActiveTab == tabs[i].name){
                tab.color = FlxColor.LIME;
                tabText.color = FlxColor.BLACK;
                if(tbmnu[i] != null && tbmnu[i].exists){ //should work? probably wont knowing me.
                    tbmnu[i].visible = true; //holy fuck it actually worked!
                    tbmnu[i].active = true;
                    for(j in 0...tbmnu.length){
                        if(j != i){
                            tbmnu[j].visible = false;
                            tbmnu[j].active = false; //* switch from `visible` to `active` so that the items in tab-groups cant be used at all. might cause issues but hopefully not.
                        }
                    }
                }
                if(tab.scale.x < 1 && tab.scale.y < 1){ //check scale and fix it if its not 1.
                    tab.scale.set(1, 1);
                }
            }else{ //prevent the detection of mouse position when your on the current tab.
                if(tab.overlapsPoint(FlxG.mouse.getViewPosition(), true, tabs[i].spr.camera)){
                    tab.color = FlxColor.CYAN;
                    tabText.color = FlxColor.BLACK;
                    if(FlxG.mouse.justPressed){
                        tab.scale.set(0.8, 0.8);
                        //trace("Tab " + tabs[i].name + " clicked!");
                        currentActiveTab = tabs[i].name; //set the current active tab to current clicked one.
                    }
                }else{
                    tab.color = FlxColor.WHITE;
                    tabText.color = FlxColor.WHITE;
                }
                if(FlxG.mouse.justReleased){ //auto reset the scale when mouse is released
                    if(tab.scale.x < 1 && tab.scale.y < 1){
                        tab.scale.set(1, 1);
                    }
                }
            }

        }
    }
}