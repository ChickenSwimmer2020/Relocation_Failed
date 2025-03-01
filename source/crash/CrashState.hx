package crash;

import lunarps.particles.LunarParticle;
import lunarps.LunarShape.LunarCircle;
import lunarps.particles.LunarParticleBehavior;
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
		var signal:LunarSignalParticleBehavior = new LunarSignalParticleBehavior();
		signal.onParticleFrameCallback = (particle:LunarParticle, emitter:LunarParticleEmitter, dt:Float) ->
		{
			if (particle.y > FlxG.height || particle.x < 0)
				LunarParticleBehavior.killParticle(particle);
		}
		var r = new LunarCircle(0xFFFFFFFF, 2, 6);
		r.alpha = 160;
		var emitter = new LunarParticleEmitter(0, -20, particleRenderer, r, null, {autoSpawning: true, waitingSecs: 0, particlesPerWaitingSecs: 5});
		emitter.addBehavior('spawn in range', new LunarSpawnInRangeParticleBehavior(FlxG.width + 150, 0));
		emitter.addBehavior('velocity', new LunarVelocityParticleBehavior());
		emitter.addBehavior('initial velocity', new LunarRandomInitialVelocityParticleBehavior(-5, -8, 10, 20));
		emitter.addBehavior('face velocity', new LunarFaceVelocityParticleBehavior());
		emitter.addBehavior('random color', new LunarColorVariationParticleBehavior([0xFF5BDB59, 0xFFA8FFAC, 0xFFD8FFD3]));
		emitter.addBehavior('stretch to velocity', new LunarVelocityStretchParticleBehavior(2, 2, false, true));
		emitter.addBehavior('signal', signal);
		var rBG = new LunarCircle(0xFFFFFFFF, 1, 3);
		rBG.alpha = 100;
		var emitterBG = new LunarParticleEmitter(0, -20, particleRenderer, rBG, null, {autoSpawning: true, waitingSecs: 0, particlesPerWaitingSecs: 5});
		emitterBG.addBehavior('spawn in range but in the bg', new LunarSpawnInRangeParticleBehavior(FlxG.width + 150, 0));
		emitterBG.addBehavior('velocity but in the bg x2', new LunarVelocityParticleBehavior());
		emitterBG.addBehavior('initial velocity but in the bg x3', new LunarRandomInitialVelocityParticleBehavior(-5, -8, 10, 20));
		emitterBG.addBehavior('face velocity but in the bg x4', new LunarFaceVelocityParticleBehavior());
		emitterBG.addBehavior('random color but in the bg x5', new LunarColorVariationParticleBehavior([0xFFA7FF98, 0xFFBCFFA8, 0xFFAAFF9F]));
		emitterBG.addBehavior('stretch to velocity but in the bg x6', new LunarVelocityStretchParticleBehavior(1.5, 1, false, true));
		emitterBG.addBehavior('signal but in the bg x7', signal);
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
