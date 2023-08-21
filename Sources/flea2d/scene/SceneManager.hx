package flea2d.scene;

import flea2d.gameobject.GameObjectManager;
import flea2d.content.Content;

class SceneManager {
	static var currentScene:Scene;
	static var isInitialized:Bool;
	static var onBegin:Void->Void;
	static var onEnd:Scene->Void;

	public static function loadScene(scene:Scene) {
		currentScene.removeContent(new Content(currentScene, onEnd));
		GameObjectManager.removeAllGameobjects();

		currentScene = scene;

		onBegin();

		var content:Content = new Content(currentScene, onEnd);
		currentScene.loadContent(content);

		if (content.contentToLoad == 0) {
			onEnd(currentScene);
		}
	}

	public static function initialize(initalScene:Scene, begin:Void->Void, end:Scene->Void) {
		if (!isInitialized) {
			currentScene = initalScene;
			onBegin = begin;
			onEnd = end;
			isInitialized = true;
		}
	}
}
