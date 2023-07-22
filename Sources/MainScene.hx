import flea2d.gameobject.GameObjectManager;
import flea2d.tilemap.Tilemap;
import flea2d.tilemap.TiledTilemapLoader;
import flea2d.core.Camera;
import kha.math.Vector2;
import flea2d.gameobject.SpriteObject;
import kha.Assets;
import kha.graphics2.Graphics;
import flea2d.core.Scene;
import flea2d.core.Input;
import flea2d.core.CameraManager;

class MainScene extends Scene {
	var camera:Camera;
	var tilemap:Tilemap;
	var player:Player;

	public override function initialize() {
		super.initialize();
		player = addGameObject(new Player(Assets.images.living_entities, new Vector2(0, 0), new Vector2(16, 32), 0));
		camera = CameraManager.currentCamera;
	}

	public override function update(delta:Float) {
		// tilemap.setTilemapRender(camera);
		if (Input.isKeyDown(Right)) {
			camera.position.x += 2;
		}
		if (Input.isKeyDown(Down)) {
			camera.position.y += 2;
		}

		if (Input.isKeyDown(Left)) {
			camera.position.x -= 2;
		}
		if (Input.isKeyDown(Up)) {
			camera.position.y -= 2;
		}

		if (Input.isKeyJustPressed(X)) {
			GameObjectManager.removeGameObject(player);
		}
	}
}
