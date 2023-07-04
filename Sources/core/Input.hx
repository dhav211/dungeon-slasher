package core;

import kha.math.FastMatrix3;
import kha.math.FastVector2;
import kha.math.Vector2i;
import kha.input.KeyCode;
import kha.input.Keyboard;
import kha.input.Mouse;

enum ButtonState {
	Pressed;
	Down;
	Released;
	NotPressed;
}

typedef MouseState = {
	public var buttonStates:Array<ButtonState>;
	public var position:Vector2i;
}

class Input {
	/**
	 * Holds the current state of each button. Buttons are added as they are pressed. 
	 */
	private var keyStates:Map<KeyCode, ButtonState> = new Map<KeyCode, ButtonState>();

	/**
	 * Holds the button states of the mouse, added as they are pressed. Also holds current position of the mouse
	 */
	var mouseState:MouseState;

	public function new() {
		// These are the event handlers that will fire when a mouse or keyboard button is pressed/released/moved
		Keyboard.get().notify(onKeyDown, onKeyUp,);
		Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove);

		// set the default dumb values for the mouse
		mouseState = {buttonStates: [NotPressed, NotPressed, NotPressed], position: new Vector2i(0, 0)};
	}

	/**
	 * When the frame is finished, and heading into the next frame, switch the button states to their next state so you can know if they were just pressed,
	 * just released, or even just held.  This done for both the keyboard and the mouse. Called in the main loop.
	 */
	public function endFrame() {
		// Change keyboard keys state if need after end of frame
		for (key in keyStates.keys()) {
			if (keyStates[key] == Pressed) {
				keyStates[key] = Down;
			} else if (keyStates[key] == Released) {
				keyStates[key] = NotPressed;
			}
		}

		// Change mouse buttons state if need after end of frame
		for (i in 0...mouseState.buttonStates.length) {
			if (mouseState.buttonStates[i] == Pressed) {
				mouseState.buttonStates[i] = Down;
			} else if (mouseState.buttonStates[i] == Released) {
				mouseState.buttonStates[i] = NotPressed;
			}
		}
	}

	/**
	 * Check to see if given key is pressed/held. Will return each frame it's called.
	 * @param keycode The key to be checked
	 * @return If the keycode given is being pressed
	 */
	public function isKeyDown(keycode:KeyCode):Bool {
		if (keyStates.exists(keycode) && keyStates[keycode] == Down) {
			return true;
		}

		return false;
	}

	/**
	 * Check to see if given key is just pressed. Will only be return true one frame until released and pressed again.
	 * @param keycode The key to be checked
	 * @return If the keycode given was just pressed
	 */
	public function isKeyJustPressed(keycode:KeyCode):Bool {
		if (keyStates.exists(keycode) && keyStates[keycode] == Pressed) {
			return true;
		}

		return false;
	}

	/**
	 * Check to see if given key is just released. Will only return true one frame until pressed and released again.
	 * @param keycode The key to be checked
	 * @return If the keycode given is just released
	 */
	public function isKeyReleased(keycode:KeyCode):Bool {
		if (keyStates.exists(keycode) && keyStates[keycode] == Released) {
			return true;
		}

		return false;
	}

	/**
	 * Returns the mouse position in the window, factors in scaling and size of window.
	 * @return Mouse coordinates
	 */
	public function getMouseScreenPosition():Vector2i {
		var inverseScale:FastMatrix3 = App.gameWindow.scale.inverse();
		var mousePositionScaled = inverseScale.multvec(new FastVector2(mouseState.position.x, mouseState.position.y));

		return new Vector2i(Std.int(mousePositionScaled.x), Std.int(mousePositionScaled.y));
	}

	public function getMouseWorldPosition(camera:Camera):Vector2i {
		var mouseScreenPos = getMouseScreenPosition();
		var transformedPosition = camera.getTransformation().inverse().multvec(new FastVector2(mouseScreenPos.x, mouseScreenPos.y));
		return new Vector2i(Std.int(transformedPosition.x), Std.int(transformedPosition.y));
	}

	/**
	 * Check to see if given mouse button is pressed/held. Will return each frame it's called.
	 * @param keycode The key to be checked
	 * @return If the mouse button given was just pressed
	 */
	public function isMouseButtonDown(button:Int):Bool {
		if (mouseState.buttonStates[button] == Down) {
			return true;
		}

		return false;
	}

	/**
	 * Check to see if given mouse button is just pressed. Will only be return true one frame until released and pressed again.
	 * @param keycode The key to be checked
	 * @return If the mouse button given was just pressed
	 */
	public function isMouseButtonJustPressed(button:Int):Bool {
		if (mouseState.buttonStates[button] == Pressed) {
			return true;
		}

		return false;
	}

	/**
	 * Check to see if given key is just released. Will only return true one frame until pressed and released again.
	 * @param keycode The key to be checked
	 * @return If the mouse button given is just released
	 */
	public function isMouseButtonReleased(button:Int):Bool {
		if (mouseState.buttonStates[button] == Released) {
			return true;
		}

		return false;
	}

	/**
	 * Function is called when key is pressed. Adds key to key states if never pressed, then sets that key's key state to pressed.
	 * @param keycode The key to be checked
	 */
	private function onKeyDown(keycode:KeyCode) {
		if (keyStates.exists(keycode)) {
			keyStates[keycode] = Pressed;
		} else {
			keyStates.set(keycode, Pressed);
		}
	}

	/**
	 * Function is called when key is released. Sets that key's key state to released.
	 * @param keycode The key to be checked
	 */
	private function onKeyUp(keycode:KeyCode) {
		keyStates[keycode] = Released;
	}

	/**
	 * Function is called when mouse is pressed. Sets that mouse buttons state to pressed. Sets current mouse position.
	 * @param button The button to be checked
	 * @param x Mouse x position
	 * @param y Mouse y position
	 */
	private function onMouseDown(button:Int, x:Int, y:Int) {
		mouseState.buttonStates[button] = Pressed;
		mouseState.position = new Vector2i(x, y);
	}

	/**
	 * Function is called when mouse is released. Sets that mouse buttons state to released. Sets current mouse position.
	 * @param button The button to be checked
	 * @param x Mouse x position
	 * @param y Mouse y position
	 */
	private function onMouseUp(button:Int, x:Int, y:Int) {
		mouseState.buttonStates[button] = Released;
		mouseState.position = new Vector2i(x, y);
	}

	/**
	 * Function is called when mouse is moved. Sets the mouse position.
	 * @param oldX Last mouse x position 
	 * @param oldY Last mouse x position
	 * @param newX Current mouse x position
	 * @param newY Current mouse x position
	 */
	private function onMouseMove(oldX:Int, oldY:Int, newX:Int, newY:Int) {
		// TODO get move direction with newX/Y
		mouseState.position = new Vector2i(oldX, oldY);
	}
}
