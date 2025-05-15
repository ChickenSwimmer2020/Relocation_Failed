package backend.level;

import objects.game.controllables.Aimer;
import sys.FileSystem;
import sys.io.File;
import tjson.TJSON;
import backend.level.rfl.RFLParser.RFLAssets;
import flixel.math.FlxMath;
import objects.RFTriAxisSprite;
import flixel.math.FlxPoint;
import debug.leveleditor.Editor.EditorState;
import objects.game.interactables.Door;
import objects.game.interactables.Item;
import objects.game.interactables.Item.ItemType;
import objects.game.interactables.Trigger;
import objects.game.controllables.Player;
import flixel.math.FlxRect;
import backend.level.LevelLoader.LevelHeader;
import backend.level.LevelExceptions.LevelNullException;
import haxe.PosInfos;
import backend.level.LevelLoader.LevelData;
import flixel.group.FlxGroup;

class Level extends FlxGroup {
    public var levelAssets:RFLAssets;
	public var levelData:LevelData;
	public var levelHeader:LevelHeader;

	public var objects:Map<String, LevelSprite> = new Map();
	public var layeringGrp:FlxTypedGroup<RFTriAxisSprite> = new FlxTypedGroup<RFTriAxisSprite>();
	public var items:Map<String, Item> = new Map();
	public var doors:Map<String, FlxSpriteGroup> = new Map();
	public var triggers:Map<String, FlxSprite> = new Map();
	public var colliders:Array<LevelSprite> = [];
	public var interactables:Array<InteractionSprite> = [];

	public var LevelID:String;
	public var ChapterID:Int;
	public var MapBounds:FlxRect;

	public var CameraLocked:Bool = false;
	public var CameraLerp:Float;
	public var CameraFollowStyle:String;

	public var isBeatStage:Bool = false;
	public var FrameTime:Float = 0;

	public var EditorMode:Bool;
	public var parent:Playstate;

	//TODO: re-write to work with the new level system.

	override public function new(levelAssets:RFLAssets, parent:Playstate, ?inEditor:Bool = false, ?_:PosInfos) {
		super();
		this.levelAssets = levelAssets;
        if (levelAssets.get('Level.json') == null)
            throw new LevelExceptions.LevelAssetsException('Level.json is null!', '', _);
        levelData = LevelLoader.parseLevelData(levelAssets.get('Level.json'));
		this.parent = parent;
		EditorMode = inEditor;
		add(layeringGrp);
	}

	public function unloadLevel(?_:PosInfos) {
		levelData = null;
		levelHeader = null;
		objects.clear();
		layeringGrp.clear();
		items.clear();
		doors.clear();
		triggers.clear();

		colliders.clearArray((collider) -> {
			collider.destroy();
		});

		members.clearArray((member) -> {
			member.destroy();
		});

		LevelID = '';
		ChapterID = 1;
		MapBounds = null;

		CameraLocked = false;
		CameraLerp = 0;
		CameraFollowStyle = '';

		EditorMode = false;
	}

    public static function getGraphicFromRFLAssets(name:String, assets:RFLAssets, ?_:PosInfos):Dynamic
    {
        if (assets == null)
        {
            if (FileSystem.exists(Assets.asset(name)))
                return Assets.asset(name);
            else
                return ''; 
        }
        if (assets.get(name) == null){
            if (FileSystem.exists(Assets.asset(name)))
                return Assets.asset(name);
            else
                return '';
            return '';
        }else
            return assets.get(name);
    }

	public function loadLevel(?_:PosInfos) {
		if (levelData == null)
			throw new LevelExceptions.LevelAssetsException('Level data is null!', '', _);

		levelHeader = levelData.header;

		if (levelHeader == null)
			throw new LevelExceptions.LevelNullException('Level header is null!', '', _);

		LevelID = levelHeader.LevelID;
		ChapterID = levelHeader.Chapter;
		CameraLocked = levelHeader.CameraLocked;
		MapBounds = new FlxRect(0, 0, levelHeader.Boundries[0], levelHeader.Boundries[1]);

		CameraLerp = levelHeader.CameraFollowLerp;
		CameraFollowStyle = levelHeader.CameraFollowStyle;

		isBeatStage = levelHeader.isBeatState;
		FrameTime = levelHeader.beatstateframetime;

		for (object in levelData.objects) {
			var obj:LevelSprite = new LevelSprite(object.X, object.Y, object.Z);
            obj.loadGraphic(getGraphicFromRFLAssets(object.IMG, levelAssets));
			
			obj.scale.set(object.ScaleX, object.ScaleY);
			obj.texture = object.IMG;

			if (object.ScaleX > 1
				|| object.ScaleX < 1
				|| (object.ScaleY > 1 || object.ScaleY < 1)) // stupid `On static platforms, null can't be useds as basic type Float` error.
				obj.updateHitbox(); // since we're doing collision stuff, hitboxes actually need to update now

			obj.scrollFactor.set(object.SFX, object.SFY);
			obj.doubleAxisCollide = object.DoubleAxisCollide;
			obj.dynamicTranparency = object.DynamicTranparency;
			obj.tripleAxisCollide = object.TripleAxisCollide;
			obj.indentationPixels = object.IndentationPixels;

			if (!object.VIS)
				obj.alpha = 0; // so that the collision can still be done

			if (!EditorMode) {
				if (object.RenderOverPlayer)
					obj.camera = Playstate.instance.FGCAM;
				obj.isForegroundSprite = object.RenderOverPlayer;
			}

			if (object.ParrallaxBG != null)
				obj.parrallaxBG = object.ParrallaxBG;
			// do something

			if (object.IsAnimated != null)
				if (object.IsAnimated)
					for (anim in object.Anims)
						obj.animation.add(anim.AnimName, anim.AnimFrames, anim.AnimFPS, anim.AnimLoop, anim.AnimFlipX, anim.AnimFlipY);

			if (object.IsBackground != null)
				if (object.IsBackground) {
					obj.isBackground = true;
					obj.setPos(0, 0, 0);
					obj.setGraphicSize(levelHeader.Boundries[0], levelHeader.Boundries[1]);
					obj.scrollFactor.set(0, 0);
					obj.screenCenter(XY);
				}

            if (object.RenderBehindPlayer != null)
					obj.behindPlayer = object.RenderBehindPlayer;

			obj.name = object.Name;
			objects.set(object.Name, obj);
			layeringGrp.add(obj);
		}
		for (item in levelData.items) {
			var itm = new Item(levelAssets, item.X, item.Y, item.Z, item.texture, item.behavior, parent, this, layeringGrp, EditorMode);
			items.set(item.Name, itm); // should work?
			add(itm);
		}
		for (doorData in levelData.doors) {
			var door:Door = new Door(levelAssets, doorData.X, doorData.Y, doorData.Z, doorData.Graphic, layeringGrp, doorData.isAnimated, doorData.Frame,
				doorData.openAnimLength, doorData.LevelToLoad, doorData.PlayerPosition, EditorMode);
			@:privateAccess {
				door.SPR.scale.set(doorData.scale[0], doorData.scale[1]);
				door.SPR.updateHitbox();
				if (!EditorMode)
					door.interactPrompt.updateHitbox();
			}
			doors.set(doorData.Name, door);
			add(door);
		}
		for (trigger in levelData.triggers) {
			var Trg:Trigger = new Trigger(trigger.X, trigger.Y, trigger.Z, this, layeringGrp, trigger.Width, trigger.Height, trigger.Visible,
				trigger.Function, trigger.isOneShot, EditorMode);
			triggers.set(trigger.Name, Trg);
			add(Trg);
			trace('New Trigger Created\n\n$Trg');
		}
		//for (InteractableSprite in levelData.interactables) {
			//TODO: this.
		//}
	}

	public function layerSorting(s1:RFTriAxisSprite, s2:RFTriAxisSprite, array:Array<RFTriAxisSprite>):Int {
		if (s1 == null) {
			array.remove(s1);
			return 0;
		}
		if (s2 == null) {
			array.remove(s2);
			return 0;
		};
		if (Std.isOfType(s1, LevelSprite)) {
			var spr:LevelSprite = cast s1;
			if (spr.isBackground || spr.behindPlayer)
				return -1;
		}
		if (Std.isOfType(s2, LevelSprite)) {
			var spr:LevelSprite = cast s2;
			if (spr.isBackground || spr.behindPlayer)
				return -1;
		}
        if (Std.isOfType(s1, Player) && Std.isOfType(s2, Aimer))
			return -1;
        if (Std.isOfType(s2, Player) && Std.isOfType(s1, Aimer))
			return 1;
		return FlxSort.byValues(-1, s1.y + s1.height, s2.y + s2.height);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		// Layering (for loop cause every other frame the background is on top of everything)
		for (_ in 0...2){
			layeringGrp.members.sort((spr1, spr2) -> {
				layerSorting(spr1, spr2, layeringGrp.members);
			});
		}

		// Dynamic Transparency (quite unoptimized, doesn't work)
		/*for (sprID in 0...layeringGrp.members.length) {
			var playerSpriteID = 0;
			var sprite = layeringGrp.members[sprID];
			if (Std.isOfType(sprite, Player)) {
				playerSpriteID = sprID;
				for (spriteID in 0...layeringGrp.members.length) {
					if (Std.isOfType(layeringGrp.members[spriteID], LevelSprite)) {
						var spr:LevelSprite = cast layeringGrp.members[spriteID];
						if (spriteID > playerSpriteID)
							if (spr.dynamicTranparency)
								spr.alpha = FlxMath.lerp(spr.alpha, 0.5, 0.01);
							else if (spr.dynamicTranparency)
								spr.alpha = FlxMath.lerp(spr.alpha, spr.defaultAlpha, 0.01);
					}
				}
				break;
			}
		}*/
	}
}

class LevelSprite extends RFTriAxisSprite {
	public var doubleAxisCollide:Bool = false;
	public var dynamicTranparency:Bool = false;
    public var behindPlayer:Bool = false;
	public var defaultAlpha:Float = 1;
	public var indentationPixels:Int = 0;
	public var tripleAxisCollide:Bool = false;
	public var isForegroundSprite:Bool = false;
	public var isBackground:Bool = false;
	public var name:String = '';
	public var parrallaxBG:Bool = false;
	public var texture:String = '';

	override public function update(elapsed:Float) { // WORKING COLLISION?!?!?!
		if (this.doubleAxisCollide) {
			this.moves = false; // how can the player even fucking move the damn sprite????
			this.solid = true; // make object have collision
			this.immovable = true; // why did the box even move????
		}
		if (this.isForegroundSprite) { // make sure to disable collision if the sprite is on the foreground, even if it is on a sperate camera.
			this.solid = false; // override the last one hopefully
		}
	}
}

class InteractionSprite extends RFTriAxisSprite {
	public var doubleAxisCollide:Bool = false;
	public var tripleAxisCollide:Bool = false;
	public var name:String = '';
	public var texture:String = '';
	public var dialoug:String = '';
	public var Collide:Bool = false;
	public var IsShiny:Bool = false;
	public var IsAnimated:Bool = false;
	public var giveItemOnUse:Bool = false;
	public var ItemToGive:String = '';

	override public function update(elapsed:Float) { // WORKING COLLISION?!?!?!
		if (this.doubleAxisCollide) {
			this.moves = false; // how can the player even fucking move the damn sprite????
			this.solid = true; // make object have collision
			this.immovable = true; // why did the box even move????
		}
	}
}
