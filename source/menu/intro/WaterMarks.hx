package menu.intro;

import rf3d.MeshData;
import rf3d.ModelView;
import away3d.entities.Mesh;
import away3d.events.Asset3DEvent;
import away3d.lights.DirectionalLight;
import away3d.library.assets.Asset3DType;
import away3d.materials.lightpickers.StaticLightPicker;

import openfl.Assets;
import flxsvg.FlxSvgSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.ui.Window;

class WaterMarks extends FlxState
{
    //var SNF:FlxSprite;
    var SNF:FlxSvgSprite;
    var SPM:FlxSprite;
    var modelView:ModelView;
    var CS2020M:MeshData;
    var moveScreen:Bool = true;
    var tX:Float = 0;
    var tY:Float = 0;

    var window:Window;

    override public function create()
    {
        super.create();

        window = Application.current.window; //kept crashing, forgot to add this :man_facepalming:
        @:privateAccess
            window.__attributes.alwaysOnTop = false; //since we forced this during the fade intro, we want to disable it. no reason to keep it on

        FlxG.camera.flash();

        //SPM = new FlxSprite(0, 0, 'assets/SP-Mascot.png');
        //SPM.scale.set(0.8, 0.8);
        //SPM.updateHitbox(); //TODO: make a mascot for studio not found
        //SPM.screenCenter();
        //SPM.alpha = 0;
        //add(SPM);
        //FlxTween.tween(SPM, {alpha: 0.3, "scale.x": 1, "scale.y": 1}, 1, {ease: FlxEase.circOut});

        //SNF = new FlxSprite(0, 1350, 'assets/SP.png');
        SNF = new FlxSvgSprite(Assets.getText("assets/StudioLogo.svg"), 0, 0);
        //add(SNF);
        //SNF.scale.set(0.5, 0.5);
        SNF.screenCenter(X);
        SNF.alpha = 1;
        SNF.angle = -5;    
        //FlxTween.tween(SNF, {alpha: 1, y: FlxG.height/2 - SNF.height/2}, 1, {ease: FlxEase.circOut});

        // The model data
        CS2020M = new MeshData();
        CS2020M.modelName = 'CS2020M';
        CS2020M.modelType = OBJ;
        // The light cast onto the model
        var light = new DirectionalLight();
        light.castsShadows = true;
        light.ambient = 0.5;
        light.z -= 10;
        // The view that the model is viewed in (obv)
        modelView = new ModelView(0, 0, 1280, 720, true);
        modelView.addChildToScene(light);
        add(modelView);
        /* 
            Initialize the model loading:
            Basically modifies the MeshData to contain some reeeaal data about the model, 
            enabling us to modify things such as the material, model bytes, etc. 
        */
        modelView.assetLoadedCallback = cs2020Loaded;
        modelView.initModelLoad(CS2020M);
        CS2020M.lightPicker = new StaticLightPicker([light]);
        // Load the model, bring it into existance!! :D
        modelView.loadModel();
        

        var overlayWhite = new FlxSprite(0, 0).makeGraphic(1280, 720);
        overlayWhite.alpha = 0;
        add(overlayWhite);

        FlxG.sound.playMusic('assets/sound/intro/SPWatermark.wav', 1, false);
        wait(4, () -> {
            //FlxTween.tween(SNF, {alpha: 0, y: 1350}, 1, {ease: FlxEase.circIn});
            //FlxTween.tween(SPM, {alpha: 0, "scale.x": 0.8, "scale.y": 0.8}, 1, {ease: FlxEase.circIn});
            FlxTween.tween(overlayWhite, {alpha: 1}, 1, {ease: FlxEase.circIn});
            wait(3, () -> {
                moveScreen = false;
                FlxG.sound.music.stop();
                FlxG.switchState(new MainMenu());
            });
        });
    }

    public function cs2020Loaded(event:Asset3DEvent)
	{
		if (event.asset.assetType == Asset3DType.MESH)
		{
			var mesh:Mesh = cast(event.asset, Mesh);
			mesh.material = CS2020M.material;
            mesh.castsShadows = CS2020M.shadows;
            mesh.scale(600);
            mesh.y -= 250;
            mesh.rotationY = 180;
            if (CS2020M.lightPicker != null)
                mesh.material.lightPicker = CS2020M.lightPicker;
			modelView.meshs.push(mesh);
		}
	}

    //public function doChickenIntro() {
    //    FlxG.camera.flash();
//
    //    //CS2020M = new FlxSprite(0, 0, 'assets/SP-Mascot.png');
    //    //CS2020M.scale.set(0.8, 0.8);
    //    //CS2020M.updateHitbox();
    //    //CS2020M.screenCenter();
    //    //CS2020M.alpha = 0;
    //    //add(CS2020M);
    //    //FlxTween.tween(SPM, {alpha: 0.3, "scale.x": 1, "scale.y": 1}, 1, {ease: FlxEase.circOut});
//
    //    snf = new FlxSprite(0, 1350, 'assets/SP.png');
    //    snf.screenCenter(X);
    //    snf.alpha = 0;
    //    snf.angle = -5;
    //    add(SP);
    //    FlxTween.tween(SP, {alpha: 1, y: FlxG.height/2 - SP.height/2}, 1, {ease: FlxEase.circOut});
//
    //    var overlayWhite = new FlxSprite(0, 0).makeGraphic(1280, 720);
    //    overlayWhite.alpha = 0;
    //    add(overlayWhite);
//
    //    FlxG.sound.playMusic('assets/sound/intro/SPWatermark.wav', 1, false);
    //    wait(4, () -> {
    //        FlxTween.tween(SP, {alpha: 0, y: 1350}, 1, {ease: FlxEase.circIn});
    //        FlxTween.tween(SPM, {alpha: 0, "scale.x": 0.8, "scale.y": 0.8}, 1, {ease: FlxEase.circIn});
    //        FlxTween.tween(overlayWhite, {alpha: 1}, 3, {ease: FlxEase.circIn});
    //        wait(3, () -> {
    //            moveScreen = false;
    //            FlxG.sound.music.stop();
    //            FlxG.switchState(new MainMenu());
    //        });
    //    });
    //}

    override public function update(elapsed:Float) {
        super.update(elapsed);
        //SPM.updateHitbox();
        //SPM.screenCenter();
        wait(0.01, () ->
        {
            //if (SNF.angle == -5) FlxTween.angle(SNF, SNF.angle, 5, 1, {ease: FlxEase.smootherStepInOut});
            //if (SNF.angle == 5) FlxTween.angle(SNF, SNF.angle, -5, 1, {ease: FlxEase.smootherStepInOut});
        });
        for (mesh in modelView.meshs)
        {
            if (mesh != null)
                mesh.rotationY += 100 * elapsed;
        }
    }
}