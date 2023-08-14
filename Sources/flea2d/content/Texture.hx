package flea2d.content;

import kha.Image;

class Texture {
	public var image(default, null):Image;
	public var width(default, null):Int;
	public var height(default, null):Int;

	public function new(image:Image, width:Int, height:Int) {
		this.image = image;
		this.width = width;
		this.height = height;
	}
}
