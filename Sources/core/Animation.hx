package core;

import kha.math.Vector2i;

class Animation {
	public var name:String;

	/**
		Frame of the animation, each are a coordinate on the sprite sheet
	**/
	public var frames:Array<Vector2i>;

	public var numberOfFrames:Int;
	public var currentFrame:Int;

	/**
		Length of the time for each frame
	**/
	public var frameLength:Float;

	/**
		Current amount of time on frame, once this has reached frameLength it will reset to 0
	**/
	public var currentFrameLength:Float;

	/**
		Lets animation player know if it needs to reset the animation once frameLength has been reached
	**/
	public var isLooped:Bool;

	public function new(name:String, frames:Array<Vector2i>, fps:Int, ?isLooped:Bool = true) {
		this.name = name;
		this.frames = frames;
		numberOfFrames = frames.length;
		currentFrame = 0;
		frameLength = fps / 60;
		currentFrameLength = 0;
		this.isLooped = isLooped;
	}
}
