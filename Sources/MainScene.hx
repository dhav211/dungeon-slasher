import flea2d.content.Content;
import kha.math.Vector2i;
import flea2d.content.ContentManager;
import flea2d.tilemap.Tilemap;
import flea2d.core.Camera;
import kha.math.Vector2;
import flea2d.scene.Scene;
import flea2d.core.Input;
import flea2d.core.CameraManager;

class MainScene extends Scene {
	var camera:Camera;
	var tilemap:Tilemap;

	public override function loadContent(content:Content) {
		content.loadTexture("living_entities.png", "entities");
		content.loadTexture("dungeon.png", "dungeon");
		content.loadJson("test_dungeon.json", "dungeon");
	}

	public override function initialize() {
		super.initialize();
		addGameObject(new Player(ContentManager.getTexture("entities"), new Vector2(32, 64), new Vector2(16, 32), 0), "player");
		tilemap = addGameObject(new Tilemap(ContentManager.getTexture("dungeon"), 16));

		// tilemap.addCell(2, 1, new Vector2i(16, 64), "floor");
		// tilemap.addCell(0, 1, new Vector2i(16, 64), "floor");
		// tilemap.addCell(-1, 1, new Vector2i(16, 64), "floor");
		// tilemap.addCell(1, 0, new Vector2i(16, 64), "floor");
		// tilemap.addCell(1, 1, new Vector2i(16, 64), "floor");
		for (x in 0...15) {
			for (y in 0...15) {
				tilemap.addCell(x, y, new Vector2i(16, 64), "floor");
			}
		}
		// addGameObject(new Player(ContentManager.getTexture("entities"), new Vector2(50, 70), new Vector2(16, 32), 0), "player");
		// addGameObject(new Player(ContentManager.getTexture("entities"), new Vector2(50, 60), new Vector2(16, 32), 0), "player");
		// addGameObject(new Player(ContentManager.getTexture("entities"), new Vector2(50, 50), new Vector2(16, 32), 0), "player");
		// addGameObject(TiledTilemapLoader.loadTilemap(ContentManager.getJson("dungeon"), ContentManager.getTexture("dungeon")));
		camera = CameraManager.currentCamera;
	}

	public override function update(delta:Float) {
		if (Input.isKeyDown(Left)) {
			camera.position = camera.position.sub(new Vector2(1, 0));
		}
		if (Input.isKeyDown(Up)) {
			camera.position = camera.position.sub(new Vector2(0, 1));
		}
		if (Input.isKeyDown(Right)) {
			camera.position = camera.position.sub(new Vector2(-1, 0));
		}
		if (Input.isKeyDown(Down)) {
			camera.position = camera.position.sub(new Vector2(0, -1));
		}
	}
}
