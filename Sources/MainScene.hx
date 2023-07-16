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

class MainScene extends Scene {
	var camera:Camera;
	var tilemap:Tilemap;
	var thing:SpriteObject;
	var player:Player;
	var player2:Player;

	public override function initialize() {
		super.initialize();

		camera = new Camera(new Vector2(0, 0));
		thing = new SpriteObject(Assets.images.living_entities, new Vector2(), false, new Vector2(16, 32), 0, new Vector2(0, 48));
		player = new Player(Assets.images.living_entities, new Vector2(0, 0), new Vector2(16, 32), 0);
		player2 = new Player(Assets.images.living_entities, new Vector2(44, 0), new Vector2(16, 32), 0);
		tilemap = TiledTilemapLoader.loadTilemap("Assets/test_dungeon.json", Assets.images.dungeon);
	}

	public override function update(delta:Float) {
		tilemap.setTilemapRender(camera);
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
	}

	public override function render(graphics:Graphics) {
		// thing.render(graphics, camera);
		// player.render(graphics, camera);
		// tilemap.render(graphics, camera);
		GameObjectManager.gameobjectRenderer.render(graphics, camera);
	}
}
