package crash;

import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import menu.intro.WaterMarks;
import menu.intro.WindowIntro;
import menu.intro.IntroState;
import away3d.animators.nodes.ParticleSegmentedScaleNode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxGradient;
import haxe.Serializer;
import haxe.Unserializer;
import lime.system.Clipboard;
import lunarps.LunarShape.LunarRect;
import lunarps.particles.LunarParticleEmitter;
import lunarps.particles.behaviors.*;
import lunarps.renderer.LunarRenderer;
import backend.Assets;

using StringTools;

class CrashState extends FlxState {
	var buffer:StringBuf = new StringBuf();
	var errorTxt:FlxTypeText;
	var errorData:String;
	var gradient:FlxSprite;

	override public function create() {
		Application.current.window.title = "Relocation Failed -- Crash handler V1";
		FlxG.sound.playMusic(Assets.music('ConnectionFailure.ogg'));
		FlxG.autoPause = false;
		errorData = Main.crashTxt;
		if (errorData == '')
			FlxG.switchState(() -> new IntroState()); //* so this acts weird and wont let me just do IntroState.new??? this update is weird af.
		// There wasn't a crash ig 🤷
		super.create();
		gradient = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0x0000000, 0x4400FF00], 1, 0);
		add(gradient);
		makeParticles();
		makeText();
		FlxTween.tween(gradient, {x: 100}, 5, {type: PINGPONG, ease: FlxEase.sineInOut});
	}

	function makeText() {
		addToBuffer('Program exit code: 1\n');
		addToBuffer(errorData.split('|||')[0] + '\n'); // error
		addToBuffer(errorData.split('|||')[1]); // stack
		addToBuffer('\n\n\n\n');
		addToBuffer("We're sorry! The game has crashed. Please report this issue in our discord server, and press Enter to restart the game, and use space to copy the error to your clipboard to report. Thank you!");
		errorTxt = new FlxTypeText(0, 0, 1000, buffer.toString(), 12);
		errorTxt.font = Assets.font('terminus');
		errorTxt.color = 0xFF00FF00;
		add(errorTxt);
		FlxG.mouse.visible = true;
		errorTxt.start();
		errorTxt.txtPerFrame = 10;
	}

	function makeParticles() {
		var particleRenderer = new LunarRenderer({
			x: 0,
			y: 0,
			width: FlxG.width,
			height: FlxG.height
		});
		var rect = new LunarRect(0xFF00FF00, 10, 10);
		rect.alpha = 100;
		var fading = new LunarFadeParticleBehavior(1);
		fading.fadeStartedCallback = (particle, emitter, dt) -> {
			particle.behavior = new LunarGravityParticleBehavior(1);
		};
		var particles = new LunarParticleEmitter(FlxG.width + 10, 0, particleRenderer, rect, null, {});
		particles.addBehavior('Spawn in range', new LunarSpawnInRangeParticleBehavior(0, FlxG.height));
		particles.addBehavior('Velocity', new LunarVelocityParticleBehavior());
		particles.addBehavior('Initial Random Velocity', new LunarRandomInitialVelocityParticleBehavior(-2, -8));
		particles.addBehavior('Fading', fading);
		add(particleRenderer);
	}

	function addToBuffer(text:String) {
		buffer.add(text);
		buffer.add('\n');
	}

	var nextTriggerTime:Float = 0;
	var interval:Float = (60 / 150 * 4000);

	override public function update(elapsed:Float) {
		super.update(elapsed);
		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, Math.exp(-elapsed * 3.125 * 2 * 1));
		if (FlxG.keys.justPressed.ENTER) {
			Main.crashTxt = '';
			Sys.command('start "" "./Relocation Failed.exe"');
			Sys.exit(0);
		}
		if (FlxG.keys.justPressed.SPACE)
			Clipboard.text = '${errorData.split('|||')[0]}\n\n${errorData.split('|||')[1]}';

		if (FlxG.sound.music != null) {
			if (FlxG.sound.music.time == 0) {
				nextTriggerTime = 0;
			}
			if (FlxG.sound.music.time >= nextTriggerTime) {
				FlxG.camera.zoom += 0.005;
				nextTriggerTime += interval;
			}
		}
	}
}
