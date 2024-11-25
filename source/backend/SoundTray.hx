package backend;

import flixel.system.ui.FlxSoundTray;
import openfl.display.Bitmap;

/**
 *  Extends the default flixel soundtray, but with some art
 *  and lil polish!
 *
 *  Gets added to the game in Main.hx, right after FlxGame is new'd
 *  since it's a Sprite rather than Flixel related object
 */
class SoundTray extends FlxSoundTray
{
    function cameraLerp(lerp:Float):Float
        {
          return lerp * (FlxG.elapsed / (1 / 60));
        }
    function coolLerp(base:Float, target:Float, ratio:Float):Float
        {
          return base + cameraLerp(ratio) * (target - base);
        }
  var graphicScale:Float = 0.30;
  var lerpXPos:Float = 1280;
  var alphaTarget:Float = 0;

  var volumeMaxSound:String;

  public function new()
  {
    
    // calls super, then removes all children to add our own
    // graphics
    super();
    this.x = 1280; //call before super hopefully to fix an error with positioning?
    removeChildren();

    var bg:Bitmap = new Bitmap(openfl.Assets.getBitmapData(Assets.asset("soundtray.png")));
    bg.scaleX = graphicScale;
    bg.scaleY = graphicScale;
    bg.smoothing = true;
    addChild(bg);
    visible = false;

    // makes an alpha'd version of all the bars (bar_10.png)
    var backingBar:Bitmap = new Bitmap(openfl.Assets.getBitmapData(Assets.asset("vol_10.png")));
    backingBar.x = 9;
    backingBar.y = 5;
    backingBar.scaleX = graphicScale;
    backingBar.scaleY = graphicScale;
    backingBar.smoothing = true;
    addChild(backingBar);
    backingBar.alpha = 0.4;

    // clear the bars array entirely, it was initialized
    // in the super class
    _bars = [];

    // 1...11 due to how block named the assets,
    // we are trying to get assets bars_1-10
    for (i in 1...11)
    {
      var bar:Bitmap = new Bitmap(openfl.Assets.getBitmapData(Assets.asset("vol_" + i + '.png')));
      bar.x = 9;
      bar.y = 5;
      bar.scaleX = graphicScale;
      bar.scaleY = graphicScale;
      bar.smoothing = true;
      addChild(bar);
      _bars.push(bar);
    }

    //screenCenter();

    volumeUpSound = 'assets/Volup.ogg';
    volumeDownSound = 'assets/Voldown.ogg';
    volumeMaxSound = 'assets/VolMAX.ogg';

    trace("Custom tray added!");
    this.y += 90;
  }

  override public function update(MS:Float):Void
  {
    //trace(FlxG.sound.volume);
    x = coolLerp(x, lerpXPos, 0.1);
    alpha = coolLerp(alpha, alphaTarget, 0.25);

    var shouldHide = (FlxG.sound.muted == false);

    // Animate sound tray thing
    if (_timer > 0)
    {
      if (shouldHide) _timer -= (MS / 1000);
      alphaTarget = 1;
    }
    else if (x >= -width)
    {
      lerpXPos = 1280;
      alphaTarget = 0;
    }

    if (x <= -width)
    {
      visible = false;
      active = false;

      #if FLX_SAVE
      // Save sound preferences
      if (FlxG.save.isBound)
      {
        FlxG.save.data.mute = FlxG.sound.muted;
        FlxG.save.data.volume = FlxG.sound.volume;
        FlxG.save.flush();
      }
      #end
    }
  }

  /**
   * Makes the little volume tray slide out.
   *
   * @param	up Whether the volume is increasing.
   */
  override public function show(up:Bool = false):Void
  {
    _timer = 1;
    lerpXPos = 1050;
    visible = true;
    active = true;
    var globalVolume:Int = Std.int(FlxG.sound.volume * 10);//Math.round(Functions.logToLinear(FlxG.sound.volume) * 10);

    if (FlxG.sound.muted || FlxG.sound.volume == 0)
    {
      globalVolume = 0;
    }

    if (!silent)
    {
      var sound = up ? volumeUpSound : volumeDownSound;

      if (globalVolume == 10) sound = volumeMaxSound;

      if (sound != null) FlxG.sound.load(sound).play();
    }

    for (i in 0..._bars.length)
    {
      if (i < globalVolume)
      {
        _bars[i].visible = true;
      }
      else
      {
        _bars[i].visible = false;
      }
    }
  }
}