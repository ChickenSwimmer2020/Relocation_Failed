package debug;

using StringTools;

class ChooseEditor extends FlxState {
    override public function create() {
        super.create();
        var text:FlxText = new FlxText(0, 0, 0, "Choose Editor", 24, true);
        text.setFormat(null, 24, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        add(text);

        var editors:Array<String> = [
'Level Editor',
'AI Editor',
'NPC Editor',
'Item Editor',
'Anim Offset',
'Weapon Editor'];
        for(i in 0...editors.length){
            var btn:FlxButton = new FlxButton(0, if(i == 0) 20 else 20 * i, editors[i], function() {
                trace("Switching to " + editors[i]);
                FlxG.switchState(()->new debug.leveleditor.Editor.EditorState(editors[i].substr(0, editors[i].length - 7)));
            });
            if(i >= 1) btn.y += 20;
            btn.screenCenter(X);
            add(btn);
        }
    }
}