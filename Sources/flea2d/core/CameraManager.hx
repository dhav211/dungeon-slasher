package flea2d.core;

import kha.math.Vector2;

class CameraManager {
	public static var currentCamera(default, null):Camera;
	public static var cameras(default, null):Map<String, Camera> = new Map<String, Camera>();

	/**
	 * Creates the default current camera and sets the cameras map to just the default camera.
	 * This should only be called at start of game, will remove all cameras.
	 */
	public static function setupDefaultCamera() {
		cameras.set("default", new Camera(new Vector2()));
		currentCamera = cameras["default"];
	}

	/**
	 * Add a camera to the game
	 * @param cameraName Name of camera, used to access from cameras map
	 * @param camera The camera that will be stored and used when needed
	 */
	public static function addCamera(cameraName:String, camera:Camera) {
		if (cameraName != null)
			cameras.set(cameraName, camera);
	}

	/**
	 * Remove a camera by it's name. Cannot remove the default camera.
	 * @param cameraName The name of the camera to remove
	 */
	public static function removeCamera(cameraName:String) {
		if (cameraName != "default")
			cameras.remove(cameraName);
	}
}
