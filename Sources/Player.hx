import flea2d.core.Input;
import kha.math.Vector2;
import kha.Image;
import flea2d.gameobject.SpriteObject;

class Player extends SpriteObject {
	var directionHeading:Vector2;
	final speed:Float = 75;

	public function new(sprite:Image, position:Vector2, size:Vector2, rotation:Float) {
		super(sprite, position, size, rotation);
		tag = "player";
		directionHeading = new Vector2(1, -1);
	}

	public override function update(delta:Float) {
		if (Input.isKeyDown(D)) {
			position.x += 150 * delta;
		} else if (Input.isKeyDown(A)) {
			position.x -= 150 * delta;
		}
		// if (directionHeading.x > 0) {
		// 	directionHeading.x = 1;
		// }
		// if (directionHeading.x < 0) {
		// 	directionHeading.x = -1;
		// }
		// if (directionHeading.y > 0) {
		// 	directionHeading.y = 1;
		// }
		// if (directionHeading.y < 0) {
		// 	directionHeading.y = -1;
		// }

		// directionHeading = directionHeading.normalized();

		// directionHeading = directionHeading.mult(speed * delta);
		// position = position.add(directionHeading);

		// if (position.x > 320 - 16 || position.x < 0) {
		// 	directionHeading.x = -directionHeading.x;
		// } else if (position.y > 180 - 32 || position.y < -8) {
		// 	directionHeading.y = -directionHeading.y;
		// }
	}
}
