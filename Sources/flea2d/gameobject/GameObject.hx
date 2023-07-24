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
		// Check to see if gameobject should be rendered or not.
		// This will just be a function call to the GameObjectManager shouldBeRendered(this)
		// Here we will check to see if the gameobject is over the right type to be rendered.
		// We don't need to worry about UI, Tilemap, and Data types because these are always rendered or never rendered.
		// If it is of the right type then lets check to see if it's anywhere close the camera.
		// Get the position tolerance required. This will be determined by camera's position and screen width.
		// So camera position is 400, 600 and the screen width is 320, 180. The x tolerance is between 240 and 560, the
		// y tolerance is between 510 and 870. So the variables would be set up by
		// x1 = cameraPos.x - (width * 0.5)
		// x2 = cameraPos.x + width + (width * 0.5)
		// y1 = cameraPos.y - (height * 0.5)
		// y2 = cameraPos.y + height + (height * 0.5)
		// Theres probably a smart matrix implementation that's way faster and cleaner than this but I don't know it
		// Then check to see if the gameobjects position is within there, if yes, lets add it to the render list
		// this will also set the isInRenderer bool to true in the gameobjectHolder.
		// if the gameobject passes the tolerance test and is already in the renderer it doesn't need to be added again.
		// if it fails the tolerance test but happens to have bool isInRenderer true then remove it from the renderer and set
		// 		bool isInRenderer to false.
		// This will remove the need for clearing the list and it should keep it mostly sorted
		// once all gameobjects are accounted for sort the render list by y using the array.sort method like so . .

		//  renderList.sort(function(a, b) {
		// 	if (a.gameobject.position.y < b.gameobject.position.y) {
		// 		return 1;
		// 	} else if (a.gameobject.position.y > b.gameobject.position.y) {
		// 		return -1;
		// 	} else {
		// 		return 0;
		// 	}
		// });

		// now with this all in place. render from first to last
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
