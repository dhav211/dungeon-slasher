package flea2d.gameobject;

import kha.Font;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import flea2d.core.Camera;
import flea2d.core.Utils;

class Text extends GameObject {
	var text:String;
	var textSize:Int;
	var font:Font;

	public function new(position:Vector2, size:Vector2, rotation:Float, text:String, textSize:Int, font:Font) {
		super();

		this.position = position;
		this.size = size;
		this.rotation = rotation;
		this.text = text;
		this.textSize = textSize;
		this.font = font;
		this.isVisible = true;
	}

	public override function render(graphics:Graphics, camera:Camera) {
		graphics.pushRotation(degToRad(rotation), size.x * 0.5 + position.x, size.y * 0.5 + position.y);
		graphics.font = font;
		graphics.fontSize = textSize;
		if (isVisible)
			graphics.drawString(text, position.x, position.y);
		graphics.popTransformation();
	}

	public function setText(newText:String) {
		text = newText;
	}
}
