package flea2d.scene;

class SceneManager {
	static var currentScene:Scene;
	static var isInitialized:Bool;
	static var onBegin:Void->Void;
	static var onEnd:Void->Void;

	public static function loadScene(scene:Scene) {
		currentScene.removeContent();

		currentScene = scene;
		onBegin();
	}

	public static function initialize(begin:Void->Void, end:Void->Void) {
		if (!isInitialized) {
			onBegin = begin;
			onEnd = end;
			isInitialized = true;
		}
	}
}
