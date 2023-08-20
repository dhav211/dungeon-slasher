package flea2d.scene;

import flea2d.content.Content;

class SceneManager {
	static var currentScene:Scene;
	static var isInitialized:Bool;
	static var onBegin:Void->Void;
	static var onEnd:Scene->Void;

	public static function loadScene(scene:Scene) {
		currentScene.removeContent(new Content(currentScene, onEnd));

		currentScene = scene;
		onBegin();
		currentScene.loadContent(new Content(currentScene, onEnd));
	}

	public static function initialize(begin:Void->Void, end:Scene->Void) {
		if (!isInitialized) {
			onBegin = begin;
			onEnd = end;
			isInitialized = true;
		}
	}
}
