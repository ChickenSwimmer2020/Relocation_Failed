package rf3d;

import away3d.entities.Mesh;
import away3d.events.Asset3DEvent;
import away3d.library.assets.Asset3DType;
import away3d.lights.DirectionalLight;
import away3d.loaders.Loader3D;
import away3d.loaders.misc.AssetLoaderContext;
import away3d.loaders.parsers.OBJParser;
import away3d.materials.TextureMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.utils.Cast;
import flx3D.FlxView3D;
import openfl.utils.Assets;

class ModelView extends FlxView3D
{
	// Mesh
	public var meshs:Array<Mesh> = [];
    public var curMeshData:MeshData;

	// Loading
	public var modelLoader:Loader3D;
    public var assetLoadedCallback:Asset3DEvent->Void;

	public function new(x:Float = 0, y:Float = 0, width:Int = -1, height:Int = -1, antialiasing:Bool = true)
	{
		super(x, y, width, height);
		this.antialiasing = antialiasing;
        modelLoader = new Loader3D();
        view.scene.addChild(modelLoader);
	}

    public function initModelLoad(mesh:MeshData) {
        if (mesh == null) throw 'NULL MESH DATA';
        curMeshData = mesh;
        switch(mesh.modelType){
            case OBJ:
                mesh.material = new TextureMaterial(Cast.bitmapTexture('assets/3d/${mesh.modelName}/tex.png'));

		        mesh.modelBytes = Assets.getBytes('assets/3d/${mesh.modelName}/model.obj');
                mesh.alc = new AssetLoaderContext();
		        mesh.alc.mapUrlToData('model.mtl', Assets.getBytes('assets/3d/${mesh.modelName}/model.mtl'));

            case MD2:
                trace('No MD2 Support yet, coming soon. (initModelLoad)');
        }
    }

    public function loadModel() {
        if (curMeshData == null) throw 'NULL CURRENT MESH DATA\nDID YOU CALL "initModelLoad" FIRST?';
        switch(curMeshData.modelType){
            case OBJ:
                modelLoader.loadData(curMeshData.modelBytes, curMeshData.alc, null, new OBJParser());
                if (assetLoadedCallback == null) assetLoadedCallback = assetLoaded;
		        modelLoader.addEventListener(Asset3DEvent.ASSET_COMPLETE, assetLoadedCallback);

            case MD2:
                trace('No MD2 Support yet, coming soon. (loadModel)');
        }
    }

	public function assetLoaded(event:Asset3DEvent)
	{
		if (event.asset.assetType == Asset3DType.MESH)
		{
			var mesh:Mesh = cast(event.asset, Mesh);
			mesh.material = curMeshData.material;
            mesh.castsShadows = curMeshData.shadows;
            if (curMeshData.lightPicker != null)
                mesh.material.lightPicker = curMeshData.lightPicker;
			meshs.push(mesh);
		}
	}

    /**
	 * Adds a child to the scene's root.
	 * @param child The child to be added to the scene
	 * @return A reference to the added child.
	 */
    public function addChildToScene(child:away3d.containers.ObjectContainer3D):away3d.containers.ObjectContainer3D
        return view.scene.addChild(child);
}