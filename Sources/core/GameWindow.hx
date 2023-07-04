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

	public function new(x:Float, y:Float, width:Float, height:Float, virtualHeight:Float, virtualWidth:Float, scaleFactor:Float, rotation:Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.virtualWidth = virtualWidth;
		this.virtualHeight = virtualHeight;
		this.scale = new FastMatrix3(2, 0, 2.25, 0, 2, 0, 0, 0, 1);
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
