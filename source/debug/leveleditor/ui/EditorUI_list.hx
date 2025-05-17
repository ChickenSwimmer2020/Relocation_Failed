package debug.leveleditor.ui;

import backend.level.LevelLoader.LevelObject;
import openfl.net.FileReference;
import sys.FileSystem;
import flixel.text.FlxInputText;
import openfl.Assets;
import tjson.TJSON;
import flixel.math.FlxRect;
import debug.leveleditor.ui.EditorUI_button.EditorUIButton;

typedef ListLabelParams = {
    fieldwidth:Float,
    text:String,
    size:Int,
} 

typedef ListParams = {
    width:Float,
    height:Float,
    textP:ListLabelParams
} 

class EditorUIList extends FlxSpriteGroup{
    private var background:FlxSprite;
    private var label:FlxText;
    private var clearbutton:EditorUIButton;
    private var upButtn:EditorUIButton;
    private var dwnButtn:EditorUIButton;
    private var lodButtn:EditorUIButton;
    private var savButtn:EditorUIButton;
    private var levelobjectsarray:Array<LevelObject> = [];
    private var importedObjects:Array<LevelObject> = [];
    public var list:Array<ListObject> = [];

    public function new(x:Float, y:Float, p:ListParams){
        super(x, y);
        background = new FlxSprite(0,0).makeGraphic(1, 1, FlxColor.GRAY);
        background.setGraphicSize(p.width, p.height);
        background.updateHitbox();
        add(background);
        
        label = new FlxText(0, 0, p.textP.fieldwidth, p.textP.text, p.textP.size, true);

        clearbutton = new EditorUIButton(background.width - 50, 0, ()->{clearList();}, {
            width: 50,
            height: 12.5,
            text: 'clear',
            textSize: 8,
            textBaseColor: FlxColor.WHITE,
            alpha: 0.5,
            baseColor: FlxColor.BLACK,
            hoverColor: FlxColor.CYAN,
            clickColor: FlxColor.RED
        });

        add(label);
        add(clearbutton);

        upButtn = new EditorUIButton(background.width - 50 - 12.5, 0, ()->{}, {
            width: 12.5,
            height: 12.5,
            text: '<',
            textSize: 8,
            alpha: 0.25,
            textBaseColor: FlxColor.WHITE,
            baseColor: FlxColor.BLACK,
            hoverColor: FlxColor.BLACK,
            clickColor: FlxColor.BLACK
        });
        upButtn.txt.angle = 90;
        dwnButtn = new EditorUIButton(background.width - 50 - 25, 0, ()->{}, {
            width: 12.5,
            height: 12.5,
            text: '<',
            textSize: 8,
            alpha: 0.25,
            textBaseColor: FlxColor.WHITE,
            baseColor: FlxColor.BLACK,
            hoverColor: FlxColor.BLACK,
            clickColor: FlxColor.BLACK
        });
        dwnButtn.txt.angle = -90;

        add(upButtn);
        add(dwnButtn);

        lodButtn = new EditorUIButton(background.width - 50 - 25 - 50, 0, ()->{SelectObjectFile();}, {
            width: 50,
            height: 12.5,
            text: 'Load',
            textSize: 8,
            alpha: 0.25,
            textBaseColor: FlxColor.WHITE,
            baseColor: FlxColor.BLACK,
            hoverColor: FlxColor.BLACK,
            clickColor: FlxColor.BLACK
        });
        add(lodButtn);

        savButtn = new EditorUIButton(background.width - 50 - 25 - 100, 0, ()->{generateObjectsFile(null, null);}, {
            width: 50,
            height: 12.5,
            text: 'Save',
            textSize: 8,
            alpha: 0.25,
            textBaseColor: FlxColor.WHITE,
            baseColor: FlxColor.BLACK,
            hoverColor: FlxColor.BLACK,
            clickColor: FlxColor.BLACK
        });
        add(savButtn);
    }

    public function addObjectToList(obj:ListObject, ActualObject:LevelObject){
        if(obj != null)
            list.push(obj);

        if(ActualObject != null)
            levelobjectsarray.push(ActualObject);
    }

    public function generateObjectsFile(Data:Dynamic, Reference:Dynamic){
        var fr:FileReference = new FileReference();
        var objects:String = '';
        var metadata:String = '"Meta":{
        "0": "Generated with the RF:LE",
        "1": "V${Application.current.meta.get('version')}"
    }';
        var filedata:String = '{
    ${metadata},
    "Data":[\n';
        for(object in 0...levelobjectsarray.length){
            objects += '       {"Name":"${levelobjectsarray[object].Name}","Graphic":"${levelobjectsarray[object].IMG}","alpha":${levelobjectsarray[object].Alpha},"XYZ":[${levelobjectsarray[object].X},${levelobjectsarray[object].Y},${levelobjectsarray[object].Z}],"Scale":[${levelobjectsarray[object].ScaleX},${levelobjectsarray[object].ScaleY}],"Scrollfactor":[${levelobjectsarray[object].SFX},${levelobjectsarray[object].SFY}],"Visible":${levelobjectsarray[object].VIS},"DoubleAxisCollide":${levelobjectsarray[object].DoubleAxisCollide},"TripleAxisCollide":${levelobjectsarray[object].TripleAxisCollide},"IndentationPixels":${levelobjectsarray[object].IndentationPixels},"DynamicTranparency":${levelobjectsarray[object].DynamicTranparency},"IsBackground":${levelobjectsarray[object].IsBackground},"RenderOverPlayer":${levelobjectsarray[object].RenderBehindPlayer},"RenderBehindPlayer":${levelobjectsarray[object].RenderBehindPlayer},"IsAnimated":${levelobjectsarray[object].IsAnimated},"ParrallaxBG":${levelobjectsarray[object].ParrallaxBG}},\n';
        }


        
        var realdata:String = objects.substr(0, objects.length - 2);
        realdata += '\n';
        filedata += realdata;
        filedata += '    ]\n}'; //ending of the file. kinda important?
        trace(filedata);
        fr.save(filedata, 'objects.json');
    }

    public function SelectObjectFile(){
        var jsonloadergroup:FlxSpriteGroup = new FlxSpriteGroup();
        var objname:FlxInputText = new FlxInputText(0, 0, 100, "", 8, FlxColor.BLACK, FlxColor.WHITE, true);
        objname.screenCenter();

        var loadobj:FlxButton = new FlxButton(0, 0, 'Load', ()->{loadObjectsFile(objname.text); wait(0.5, ()->{jsonloadergroup.destroy();});});
        loadobj.screenCenter(X);
        loadobj.y = objname.y - 20;

        jsonloadergroup.add(loadobj);
        jsonloadergroup.add(objname);

        add(jsonloadergroup);

    }

    private function loadObjectsFile(jsonName:String):String{
        if(jsonName != ''){
            if(FileSystem.exists('assets/${jsonName}.json')){
                var json:Dynamic = Assets.getText('assets/${jsonName}.json');
                var jsonData:Dynamic = TJSON.parse(json);
                if(list.length != 0) //TODO: implement popup if you dont save objects.json before loading a file if you made changes
                    clearList();
                for(i in 0...jsonData.Data.length){
                    importedObjects.push({
                        Name: jsonData.Data[i].Name,
                        Alpha: jsonData.Data[i].alpha,
                        X: jsonData.Data[i].XYZ[0],
                        Y: jsonData.Data[i].XYZ[1],
                        Z: jsonData.Data[i].XYZ[2],
                        ScaleX: jsonData.Data[i].Scale[0],
                        ScaleY: jsonData.Data[i].Scale[1],
                        SFX: jsonData.Data[i].Scrollfactor[0],
                        SFY: jsonData.Data[i].Scrollfactor[1],
                        IMG: jsonData.Data[i].Graphic,
                        VIS: jsonData.Data[i].Visible,
                        DoubleAxisCollide: jsonData.Data[i].DoubleAxisCollide != null ? jsonData.Data[i].DoubleAxisCollide : false,
                        TripleAxisCollide: jsonData.Data[i].TripleAxisCollide != null ? jsonData.Data[i].TripleAxisCollide : false,
                        IndentationPixels: jsonData.Data[i].IndentationPixels != null ? jsonData.Data[i].IndentationPixels : 0,
                        DynamicTranparency: jsonData.Data[i].DynamicTranparency != null ? jsonData.Data[i].DynamicTranparency : false,
                        IsBackground: jsonData.Data[i].IsBackground != null ? jsonData.Data[i].IsBackground : false,
                        RenderOverPlayer: jsonData.Data[i].RenderOverPlayer != null ? jsonData.Data[i].RenderOverPlayer : false,
                        RenderBehindPlayer: jsonData.Data[i].RenderBehindPlayer != null ? jsonData.Data[i].RenderBehindPlayer : false,
                        IsAnimated: jsonData.Data[i].IsAnimated != null ? jsonData.Data[i].IsAnimated : false,
                        ParrallaxBG: jsonData.Data[i].ParrallaxBG != null ? jsonData.Data[i].ParrallaxBG : false
                    });
                    addObjectToList(new ListObject(0, 20, new FlxSprite(0,0).loadGraphic(backend.Assets.asset(jsonData.Data[i].Graphic)), jsonData.Data[i].Name, "", jsonData.Data[i]), null);
                    addObjectToList(null, importedObjects[i]);
                    trace(importedObjects);
                    trace(i);
                }
                wait(1, ()->{
                    importedObjects.clearArray();
                    importedObjects = [];
                });
                return 'Success!';
            }else{
                trace('json file invalid.');
                return 'failure';
            }
        }else{
            trace('dumbass.');
            return 'Please Input an actual json file location.';
        }
    }

    public function clearList(){
        for(i in 0...list.length){
            list[i].destroy();
        }
        list.clearArray();
        list = [];
        levelobjectsarray.clearArray();
        levelobjectsarray = [];
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
        if(list != null){
            for(i in 0...list.length){
                if(list[i].added != true){
                    if(i > 0){
                        list[i].y += 10 * i;
                    }
                    add(list[i]);
                    list[i].added = true;
                }
                
            }
        }
    }
}

class ListObject extends FlxSpriteGroup{
    var txt:FlxText;
    var sprite:FlxSprite;
    public var added:Bool = false;
    public function new(x:Float, y:Float, spr:FlxSprite, text:String, ?ExtraData:String = '', datapassthrough:Dynamic){
        super(x, y);
        trace('created a new ListObject :::: ' + this);
        if(spr != null){
            if(spr.graphic == null)
                spr.makeGraphic(10, 10, FlxColor.MAGENTA);
            spr.alpha = 0.5;
            spr.setGraphicSize(10, 10);
            spr.updateHitbox();
            add(spr);
            var eye:FlxSprite = new FlxSprite(0, 0).loadGraphic(backend.Assets.asset('ui/visability.png'), true, 10, 10);
            eye.animation.add('open', [0], 1, );
            eye.animation.add('closed', [1], 1, );
            if(datapassthrough != null && datapassthrough.Visible != false){
                eye.animation.play('open');
            }else{
                eye.animation.play('closed');
            }
            add(eye);
            txt = new FlxText(10, 0, 400, text, true);
            if(ExtraData != null || ExtraData != ''){
                txt.text += ' ' + ExtraData;
            }
            if(datapassthrough != null)
                txt.text += ' x:${Std.string(datapassthrough.XYZ[0])} y:${Std.string(datapassthrough.XYZ[1])} z:${Std.string(datapassthrough.XYZ[2])} scl:[${Std.string(datapassthrough.Scale[0])},${Std.string(datapassthrough.Scale[1])}] srf:[${Std.string(datapassthrough.Scrollfactor[0])},${Std.string(datapassthrough.Scrollfactor[1])}], alpha:${Std.string(datapassthrough.alpha)}';
            add(txt);
        }else{
            trace('SPRITE IS NULL. ABORTING CREATION OF LIST OBJECT.');
        }
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
    }
}