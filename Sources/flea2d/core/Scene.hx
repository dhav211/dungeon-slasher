package flea2d.core;

import flea2d.gameobject.GameObjectManager;
import flea2d.gameobject.GameObject;

class Scene {
	public function new() {}

	public function initialize() {}

	public function loadContent() {}

	public function removeContent() {}

	public function update(delta:Float) {}

	/**
	 * Add a gameobject to the scene
	 * @param gameobject The gameobject to be added
	 * @param gameobjectType The type of the gameobject, sends it to correct renderer
	 */
	function addGameObject<T:GameObject>(gameobject:T, gameobjectType:GameObjectType = Gameplay):T {
		GameObjectManager.addGameObject(gameobject, gameobjectType);

		return gameobject;
	}
}
