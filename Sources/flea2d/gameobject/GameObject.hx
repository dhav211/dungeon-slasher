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
	public var isVisible:Bool = true;

	public function new() {
		GameObjectManager.addGameObject(this, onMouseEnter, onMouseExit, onMouseClick);
	}

	public function update(delta:Float) {}

	public function render(graphics:Graphics, camera:Camera) {}

	public function kill() {}

	public function destroy() {
		GameObjectManager.removeGameObject(this);
	}

	function onMouseEnter() {}

	function onMouseExit() {}

	function onMouseClick(mousePosition:Vector2i) {}
}
