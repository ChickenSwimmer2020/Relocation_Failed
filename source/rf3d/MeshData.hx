package rf3d;

import away3d.materials.TextureMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.loaders.misc.AssetLoaderContext;

enum ModelType {
    OBJ;
    MD2;
}

class MeshData {
    public var lightPicker:StaticLightPicker;
    public var modelType:ModelType;
    public var modelName:String;
    public var material:TextureMaterial;
    public var alc:AssetLoaderContext;
    public var modelBytes:Dynamic;
    public var shadows:Bool;

    public function new()
        return;
}