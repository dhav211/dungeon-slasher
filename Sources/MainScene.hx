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

	public override function initialize() {
		super.initialize();

		camera = new Camera(new Vector2(0, 0));
	}

	public override function update(delta:Float) {}

	public override function render(graphics:Graphics) {}
}
