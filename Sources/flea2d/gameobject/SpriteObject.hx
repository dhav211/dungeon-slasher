package flea2d.gameobject;

import kha.math.FastMatrix3;
import kha.graphics2.Graphics;
import kha.Image;
import kha.graphics4.Graphics2;
import kha.math.Vector2;
import flea2d.core.Utils;
import flea2d.animation.AnimationPlayer;
import flea2d.core.Camera;

class SpriteObject extends GameObject {
	var sprite:Image;
	var animationPlayer:AnimationPlayer;
	var isAnimated:Bool;

	/**
		@param sprite The image file from kha assets
		@param position Position to instantiate sprite.
		@param size Size of sprite in sheet, doesnt work as scaling
		@param rotation Rotation of sprite in degrees
	**/
	public function new(sprite:Image, position:Vector2, size:Vector2, rotation:Float) {
		super();
		this.position = position;
		this.sprite = sprite;
		this.size = size;
		this.rotation = rotation;
		this.radius = ((size.x + size.y) * 0.5) * 0.5;
		this.originPoint = new Vector2(size.x * 0.5, size.y * 0.5);
		animationPlayer = new AnimationPlayer(setIsAnimated);
	}

	public override function update(delta:Float) {
		if (isAnimated)
			animationPlayer.update(delta);
	}

	public override function render(graphics:Graphics, camera:Camera) {
		graphics.pushRotation(degToRad(rotation), size.x * 0.5 + position.x, size.y * 0.5 + position.y);
		graphics.pushTransformation(camera.getTransformation());
		if (isVisible)
			graphics.drawSubImage(sprite, position.x, position.y, animationPlayer.getCurrentFrame().x, animationPlayer.getCurrentFrame().y, size.x, size.y);
		graphics.popTransformation();
	}

	private function setIsAnimated() {
		isAnimated = true;
	}
}
