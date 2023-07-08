package core.tilemap;

import kha.graphics5_.RenderTarget;
import kha.math.Vector2;
import haxe.ds.Vector;
import kha.graphics2.Graphics;
import kha.math.Vector2i;
import kha.Image;

typedef TilemapLayer = {
	var tiles:Array<Array<Vector2i>>;
}

class Tilemap extends GameObject {
	var tilemapSprite:Image;
	var tileRenderTarget:Image;
	var layers:Array<TilemapLayer>;
	var tileWidth:Int;
	var tileHeight:Int;
	var gridWidth:Int;
	var gridHeight:Int;

	public function new(tilemapSprite:Image, layers:Array<TilemapLayer>, tileWidth:Int, tileHeight:Int, gridWidth:Int, gridHeight:Int) {
		super();
		this.tilemapSprite = tilemapSprite;
		this.layers = layers;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		position = new Vector2();
		size = new Vector2();

		createRenderTarget();
	}

	public override function render(graphics:Graphics, camera:Camera) {
		if (!isVisible)
			return;

		graphics.pushTransformation(camera.getTransformation());
		graphics.drawImage(tileRenderTarget, 0, 0);
		graphics.popTransformation();
	}

	private function createRenderTarget() {
		tileRenderTarget = Image.createRenderTarget(tileWidth * gridWidth, tileHeight * gridHeight);
		var tileGraphics = tileRenderTarget.g2;

		tileGraphics.begin(false);
		for (layer in layers) {
			for (x in 0...gridWidth) {
				for (y in 0...gridHeight) {
					tileGraphics.drawSubImage(tilemapSprite, x * tileWidth, y * tileHeight, layer.tiles[x][y].x, layer.tiles[x][y].y, tileWidth, tileHeight);
				}
			}
		}
		tileGraphics.end();
	}
}
