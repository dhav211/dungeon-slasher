package flea2d.core;

import kha.math.FastMatrix3;

class GameWindow {
	public static var x(default, null):Float;
	public static var y(default, null):Float;
	public static var width(default, null):Float;
	public static var height(default, null):Float;
	public static var virtualWidth(default, null):Float;
	public static var virtualHeight(default, null):Float;
	public static var scaleFactor(default, null):Float;
	public static var scale(default, default):FastMatrix3;
	public static var rotation(default, null):Float;

	/**
		A constructor replacement as the class is static
	**/
	public static function set(newWidth:Float, newHeight:Float, newVirtualWidth:Float, newVirtualHeight:Float, newScale:FastMatrix3, newScaleFactor:Float, newRotation:Float) {
		width = newWidth;
		height = newHeight;
		virtualWidth = newVirtualWidth;
		virtualHeight = newVirtualHeight;
		scale = newScale;
		scaleFactor = newScaleFactor;
		rotation = newRotation;
	}

	/**
		Sets the size and scale values when window is resized
	**/
	public static function resize(newWidth:Float, newHeight:Float, newScale:FastMatrix3) {
		width = newWidth;
		height = newHeight;
		scale = newScale;
	}
}
