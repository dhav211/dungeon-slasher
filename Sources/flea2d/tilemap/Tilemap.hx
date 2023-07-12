package flea2d.tilemap;

import kha.math.Vector2;
import kha.graphics2.Graphics;
import kha.math.Vector2i;
import kha.Image;
import flea2d.gameobject.GameObject;
import flea2d.core.App;
import flea2d.core.Camera;

typedef TilemapLayer = {
	var tiles:Array<Array<Vector2i>>;
}

class Tilemap extends GameObject {
	var tilemapSprite:Image;
	var tileRender:Image;
	var layers:Array<TilemapLayer>;
	var tileWidth:Int;
	var tileHeight:Int;
	var gridWidth:Int;
	var gridHeight:Int;
	var tileRenderPosition:Vector2;
	var renderWidth:Int;
	var renderHeight:Int;
	var hasRendered:Bool = false;

	public function new(tilemapSprite:Image, layers:Array<TilemapLayer>, tileWidth:Int, tileHeight:Int, gridWidth:Int, gridHeight:Int) {
		super();
		this.tilemapSprite = tilemapSprite;
		this.layers = layers;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		this.renderWidth = Std.int((App.gameWindow.virtualWidth * 3) / this.tileWidth);
		this.renderHeight = Std.int((App.gameWindow.virtualHeight * 3) / this.tileHeight);
		this.tileRenderPosition = new Vector2(0, 0);
		position = new Vector2();
		size = new Vector2();
	}

	public function setTilemapRender(camera:Camera) {
		if (shouldRenderTilemap(camera)) {
			createRender(camera);
			hasRendered = true;
		}
	}

	public override function render(graphics:Graphics, camera:Camera) {
		if (!isVisible)
			return;

		graphics.pushTransformation(camera.getTransformation());
		graphics.drawImage(tileRender, 0, 0);
		graphics.popTransformation();
	}

	private function createRender(camera:Camera) {
		tileRender = Image.createRenderTarget(Std.int(gridWidth * tileHeight), Std.int(gridWidth * tileHeight));
		var tileGraphics = tileRender.g2;
		tileRenderPosition = new Vector2(camera.position.x, camera.position.y);

		var xRenderGridStart:Int = Std.int((tileRenderPosition.x - App.gameWindow.virtualWidth) / tileWidth);
		var yRenderGridStart:Int = Std.int((tileRenderPosition.y - App.gameWindow.virtualHeight) / tileHeight);

		tileGraphics.begin(true);
		for (layer in layers) {
			for (x in xRenderGridStart...xRenderGridStart + renderWidth) {
				if (x >= 0 && x < gridWidth) {
					for (y in yRenderGridStart...yRenderGridStart + renderHeight) {
						if (y >= 0 && y < gridHeight) {
							tileGraphics.drawSubImage(tilemapSprite, x * tileWidth, y * tileHeight, layer.tiles[x][y].x, layer.tiles[x][y].y, tileWidth,
								tileHeight);
						}
					}
				}
			}
		}
		tileGraphics.end();
	}

	private function shouldRenderTilemap(camera:Camera):Bool {
		if (!hasRendered) {
			return true;
		} else if (camera.position.x > tileRenderPosition.x + App.gameWindow.virtualWidth * 0.5
			|| camera.position.x < tileRenderPosition.x - App.gameWindow.virtualWidth * 0.5
			|| camera.position.y > tileRenderPosition.y + App.gameWindow.virtualHeight * 0.5
			|| camera.position.y < tileRenderPosition.y - App.gameWindow.virtualHeight * 0.5) {
			return true;
		} else {
			return false;
		}
	}
}
