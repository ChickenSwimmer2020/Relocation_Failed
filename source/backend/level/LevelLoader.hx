package backend.level;

import sys.io.File;
import tjson.TJSON;

/**
 * The header of a level.
 * @since RF_DEV_0.1.4
 */
typedef LevelHeader = {
	var LevelID:String; // levels internal name
	var Chapter:Int; // what chapter it takes place in
	var Boundries:Array<Float>; // the boundries of the level, how far can the player move before being stopped?
	var CameraLocked:Bool; // should the camera be allowed to move?
	var CameraFollowStyle:String; // how should the camera follow the player?
	var CameraFollowLerp:Float; // what is the ratio of the lerp the camera uses to follow the player?
	var isBeatState:Bool; // is this a beat state level?
	var beatstateframetime:Float; // how many frames between the camera bops //* THIS IS THE BPM OF THE SONG, NOT THE FRAME INTERVAL
}

/**
 * Animation data of an object in a level.
 * @since RF_DEV_0.1.4
 */
typedef AnimData = {
	var ?AnimFrames:Array<Int>; // anim frames
	var ?AnimName:String; // anim name
	var ?AnimFPS:Int; // anim FPS
	var ?AnimLoop:Bool; // should anim loop
	var ?AnimFlipX:Bool; // should anim be flipped on the x axis
	var ?AnimFlipY:Bool; // should the anim be flipped on the y axis
}

/**
 * An object in a level.
 * @since RF_DEV_0.1.4
 */
typedef LevelObject = {
	var Name:String; // internal name
	var Alpha:Float; // how transparent is the object
	var X:Float; // X positional value
	var Y:Float; // Y positional value
	var Z:Float; // Z positional value
	var ScaleX:Float; // X scale factor
	var ScaleY:Float; // Y scale factor
	var SFX:Float; // X scroll factor
	var SFY:Float; // Y scroll factor
	var IMG:String; // what image do we load
	var VIS:Bool; // should the sprite be visible?
	var ?DoubleAxisCollide:Bool; // should it collide with the player on 2 axis(x, y)?
	var ?TripleAxisCollide:Bool; // should it collide with player on all 3 axis(x, y, z)?
	var ?IndentationPixels:Int; // how many pixels should be indented when colliding on the top of this object(only used in TripleAxisCollide)?
	var ?DynamicTranparency:Bool; // should the sprites alpha be lowered when the player is behind it?
	var ?IsBackground:Bool; // automatically scales across entire screen
	var ?RenderOverPlayer:Bool; // should the sprite be rendered over the player?
    var ?RenderBehindPlayer:Bool; // should the sprite be rendered behind the player?
	var ?IsAnimated:Bool; // should it be animated?
	var ?ParrallaxBG:Bool; // should it be a parrallax?
	var ?Anims:Array<AnimData>; // animation data if needed
}

/**
 * A door in a level.
 * @since RF_DEV_0.3.7
 */
typedef LevelDoor = {
	var Name:String; // internal name
	var LevelToLoad:String; // what level do we load.
	var isAnimated:Bool; // do we have animation?
	var Graphic:String; // what graphic do we load, most of the time though, this will just stay as 'DOOR'.
	var ?Frame:Array<Int>; // the frame bounds, value 1 is height, value 2 is width.
	var openAnimLength:Float; // how long does it take for the door to open before switching levels.
	var PlayerPosition:Array<Float>; // where should the player spawn in the new level?
	var scale:Array<Float>; // scale.
	var X:Float; // x position.
	var Y:Float; // y position.
	var Z:Float; // z position.
}

/**
 *  An trigger in a level.
 * @since RF_DEV_0.3.8
**/
typedef LevelTrigger = {
	var Name:String; // internal name.
	var Function:String; // what to do when triggered.
	var ?Visible:Bool; // is the trigger visible to the camera.
	var isOneShot:Bool; // does the trigger kill itself after being triggered.
	var X:Float; // x position.
	var Y:Float; // y position.
	var Z:Float; // z position.
	var Width:Float; // width.
	var Height:Float; // height.
}

/**
 * An item in a level.
 * @since RF_DEV_0.1.4
 */
typedef LevelItem = // should allow us to put items into the level directly
{
	var Name:String; // internal name
	var behavior:String; // what to do when picked up
	var texture:String; // texture to use
	var X:Float; // X positional value
	var Y:Float; // Y positional value
	var Z:Float; // Z positional value
	var SCL:Float; // scale
}

typedef LevelData = {
	/**
	 * The items in the level.
	 * @since RF_DEV_0.1.4
	 */
	var items:Array<LevelItem>;

	/**
	 * The objects in the level.
	 * @since RF_DEV_0.1.4
	 */
	var objects:Array<LevelObject>;

	/**
	 * The header of the level.
	 * @since RF_DEV_0.1.4
	 */
	var header:LevelHeader;

	/**
	 * the doors of a level.
	 * @since RF_DEV_0.3.7
	 */
	var doors:Array<LevelDoor>;

	/**
	 *  the triggers of a level
	 * @since RF_DEV_0.3.8
	**/
	var triggers:Array<LevelTrigger>;
}

class LevelLoader {
	/**
	 * Parse the level data from a json file.
	 * @param jsonFileData The content of the json file to parse.
	 * @return The parsed level data as a LevelData.
	 */
	public static function parseLevelData(jsonFileData:String):LevelData
		try {
			return TJSON.parse(jsonFileData, 'Level');
		} catch (e) {
			trace(new LevelExceptions.LevelParseErrorException(e.message, e.stack.toString()).toString());
			return null;
		}
}
