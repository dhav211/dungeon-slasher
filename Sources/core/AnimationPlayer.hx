package core;

import kha.math.Vector2i;

class AnimationPlayer {
	/**
		All the animations that have been added
	**/
	var animations:Map<String, Animation>;

	/**
		The name of the current animation playing
	**/
	var currentAnimation:String;

	/**
		Animation time won't increase while true
	**/
	var isPaused:Bool;

	var isAnimationSet:Bool = false;

	var isAnimatedHandler:() -> Void;

	public function new(isAnimatedHandler:() -> Void) {
		this.isAnimatedHandler = isAnimatedHandler;
		animations = new Map<String, Animation>();
		isAnimationSet = false;
	}

	/**
		Add an animation to the animations String,Animation map
		@param name The name of the animation to add
		@param frames An array of vector2s which are the position on the spritesheet
		@param fps Speed of the animation
	**/
	public function addAnimation(name:String, frames:Array<Vector2i>, fps:Int) {
		var animation:Animation = new Animation(name, frames, fps);
		animations.set(name, animation);
		isAnimatedHandler();
	}

	/**
		Start an animation if it isn't already playing.
		@param name Name of the animation to play
	**/
	public function play(name:String) {
		if (currentAnimation != name) {
			isAnimationSet = true;
			currentAnimation = name;

			animations[currentAnimation].currentFrame = 0;
			animations[currentAnimation].currentFrameLength = 0;
		}
	}

	public function update(delta:Float) {
		// increase the animation frame time by delta if it isn't paused or not set.
		// once the frame time has reached frame length, then move to next frame or the first frame if it is the last
		if (!isPaused || !isAnimationSet) {
			animations[currentAnimation].currentFrameLength += delta;

			if (animations[currentAnimation].currentFrameLength >= animations[currentAnimation].frameLength) {
				animations[currentAnimation].currentFrame++;
				animations[currentAnimation].currentFrameLength = 0;
			}

			if (animations[currentAnimation].currentFrame >= animations[currentAnimation].numberOfFrames) {
				animations[currentAnimation].currentFrame = 0;
				// TODO Signal that the animation is done
			}
		}
	}

	/**
		Pause the animation
	**/
	public function pause() {
		isPaused = true;
	}

	/**
		Resume the animation
	**/
	public function resume() {
		isPaused = false;
	}

	/**
		Stop the animation
	**/
	public function stop() {
		isAnimationSet = false;
		currentAnimation = "";
	}

	/**
		Get the current frames vector2 position on the sprite sheet
		@return The vector2 position of the animation on the sprite sheet
	**/
	public function getCurrentFrame():Vector2i {
		if (isAnimationSet) {
			return animations[currentAnimation].frames[animations[currentAnimation].currentFrame];
		}

		return new Vector2i(0, 0);
	}
}
