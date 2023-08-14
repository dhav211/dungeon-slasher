package flea2d.gameobject;

import flea2d.content.ContentManager;
import flea2d.content.Texture;
import flea2d.gameobject.GameObjectManager.GameObjectType;
import kha.graphics2.Graphics;
import kha.Image;
import kha.math.Vector2;
import flea2d.core.Utils;
import flea2d.animation.AnimationPlayer;
import flea2d.core.Camera;

class SpriteObject extends GameObject {
	var texture:Texture;
	var animationPlayer:AnimationPlayer;
	var isAnimated:Bool;
	var spriteSheetPosition:Vector2;

	/**
		@param texture The texture of the sprite
		@param position Position to instantiate sprite.
		@param isAnimated If false skips setting animation frames
		@param size Size of sprite in sheet, doesnt work as scaling
		@param layer Layer which sprite is drawn on
		@param rotation Rotation of sprite in degrees
		@param spriteSheetPosition if not animated this is the location on spritesheet where sprite is drawn from
	**/
	public function new(texture:Texture, ?position:Vector2, ?isAnimated:Bool = false, ?size:Vector2, ?layer:Int = 0, ?rotation:Float = 0,
			?spriteSheetPosition:Vector2) {
		super();
		this.position = position != null ? position : new Vector2(0, 0);
		this.texture = texture;
		this.size = size != null ? size : new Vector2(0, 0);
		this.rotation = rotation;
		this.radius = ((size.x + size.y) * 0.5) * 0.5;
		this.originPoint = new Vector2(size.x * 0.5, size.y * 0.5);
		this.isAnimated = isAnimated;
		this.spriteSheetPosition = spriteSheetPosition != null ? spriteSheetPosition : new Vector2(0, 0);

		animationPlayer = isAnimated ? new AnimationPlayer(setIsAnimated) : null;
	}

	public override function update(delta:Float) {}

	/**
	 * Sets the animation frame and position in the Gameobject Renderer. Do not override in children, use the Update function
	 */
	public override function preUpdate(delta:Float) {
		super.preUpdate(delta);

		if (isAnimated)
			animationPlayer.update(delta);

		// TODO check to see if this gameobject should be rendered to gameobject renderer
	}

	public override function render(graphics:Graphics, camera:Camera) {
		graphics.pushRotation(degToRad(rotation), size.x * 0.5 + position.x, size.y * 0.5 + position.y);
		graphics.pushTransformation(camera.getTransformation());
		if (isVisible)
			graphics.drawSubImage(texture.image, Std.int(position.x), Std.int(position.y),
				isAnimated ? animationPlayer.getCurrentFrame().x : spriteSheetPosition.x,
				isAnimated ? animationPlayer.getCurrentFrame().y : spriteSheetPosition.y, size.x, size.y);
		graphics.popTransformation();
	}

	private function setIsAnimated() {
		isAnimated = true;
	}
}
