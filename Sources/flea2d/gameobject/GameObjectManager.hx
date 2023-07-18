package flea2d.gameobject;

import flea2d.gameobject.GameObject;
import flea2d.core.Input;
import kha.math.Vector2i;

/**
	This a structure that holds all the event listeners for a gameobject.
**/
typedef GameObjectEventHandler = {
	object:GameObject,
	hasMouseEntered:Bool,
	mouseEnter:() -> Void,
	mouseExit:() -> Void,
	mouseClick:(Vector2i) -> Void
}

class GameObjectManager {
	/**
		Holds the event handlers for each gameobject in use
	**/
	static var gameObjectEventHandlers:Array<GameObjectEventHandler> = new Array<GameObjectEventHandler>();

	static public var gameobjectRenderer(default, null):GameObjectRenderer = new GameObjectRenderer();

	/**
		Check the gameobjects to see if the mouse has entered, exited, or clicked on them.
	**/
	public static function checkMouseInputListeners() {
		var mousePos = Input.getMouseScreenPosition();
		// TODO this is rather wasteful, in the future we should only check for gameobjects that are on or near the screen. This will probably
		// involve a 2D array that is the size of games map and gameobjects will be placed there based upon their position
		for (gameObject in gameObjectEventHandlers) {
			if (mousePos.x >= gameObject.object.position.x
				&& mousePos.x <= gameObject.object.position.x + gameObject.object.size.x
				&& mousePos.y >= gameObject.object.position.y
				&& mousePos.y <= gameObject.object.position.y + gameObject.object.size.y
				&& !gameObject.hasMouseEntered) {
				gameObject.mouseEnter();
				gameObject.hasMouseEntered = true;
			} else if ((mousePos.x < gameObject.object.position.x
				|| mousePos.x > gameObject.object.position.x + gameObject.object.size.x
				|| mousePos.y < gameObject.object.position.y
				|| mousePos.y > gameObject.object.position.y + gameObject.object.size.y)
				&& gameObject.hasMouseEntered) {
				gameObject.mouseExit();
				gameObject.hasMouseEntered = false;
			} else if (Input.isMouseButtonJustPressed(0) && gameObject.hasMouseEntered) {
				gameObject.mouseClick(mousePos);
			}
		}
	}

	/**
	 * Update required variables of gameobjects on start of frame. Do not call this, this is called form Project script.
	 * @param delta The time passed since last frame
	 */
	public static function onBeginFrame(delta:Float) {
		for (gameobject in gameObjectEventHandlers) {
			gameobject.object.onBeginFrame(delta);
		}
	}

	/**
		Adds gameobject the the renderer to be rendered on each frame.
		@param object The gameobject you wish to create a handler for.
		@param mouseEnter The function that will be called when mouse enters gameobject
		@param mouseExit The function that will be called when mouse exits gameobject
		@param mouseClick The function that will be called then mouse clicks on gameobect
	**/
	public static function addGameObject(object:GameObject, mouseEnter:() -> Void, mouseExit:() -> Void, mouseClick:(Vector2i) -> Void) {
		createGameObjectEventHandler(object, mouseEnter, mouseExit, mouseClick);
		gameobjectRenderer.addGameObjectToRenderer(object, object.layer);
	}

	/**
		Adds gameobject the UI renderer to be rendered on top of the game statically each frame.
		@param object The gameobject you wish to create a handler for.
		@param mouseEnter The function that will be called when mouse enters gameobject
		@param mouseExit The function that will be called when mouse exits gameobject
		@param mouseClick The function that will be called then mouse clicks on gameobect
	**/
	public static function addUIGameObject(object:GameObject, mouseEnter:() -> Void, mouseExit:() -> Void, mouseClick:(Vector2i) -> Void) {
		createGameObjectEventHandler(object, mouseEnter, mouseExit, mouseClick);
		// gameobjectRenderer.addGameObjectToRenderer(object, object.layer);
		// TODO create a UIRenderer that draws to the screen statically
	}

	/**
		Create an event handler for a new gameobject and add it to the gameobject event handler list.
		@param object The gameobject you wish to create a handler for.
		@param mouseEnter The function that will be called when mouse enters gameobject
		@param mouseExit The function that will be called when mouse exits gameobject
		@param mouseClick The function that will be called then mouse clicks on gameobect
	**/
	private static function createGameObjectEventHandler(object:GameObject, mouseEnter:() -> Void, mouseExit:() -> Void, mouseClick:(Vector2i) -> Void) {
		gameObjectEventHandlers.push({
			object: object,
			hasMouseEntered: false,
			mouseEnter: mouseEnter,
			mouseExit: mouseExit,
			mouseClick: mouseClick
		});
	}

	/**
		Remove the gameobject event handler from the program.
		@param gameobject The gameobject to remove the event handler of.
	**/
	public static function removeGameObject(gameobject:GameObject) {
		var hasGameobjectBeenRemoved:Bool = false;
		while (!hasGameobjectBeenRemoved) {
			for (objectHandler in gameObjectEventHandlers) {
				if (gameobject == objectHandler.object) {
					gameObjectEventHandlers.remove(objectHandler);
					hasGameobjectBeenRemoved = true;
					break;
				}
			}
		}

		gameobjectRenderer.removeGameObjectFromRenderer(gameobject, gameobject.layer);
	}
}
