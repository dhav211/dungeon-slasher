package core;

import kha.math.FastMatrix3;

class GameWindow {
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var width(default, null):Float;
	public var height(default, null):Float;
	public var virtualWidth(default, null):Float;
	public var virtualHeight(default, null):Float;
	public var scaleFactor(default, null):Float;
	public var scale(default, default):FastMatrix3;
	public var rotation(default, null):Float;

	public function new(x:Float, y:Float, width:Float, height:Float, virtualWidth:Float, virtualHeight:Float, scaleFactor:Float, rotation:Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.virtualWidth = virtualWidth;
		this.virtualHeight = virtualHeight;
		this.scale = FastMatrix3.identity();
		this.scaleFactor = scaleFactor;
		this.rotation = rotation;
	}

	public function setGameWindow(x:Float, y:Float, width:Float, height:Float, scale:FastMatrix3, scaleFactor:Float, rotation:Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.scaleFactor = scaleFactor;
		this.scale = scale;
		this.rotation = rotation;
	}
}
