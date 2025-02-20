package rf3d;

import away3d.materials.TextureMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.loaders.misc.AssetLoaderContext;

/**
 * The type of model a mesh is.
 * @since RF_DEV_0.3.0
 */
enum ModelType {
	OBJ;
	MD2;
}

class MeshData {
	/**
	 * The light picker for this mesh.
	 * @since RF_DEV_0.3.0
	 */
	public var lightPicker:StaticLightPicker;

	/**
	 * The type of model this mesh is.
	 * Either ModelType.OBJ or ModelType.MD2.
	 * @since RF_DEV_0.3.0
	 */
	public var modelType:ModelType;

	/**
	 * The name of the model.
	 * Used when looking for the models assets.
	 * @since RF_DEV_0.3.0
	 */
	public var modelName:String;

	/**
	 * The material of the mesh.
	 * @since RF_DEV_0.3.0
	 */
	public var material:TextureMaterial;

	/**
	 * The asset loader context of this mesh.
	 * @since RF_DEV_0.3.0
	 */
	public var alc:AssetLoaderContext;

	/**
	 * The bytes of the model.
	 * @since RF_DEV_0.3.0
	 */
	public var modelBytes:Dynamic;

	/**
	 * If the mesh should cast shadows.
	 * @since RF_DEV_0.3.0
	 */
	public var shadows:Bool;

	public function new()
		return;
}
