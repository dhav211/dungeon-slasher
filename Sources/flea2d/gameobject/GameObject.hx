package flea2d.gameobject;

import kha.graphics2.Graphics;
import kha.math.Vector2;
import kha.math.Vector2i;
import flea2d.gameobject.GameObjectManager;
import flea2d.core.Camera;

class GameObject {
	public var position:Vector2;
	public var size:Vector2;
	public var originPoint(default, null):Vector2;
	public var rotation:Float;
	public var radius:Float;
	public var layer(default, set):Int;
	public var tag(default, null):String;
	public var isVisible:Bool = true;
	public var shouldRemove(default, null):Bool;

	public function new() {
		layer = layer == null ? 0 : layer;
		tag = tag == null ? "" : tag;
	}

	public function update(delta:Float) {}

	public function render(graphics:Graphics, camera:Camera) {}

	public function preUpdate(delta:Float) {
		if (GameObjectManager.shouldGameObjectBeRendered(this)) {
			GameObjectManager.addGameObjectToRenderer(this);
		} else if (!GameObjectManager.shouldGameObjectBeRendered(this) && GameObjectManager.isGameObjectInRenderer(this)) {
			GameObjectManager.removeGameObjectFromRenderer(this);
		}
	}

	public function destroy() {
		GameObjectManager.removeGameObject(this);
	}

	/*
	 * Add the Gameobject as an UI object so it will remain static on the screen
	 */
	function setAsUIGameObject() {
		GameObjectManager.removeGameObject(this);
		GameObjectManager.addGameObject(this, UI);
	}

	function onMouseEnter() {}

	function onMouseExit() {}

	function onMouseClick(mousePosition:Vector2i) {}

	public function setGameObjectEventHandler():GameObjectEventHandler {
		return {
			hasMouseEntered: false,
			mouseClick: onMouseClick,
			mouseExit: onMouseExit,
			mouseEnter: onMouseEnter
		};
	}

	function set_layer(newLayer:Int) {
		// Change gameobjects layer in GameObjectRenderer
		return layer = newLayer;
	}
}
