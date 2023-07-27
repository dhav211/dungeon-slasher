package flea2d.gameobject;

import kha.graphics2.Graphics;
import flea2d.core.Camera;
import flea2d.gameobject.GameObject;

class GameObjectRenderer {
	var gameobjectByLayer:Array<Array<GameObject>>;

	public function new() {
		gameobjectByLayer = new Array<Array<GameObject>>();
		gameobjectByLayer.push(new Array<GameObject>());
	}

	/**
	 * Adds gameobject to renderer and puts then in the index of the array based on its layer
	 * @param gameobject The gameobject to be rendered
	 * @param layer Lower layers get drawn first, higher last. Higher layers will be on top of lower layers
	 */
	public function addGameObjectToRenderer(gameobject:GameObject) {
		// Check to see if the gameobjectByLayer array has enough indexes as given layer.
		// If not then loop thru the layer adding a layer until you've reached the layer number
		// This will prevent possible overflows
		if (gameobjectByLayer.length <= gameobject.layer) {
			for (i in 0...gameobject.layer) {
				if (i <= gameobjectByLayer.length) {
					gameobjectByLayer.push(new Array<GameObject>());
				}
			}
		}
		gameobjectByLayer[gameobject.layer].push(gameobject);
	}

	public function removeGameObjectFromRenderer(gameobject:GameObject) {
		// exit function if the array has less indexes than size of given layer to avoid overflow
		if (gameobjectByLayer.length - 1 < gameobject.layer)
			return;

		gameobjectByLayer[gameobject.layer].remove(gameobject);
	}

	public function changeGameObjectsLayer(gameobject:GameObject, currentLayer:Int, newLayer:Int) {}

	public function render(graphics:Graphics, camera:Camera, isYSorted:Bool = false) {
		for (layer in gameobjectByLayer) {
			if (isYSorted) {
				ySortGameObjectsInLayer(layer);
			}
			for (gameobject in layer) {
				gameobject.render(graphics, camera);
			}
		}
	}

	private function ySortGameObjectsInLayer(layer:Array<GameObject>) {
		layer.sort(function name(a, b) {
			if (a.position.y < b.position.y) {
				return -1;
			} else if (a.position.y > b.position.y) {
				return 1;
			} else {
				return 0;
			}
		});
	}
}
