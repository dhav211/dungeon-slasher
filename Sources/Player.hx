import kha.math.Vector2;
import kha.Image;
import flea2d.gameobject.SpriteObject;

class Player extends SpriteObject {
	public function new(sprite:Image, position:Vector2, size:Vector2, rotation:Float) {
		layer = 1;
		super(sprite, position, size, rotation);
	}
}
