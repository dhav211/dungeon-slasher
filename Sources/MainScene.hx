import flea2d.content.ContentManager;
import flea2d.gameobject.GameObject;
import kha.math.Random;
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

	public override function initialize() {
		super.initialize();
		ContentManager.loadTexture("living_entities.png", "entities");
		addGameObject(new Player("entities", new Vector2(50, 80), new Vector2(16, 32), 0), "player");
		// addGameObject(new Player(ContentManager.getTexture("entities"), new Vector2(50, 70), new Vector2(16, 32), 0), "player");
		// addGameObject(new Player(ContentManager.getTexture("entities"), new Vector2(50, 60), new Vector2(16, 32), 0), "player");
		// addGameObject(new Player(ContentManager.getTexture("entities"), new Vector2(50, 50), new Vector2(16, 32), 0), "player");
		camera = CameraManager.currentCamera;
		// Assets.loadImageFromPath("Assets/living_entities.png");
	}

	public override function update(delta:Float) {}
}
