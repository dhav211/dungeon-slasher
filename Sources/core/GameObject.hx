package core;

import kha.graphics2.Graphics;
import kha.math.Vector2;
import kha.math.Vector2i;

class GameObject {
	public var position:Vector2;
	public var size:Vector2;
	public var originPoint(default, null):Vector2;
	public var rotation:Float;
	public var radius:Float;
	public var isVisible:Bool = true;

	public function new() {
		App.gameObjectManager.addGameObject(this, onMouseEnter, onMouseExit, onMouseClick);
	}

	public function update(delta:Float) {}

	public function render(graphics:Graphics, camera:Camera) {}

	public function kill() {}

	public function destroy() {
		App.gameObjectManager.removeGameObject(this);
	}

	function onMouseEnter() {}

	function onMouseExit() {}

	function onMouseClick(mousePosition:Vector2i) {}
}
