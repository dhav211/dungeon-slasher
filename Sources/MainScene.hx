import core.tilemap.Tilemap;
import core.tilemap.TiledTilemapLoader;
import kha.math.Vector2i;
import core.App;
import core.Text;
import core.Camera;
import kha.math.Vector2;
import core.Utils.radToDeg;
import core.SpriteObject;
import kha.Assets;
import kha.graphics2.Graphics;
import core.Scene;

class MainScene extends Scene {
	var camera:Camera;
	var tilemap:Tilemap;
	var thing:SpriteObject;

	public override function initialize() {
		super.initialize();

		camera = new Camera(new Vector2(0, 0));
		thing = new SpriteObject(Assets.images.living_entities, new Vector2(0, 0), new Vector2(16, 16), 0);
		tilemap = TiledTilemapLoader.loadTilemap("Assets/test_dungeon.json", Assets.images.dungeon);
	}

	public override function update(delta:Float) {
		if (App.input.isKeyDown(Right)) {
			camera.position.x += 150 * delta;
		}
		if (App.input.isKeyDown(Down)) {
			camera.position.y += 150 * delta;
		}

		if (App.input.isKeyDown(Left)) {
			camera.position.x -= 150 * delta;
		}
		if (App.input.isKeyDown(Up)) {
			camera.position.y -= 150 * delta;
		}
	}

	public override function render(graphics:Graphics) {
		thing.render(graphics, camera);
		tilemap.render(graphics, camera);
	}
}
