package backend.level;

import debug.LevelEditorState;
import objects.game.interactables.Door;
import objects.game.interactables.Item;
import objects.game.interactables.Item.ItemType;
import objects.game.controllables.Player;
import flixel.math.FlxRect;
import backend.level.LevelLoader.LevelHeader;
import backend.level.LevelExceptions.LevelNullException;
import haxe.PosInfos;
import backend.level.LevelLoader.LevelData;
import flixel.group.FlxGroup;

class Level extends FlxGroup
{
    public var levelData:LevelData;
    public var levelHeader:LevelHeader;
    public var objects:Map<String, LevelSprite> = new Map();
    public var items:Map<String, FlxSpriteGroup> = new Map();
    public var doors:Map<String, FlxSpriteGroup> = new Map();
    public var colliders:Array<LevelSprite>;

    public var LevelID:String;
    public var ChapterID:Int;
    public var MapBounds:FlxRect;
    public var CameraLocked:Bool = false;

    public var CameraLerp:Float;
    public var CameraFollowStyle:String;

    public var EditorMode:Bool;

    override public function new(levelData:LevelData, ?inEditor:Bool = false) {
        super();
        this.levelData = levelData;
        EditorMode = inEditor;
    }

    public function loadLevel(?_:PosInfos)
    {
        trace('Loading level...');
        if (levelData == null)
            throw new LevelExceptions.LevelNullException('Level is null!', '', _);

        levelHeader = levelData.header;

        if (levelHeader == null)
            throw new LevelExceptions.LevelNullException('Level header is null!', '', _);
        

        LevelID = levelHeader.LevelID;
        ChapterID = levelHeader.Chapter;
        CameraLocked = levelHeader.CameraLocked;
        MapBounds = new FlxRect(0,0,levelHeader.Boundries[0],levelHeader.Boundries[1]);

        CameraLerp = levelHeader.CameraFollowLerp;
        CameraFollowStyle = levelHeader.CameraFollowStyle;

        for (object in levelData.objects){
            var obj = cast(new LevelSprite(object.X, object.Y).loadGraphic(Assets.image(object.IMG)), LevelSprite);
            obj.scale.set(object.ScaleX, object.ScaleY);
            obj.texture = object.IMG;

            if(object.ScaleX > 1 || object.ScaleX < 1 || (object.ScaleY > 1 || object.ScaleY < 1)) //stupid `On static platforms, null can't be useds as basic type Float` error.
                    obj.updateHitbox(); //since we're doing collision stuff, hitboxes actually need to update now

            obj.scrollFactor.set(object.SFX, object.SFY);
            if (object.CollidesWithPlayer != null) {
                obj.isCollider = object.CollidesWithPlayer;
                obj.isForeGroundSprite = object.RenderOverPlayer; //so we can have fg sprites NOT collide at all and possibly cause crashes
            }

            if(!object.VIS)
                obj.alpha = 0; //so that the collision can still be done

            if(!EditorMode) {
                if(object.RenderOverPlayer) {
                    obj.camera = Playstate.instance.FGCAM;
                }
            }

            if(object.ParrallaxBG != null)
                obj.parrallaxBG = object.ParrallaxBG;
                //do something

            if(object.IsAnimated != null)
                if (object.IsAnimated)
                    for (anim in object.Anims)
                        obj.animation.add(anim.AnimName, anim.AnimFrames, anim.AnimFPS, anim.AnimLoop, anim.AnimFlipX, anim.AnimFlipY);


            if (object.IsBackground != null)
                if(object.IsBackground)
                    {
                        obj.isBackground = true;
                        obj.setPosition(0, 0);
                        obj.setGraphicSize(levelHeader.Boundries[0],levelHeader.Boundries[1]);
                        obj.scrollFactor.set(0,0);
                        obj.screenCenter(XY);
                    }
            obj.name = object.Name;
            objects.set(object.Name, obj);
            add(obj);
            trace('new object added!\n\n$obj');
        }
        for (item in levelData.items){
            var BEHAVIOR:ItemType;
            switch(item.behavior) {
                case '_HEALTHPACK':
                    BEHAVIOR = _HEALTHPACK;
                case '_STIMPACK':
                    BEHAVIOR = _STIMPACK;
                //ammo pickups
                case '_BOXOFBUCKSHELL':
                    BEHAVIOR = _BOXOFBUCKSHELL;
                case '_BUCKSHELL':
                    BEHAVIOR = _BUCKSHELL;
                case '_BOXOF9MM':
                    BEHAVIOR = _BOXOF9MM;
                case '_9MMMAG':
                    BEHAVIOR = _9MMMAG;
                case '_RIFLEROUNDSBOX':
                    BEHAVIOR = _RIFLEROUNDSBOX;
                case '_RIFLEROUNDSMAG':
                    BEHAVIOR = _RIFLEROUNDSMAG;
                default:
                    BEHAVIOR = null;
            }
            var itm = cast(new Item(item.X, item.Y, Assets.image(item.texture), BEHAVIOR, EditorMode));
            items.set(item.Name, itm); //should work?
            add(itm);
            trace('new item added!\n\n$itm');
        }
        for (door in levelData.doors){
            var drr:Door = new Door(door.X, door.Y, door.Graphic, door.isAnimated, door.Frame, door.openAnimLength, door.LevelToLoad, door.PlayerPosition, EditorMode);
            @:privateAccess {
                drr.SPR.scale.set(door.scale[0], door.scale[1]); //should have done it like this from the start :man_facepalming:
                drr.SPR.updateHitbox();
                if(!EditorMode)
                    drr.interactPrompt.updateHitbox();
            }
            doors.set(door.Name, drr);
            add(drr);
            trace('new door added!\n\n$drr');
        }
    }
}

class LevelSprite extends FlxSprite
{
    public var isCollider:Bool = false;
    public var isForeGroundSprite:Bool = false;
    public var isBackground:Bool = false;
    public var name:String = '';
    public var parrallaxBG:Bool = false;
    public var texture:String = '';

    override public function update(elapsed:Float) { //WORKING COLLISION?!?!?!
        if(this.isCollider) {
            this.moves = false; //how can the player even fucking move the damn sprite????
            this.solid = true; //make object have collision
            this.immovable = true; //why did the box even move????
        }
        if(this.isForeGroundSprite) { //make sure to disable collision if the sprite is on the foreground, even if it is on a sperate camera.
            this.solid = false; //override the last one hopefully
        }
    }
}