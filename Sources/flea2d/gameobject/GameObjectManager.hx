package flea2d.gameobject;

import haxe.Exception;
import kha.math.Vector2;
import flea2d.gameobject.GameObject;
import flea2d.core.Input;
import kha.math.Vector2i;

typedef GameObjectData = {
	eventHandler:GameObjectEventHandler,
	type:GameObjectType,
	name:String,
	tag:String,
	isInRenderer:Bool,
}

/**
 * Defines the type the gameobject is, this sends it to the correct renderer.
 * Gameplay is a gameobject affected by camera position and moves about the screen. It can be a player, and enemy, floating text etc.
 * Data is a gameobject that isn't rendered. It could be a point in the screen, or simply unrelated data you want updated each frame.
 * A UI gameobject is a HUD element. It is uneffected by camera position and always draws on top of everything.
 * Debug gameobjects are gameobjects like collision circles, information for debug. Can be disabled easily.
 */
enum GameObjectType {
	Gameplay;
	Data;
	UI;
	Tilemap;
	Debug;
}

/**
	This a structure that holds all the event listeners for a gameobject.
**/
typedef GameObjectEventHandler = {
	hasMouseEntered:Bool,
	mouseEnter:() -> Void,
	mouseExit:() -> Void,
	mouseClick:(Vector2i) -> Void
}

class GameObjectManager {
	/**
		Holds the data for the gameobjects
	**/
	// static var gameObjectHolders:Array<GameObjectHolder> = new Array<GameObjectHolder>();
	static var gameObjects:Map<GameObject, GameObjectData> = new Map<GameObject, GameObjectData>();

	static var gameObjectsByName:Map<String, GameObject> = new Map<String, GameObject>();

	static var gameObjectsByTag:Map<String, Array<GameObject>> = new Map<String, Array<GameObject>>();

	static public var gameobjectRenderer(default, null):GameObjectRenderer = new GameObjectRenderer();

	public static function updateGameObjects(delta:Float) {
		// This will run through each gameobject and run it's onBeginFrame, update methods
		var mousePos:Vector2i = Input.getMouseScreenPosition();
		var gameObjectsToRemove:Array<GameObject> = new Array<GameObject>();

		for (gameObject in gameObjects.keys()) {
			gameObject.preUpdate(delta);
			gameObject.update(delta);
			checkMouseInputListeners(gameObject, mousePos);
			if (gameObject.shouldRemove) {
				// removeGameObjectFromRenderer(gameObject);
				// gameObjectHolders.remove(gameObjectHolders[i]);
				gameObjectsToRemove.push(gameObject);
			}
		}

		for (gameObject in gameObjectsToRemove) {
			removeGameObject(gameObject);
		}
	}

	/**
		Check the gameobjects to see if the mouse has entered, exited, or clicked on them.
	**/
	private static function checkMouseInputListeners(gameObject:GameObject, mousePos:Vector2i) {
		if (mousePos.x >= gameObject.position.x
			&& mousePos.x <= gameObject.position.x + gameObject.size.x
			&& mousePos.y >= gameObject.position.y
			&& mousePos.y <= gameObject.position.y + gameObject.size.y
			&& !gameObjects[gameObject].eventHandler.hasMouseEntered) {
			gameObjects[gameObject].eventHandler.mouseEnter();
			gameObjects[gameObject].eventHandler.hasMouseEntered = true;
		} else if ((mousePos.x < gameObject.position.x
			|| mousePos.x > gameObject.position.x + gameObject.size.x
			|| mousePos.y < gameObject.position.y
			|| mousePos.y > gameObject.position.y + gameObject.size.y)
			&& gameObjects[gameObject].eventHandler.hasMouseEntered) {
			gameObjects[gameObject].eventHandler.mouseExit();
			gameObjects[gameObject].eventHandler.hasMouseEntered = false;
		} else if (Input.isMouseButtonJustPressed(0) && gameObjects[gameObject].eventHandler.hasMouseEntered) {
			gameObjects[gameObject].eventHandler.mouseClick(mousePos);
		}
	}

	/**
	 * Create a gameobject to be updated and rendered.
	 * @param gameobject The gameobject to be created
	 * @param gameobjectType 
	 */
	public static function addGameObject<T:GameObject>(gameobject:T, ?gameobjectType:GameObjectType = Gameplay, ?name:String = ""):T {
		gameObjects.set(gameobject, createGameObjectData(gameobject, gameobjectType, name));

		// TODO add other gameobject types to correct renderer when implemented
		if (gameobjectType == Gameplay) {
			gameobjectRenderer.addGameObjectToRenderer(gameobject);
		}

		// Add the gameobject to the gameObjectByName map for easy access if the name is set.
		// If there is already a gameobject with that name it will replace the old one. Use a tag to hold multiple gameobjects
		if (name.length > 0) {
			if (gameObjectsByName.exists(name))
				trace(gameObjectsByName[name] + " is being replaced in gameObjectsByName map");

			gameObjectsByName.set(name, gameobject);
		}

		// Add the gameobject to the gameObjectsByTag map if the tag variable is set.
		if (gameobject.tag.length > 0) {
			if (gameObjectsByTag.exists(gameobject.tag)) {
				gameObjectsByTag[gameobject.tag].push(gameobject);
			} else { // No gameobject of this tag has been added before, create the key and an empty array to hold gameobjects
				gameObjectsByTag.set(gameobject.tag, new Array<GameObject>());
				gameObjectsByTag[gameobject.tag].push(gameobject);
			}
		}

		return gameobject;
	}

	/**
		Creates the gameobject holder from a gameobject, this includes the mouse interactions.
		@param object The gameobject you wish to create a handler for.
		@param mouseEnter The function that will be called when mouse enters gameobject
		@param mouseExit The function that will be called when mouse exits gameobject
		@param mouseClick The function that will be called then mouse clicks on gameobect
		@param gameobjectType Type of gameobject will be sorted into correct renderer
	**/
	private static function createGameObjectData(gameobject:GameObject, gameobjectType:GameObjectType = Gameplay, name:String):GameObjectData {
		var eventHandler:GameObjectEventHandler = gameobject.setGameObjectEventHandler();
		return {
			eventHandler: eventHandler,
			type: gameobjectType,
			name: name,
			tag: gameobject.tag,
			isInRenderer: false
		};
	}

	/**
	 * Get the gameobjects stored with the given tag, if the tag exists.
	 * @param tag Name of the tag that identifies the group of gameobjects
	 * @return The group of GameObjects
	 */
	public static function getGameObjectsByTag<T:GameObject>(tag:String):Array<T> {
		if (gameObjectsByTag.exists(tag)) {
			return cast(gameObjectsByTag[tag]);
		} else {
			trace("Can't find the gameobjects with the tag " + tag);
			return new Array<T>();
		}
	}

	/**
	 * Get the gameobject that matches the name given.
	 * @param name The name of the gameobject
	 * @return The single gameobject that matches the name
	 */
	public static function getGameObjectByName<T:GameObject>(name:String):T {
		if (gameObjectsByName.exists(name)) {
			return cast(gameObjectsByName[name]);
		} else {
			trace("Can't find gameobject with the name " + name);
			return null;
		}
	}

	/**
		Remove the gameobject from the program.
		@param gameobject The gameobject to remove.
	**/
	public static function removeGameObject(gameobject:GameObject) {
		if (gameobject == null) {
			return;
		}

		removeGameObjectFromRenderer(gameobject);

		// Remove the gameobject from the GameObjectsByName map
		if (gameObjects[gameobject].name.length > 0) {
			// Make sure the value is the same as the gameobject we are removing
			if (gameObjectsByName[gameObjects[gameobject].name] == gameobject) {
				gameObjectsByName.remove(gameObjects[gameobject].name);
			}
		}

		if (gameObjects[gameobject].tag.length > 0) {
			gameObjectsByTag[gameObjects[gameobject].tag].remove(gameobject);
		}

		gameObjects.remove(gameobject);
	}

	/**
	 * Remove gameobject from the correct renderer so it will no longer be drawn to screen.
	 * @param gameobject The gameobject you no longer want drawn
	 */
	private static function removeGameObjectFromRenderer(gameobject:GameObject) {
		// TODO check gameobject type and remove from correct renderer
		gameobjectRenderer.removeGameObjectFromRenderer(gameobject);
	}

	public static function shouldGameObjectBeRendered(gameObject:GameObject):Bool {
		return false;
	}
}
