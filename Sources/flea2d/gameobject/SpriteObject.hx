package flea2d.gameobject;

import kha.graphics2.Graphics;
import kha.Image;
import kha.math.Vector2;
import flea2d.core.Utils;
import flea2d.animation.AnimationPlayer;
import flea2d.core.Camera;

class SpriteObject extends GameObject {
	var sprite:Image;
	var animationPlayer:AnimationPlayer;
	var isAnimated:Bool;
	var spriteSheetPosition:Vector2;

	/**
		@param sprite The image file from kha assets
		@param position Position to instantiate sprite.
		@param isAnimated If false skips setting animation frames
		@param size Size of sprite in sheet, doesnt work as scaling
		@param layer Layer which sprite is drawn on
		@param rotation Rotation of sprite in degrees
		@param spriteSheetPosition if not animated this is the location on spritesheet where sprite is drawn from
	**/
	public function new(sprite:Image, ?position:Vector2, ?isAnimated:Bool = false, ?size:Vector2, ?layer:Int = 0, ?rotation:Float = 0,
			?spriteSheetPosition:Vector2) {
		super();
		this.position = position != null ? position : new Vector2(0, 0);
		this.sprite = sprite;
		this.size = size != null ? size : new Vector2(0, 0);
		this.rotation = rotation;
		this.radius = ((size.x + size.y) * 0.5) * 0.5;
		this.originPoint = new Vector2(size.x * 0.5, size.y * 0.5);
		this.isAnimated = isAnimated;
		this.spriteSheetPosition = spriteSheetPosition != null ? spriteSheetPosition : new Vector2(0, 0);

		animationPlayer = isAnimated ? new AnimationPlayer(setIsAnimated) : null;
	}

	public override function update(delta:Float) {
		if (isAnimated)
			animationPlayer.update(delta);
	}

	public override function render(graphics:Graphics, camera:Camera) {
		graphics.pushRotation(degToRad(rotation), size.x * 0.5 + position.x, size.y * 0.5 + position.y);
		graphics.pushTransformation(camera.getTransformation());
		if (isVisible)
			graphics.drawSubImage(sprite, position.x, position.y, isAnimated ? animationPlayer.getCurrentFrame().x : spriteSheetPosition.x,
				isAnimated ? animationPlayer.getCurrentFrame().y : spriteSheetPosition.y, size.x, size.y);
		graphics.popTransformation();
	}

	private function setIsAnimated() {
		isAnimated = true;
	}
}
