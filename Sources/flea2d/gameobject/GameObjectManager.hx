package flea2d.gameobject;

import haxe.Exception;
import kha.math.Vector2;
import flea2d.gameobject.GameObject;
import flea2d.core.Input;
import kha.math.Vector2i;

typedef GameObjectHolder = {
	gameobject:GameObject,
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
	static var gameObjectHolders:Array<GameObjectHolder> = new Array<GameObjectHolder>();

	static var gameObjectsByName:Map<String, GameObject> = new Map<String, GameObject>();

	static var gameObjectsByTag:Map<String, Array<GameObject>> = new Map<String, Array<GameObject>>();

	static public var gameobjectRenderer(default, null):GameObjectRenderer = new GameObjectRenderer();

	public static function updateGameObjects(delta:Float) {
		// This will run through each gameobject and run it's onBeginFrame, update methods

		// get mouse screen position for checking input listeners
		// run the pre update
		// run the update function
		// check the gameobjects input listeners
		var mousePos:Vector2i = Input.getMouseScreenPosition();
		var i:Int = gameObjectHolders.length - 1;

		while (i >= 0) {
			gameObjectHolders[i].gameobject.preUpdate(delta);
			gameObjectHolders[i].gameobject.update(delta);
			checkMouseInputListeners(gameObjectHolders[i], mousePos);
			if (gameObjectHolders[i].gameobject.shouldRemove) {
				removeGameObjectFromRenderer(gameObjectHolders[i].gameobject);
				gameObjectHolders.remove(gameObjectHolders[i]);
			}
			i--;
		}
	}

	/**
		Check the gameobjects to see if the mouse has entered, exited, or clicked on them.
	**/
	public static function checkMouseInputListeners(gameObjectHolder:GameObjectHolder, mousePos:Vector2i) {
		if (mousePos.x >= gameObjectHolder.gameobject.position.x
			&& mousePos.x <= gameObjectHolder.gameobject.position.x + gameObjectHolder.gameobject.size.x
			&& mousePos.y >= gameObjectHolder.gameobject.position.y
			&& mousePos.y <= gameObjectHolder.gameobject.position.y + gameObjectHolder.gameobject.size.y
			&& !gameObjectHolder.eventHandler.hasMouseEntered) {
			gameObjectHolder.eventHandler.mouseEnter();
			gameObjectHolder.eventHandler.hasMouseEntered = true;
		} else if ((mousePos.x < gameObjectHolder.gameobject.position.x
			|| mousePos.x > gameObjectHolder.gameobject.position.x + gameObjectHolder.gameobject.size.x
			|| mousePos.y < gameObjectHolder.gameobject.position.y
			|| mousePos.y > gameObjectHolder.gameobject.position.y + gameObjectHolder.gameobject.size.y)
			&& gameObjectHolder.eventHandler.hasMouseEntered) {
			gameObjectHolder.eventHandler.mouseExit();
			gameObjectHolder.eventHandler.hasMouseEntered = false;
		} else if (Input.isMouseButtonJustPressed(0) && gameObjectHolder.eventHandler.hasMouseEntered) {
			gameObjectHolder.eventHandler.mouseClick(mousePos);
		}
	}

	/**
	 * Create a gameobject to be updated and rendered.
	 * @param gameobject The gameobject to be created
	 * @param gameobjectType 
	 */
	public static function addGameObject<T:GameObject>(gameobject:T, ?gameobjectType:GameObjectType = Gameplay, ?name:String = ""):T {
		gameObjectHolders.push(createGameObjectHolder(gameobject, gameobjectType, name));

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
	private static function createGameObjectHolder(gameobject:GameObject, gameobjectType:GameObjectType = Gameplay, name:String):GameObjectHolder {
		var eventHandler:GameObjectEventHandler = gameobject.setGameObjectEventHandler();
		return {
			gameobject: gameobject,
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

		// Needs to be searched in list of holders first before removed.
		var hasGameobjectBeenRemoved:Bool = false;
		while (!hasGameobjectBeenRemoved) {
			for (gameobjectHolder in gameObjectHolders) {
				if (gameobject == gameobjectHolder.gameobject) {
					// Remove the gameobject from the gameObjectsByName map if it is in there
					if (gameobjectHolder.name.length > 0) {
						if (gameObjectsByName[gameobjectHolder.name] == gameobject) {
							gameObjectsByName.remove(gameobjectHolder.name);
						}
					}

					// Remove the gameobject from the gameObjectsByTag map if it is in there
					if (gameobjectHolder.tag.length > 0) {
						gameObjectsByTag[gameobjectHolder.tag].remove(gameobject);
					}
					gameObjectHolders.remove(gameobjectHolder);
					hasGameobjectBeenRemoved = true;
					break;
				}
			}
		}
	}

	/**
	 * Remove gameobject from the correct renderer so it will no longer be drawn to screen.
	 * @param gameobject The gameobject you no longer want drawn
	 */
	private static function removeGameObjectFromRenderer(gameobject:GameObject) {
		// TODO check gameobject type and remove from correct renderer
		gameobjectRenderer.removeGameObjectFromRenderer(gameobject);
	}
}
