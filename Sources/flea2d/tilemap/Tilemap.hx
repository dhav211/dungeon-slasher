package flea2d.tilemap;

import flea2d.content.Texture;
import flea2d.core.CameraManager;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import kha.math.Vector2i;
import kha.Image;
import flea2d.gameobject.GameObject;
import flea2d.core.GameWindow;
import flea2d.core.Camera;

typedef TilemapLayer = {
	var tiles:Array<Array<Vector2i>>;
}

typedef Cell = {
	var x:Int;
	var y:Int;
	var source:Vector2i;
	var isEmpty:Bool;
}

typedef XYBounds = {
	var lowestX:Int;
	var highestX:Int;
	var lowestY:Int;
	var highestY:Int;
}

typedef Layer = {
	var width:Int;
	var height:Int;
	var xyBounds:XYBounds;
	var cells:Array<Array<Cell>>;
}

class Tilemap extends GameObject {
	var texture:Texture;
	var tileRender:Image;
	var layers:Map<String, Layer>;
	var tileWidth:Int;
	var tileHeight:Int;
	var gridWidth:Int;
	var gridHeight:Int;
	var tileRenderPosition:Vector2;
	var renderWidth:Int;
	var renderHeight:Int;
	var hasRendered:Bool = false;
	var isTilemapEmpty:Bool = true;

	public function new(texture:Texture, tileSize:Int) {
		super();
		this.texture = texture;
		this.layers = new Map<String, Layer>();
		this.tileWidth = tileSize;
		this.tileHeight = tileSize;
		this.renderWidth = Std.int((GameWindow.virtualWidth * 3) / this.tileWidth);
		this.renderHeight = Std.int((GameWindow.virtualHeight * 3) / this.tileHeight);
		this.tileRenderPosition = new Vector2(0, 0);
		position = new Vector2();
		size = new Vector2();
	}

	public override function preUpdate(delta:Float) {
		super.preUpdate(delta);
	}

	public override function update(delta:Float) {
		super.update(delta);

		if (shouldRenderTilemap(CameraManager.currentCamera)) {
			// createRender(CameraManager.currentCamera);
			hasRendered = true;
		}
	}

	public function addLayer(layerName:String) {
		layers.set(layerName, {
			cells: new Array<Array<Cell>>(),
			height: 1,
			width: 1,
			xyBounds: {
				lowestX: 0,
				highestX: 0,
				lowestY: 0,
				highestY: 0
			}
		});

		layers[layerName].cells.push([createEmptyCell()]);
	}

	public function addCell(x:Int, y:Int, source:Vector2i, layerName:String) {
		if (layerName == "") {
			trace("Layer name is undefined in addCell!");
			return;
		}

		if (!layers.exists(layerName)) {
			addLayer(layerName);
		}
		var shouldChangeSize = setShouldChangeSize(x, y, layers[layerName].xyBounds);
		var xShift:Int = setXShift(x, layers[layerName].xyBounds);
		var yShift:Int = setYShift(y, layers[layerName].xyBounds);

		layers[layerName].xyBounds = setXYBounds(x, y, layers[layerName].xyBounds.lowestX, layers[layerName].xyBounds.highestX,
			layers[layerName].xyBounds.lowestY, layers[layerName].xyBounds.highestY, isTilemapEmpty);

		if (shouldChangeSize && !isTilemapEmpty) {
			var absoluteXShift = Std.int(Math.abs(xShift));
			if (absoluteXShift > 0) {
				expandColumns(layerName, absoluteXShift);
				if (xShift < 0) {
					shiftColumnsOver(layerName, absoluteXShift);
				}
			}

			var absoluteYShift = Std.int(Math.abs(yShift));
			if (absoluteYShift > 0) {
				expandRows(layerName, absoluteYShift);

				if (yShift < 0) {
					shiftRowsDown(layerName, absoluteYShift);
				}
			}
		} else if (isTilemapEmpty) {
			isTilemapEmpty = false;
		}

		var xOffset:Int = x - layers[layerName].xyBounds.lowestX;
		var yOffSet:Int = y - layers[layerName].xyBounds.lowestY;
		layers[layerName].cells[yOffSet][xOffset] = {
			x: x,
			y: y,
			isEmpty: false,
			source: source
		};

		gridWidth = setGridWidth(layerName);
		gridHeight = setGridHeight(layerName);

		createRender(CameraManager.currentCamera);
	}

	function createEmptyCell():Cell {
		return {
			x: 0,
			y: 0,
			isEmpty: true,
			source: null
		};
	}

	function setXYBounds(x:Int, y:Int, lowestX:Int, highestX:Int, lowestY:Int, highestY:Int, isTilemapEmpty:Bool):XYBounds {
		var xyBounds:XYBounds = {
			lowestX: lowestX,
			highestX: highestX,
			lowestY: lowestY,
			highestY: highestY
		};

		if (isTilemapEmpty) {
			xyBounds.lowestX = x;
			xyBounds.highestX = x;
			xyBounds.lowestY = y;
			xyBounds.highestY = y;
		} else {
			if (x < xyBounds.lowestX) {
				xyBounds.lowestX = x;
			} else if (x > xyBounds.highestX) {
				xyBounds.highestX = x;
			}

			if (y < xyBounds.lowestY) {
				xyBounds.lowestY = y;
			} else if (y > xyBounds.highestY) {
				xyBounds.highestY = y;
			}
		}

		return xyBounds;
	}

	function setXShift(x:Int, xyBounds:XYBounds):Int {
		var xShift = 0;

		if (x < xyBounds.lowestX) {
			xShift = x - xyBounds.lowestX;
		} else if (x > xyBounds.highestX) {
			xShift = x - xyBounds.highestX;
		}

		return xShift;
	}

	function setYShift(y:Int, xyBounds:XYBounds):Int {
		var yShift = 0;

		if (y < xyBounds.lowestY) {
			yShift = y - xyBounds.lowestY;
			xyBounds.lowestY = y;
		} else if (y > xyBounds.highestY) {
			yShift = y - xyBounds.highestY;
			xyBounds.highestY = y;
		}

		return yShift;
	}

	function setShouldChangeSize(x:Int, y:Int, currentXYBounds:XYBounds):Bool {
		var shouldChange:Bool = false;

		if (x < currentXYBounds.lowestX) {
			shouldChange = true;
		} else if (x > currentXYBounds.highestX) {
			shouldChange = true;
		}

		if (y < currentXYBounds.lowestY) {
			shouldChange = true;
		} else if (y > currentXYBounds.highestY) {
			shouldChange = true;
		}
		return shouldChange;
	}

	function shiftRowsDown(layerName:String, absoluteYShift:Int) {
		var i = layers[layerName].cells.length - 1;

		while (i >= absoluteYShift) {
			layers[layerName].cells[i] = new Array<Cell>();
			for (j in 0...layers[layerName].cells[i - absoluteYShift].length) {
				layers[layerName].cells[i].push({
					x: layers[layerName].cells[i - absoluteYShift][j].x,
					y: layers[layerName].cells[i - absoluteYShift][j].y,
					isEmpty: layers[layerName].cells[i - absoluteYShift][j].isEmpty,
					source: new Vector2i(layers[layerName].cells[i - absoluteYShift][j].source.x, layers[layerName].cells[i - absoluteYShift][j].source.y)
				});
			}

			layers[layerName].cells[i - absoluteYShift] = [
				for (j in 0...layers[layerName].cells[i - absoluteYShift].length)
					createEmptyCell()
			];

			i--;
		}
	}

	function shiftColumnsOver(layerName:String, absoluteXShift:Int) {
		for (row in layers[layerName].cells) {
			var i = layers[layerName].width - 1;

			while (i >= 0) {
				if (i + absoluteXShift < layers[layerName].width - 1) {
					row[i + absoluteXShift] = row[i];
				}

				i--;
			}
		}
	}

	function expandColumns(layerName:String, absoluteXShift:Int) {
		var newSize:Int = layers[layerName].width + absoluteXShift;
		layers[layerName].width = newSize;

		for (row in layers[layerName].cells) {
			for (i in 0...absoluteXShift) {
				row.push(createEmptyCell());
			}
		}
	}

	function expandRows(layerName:String, absoluteYShift:Int) {
		var newSize:Int = layers[layerName].height + absoluteYShift;
		layers[layerName].height = newSize;

		for (i in 0...absoluteYShift) {
			layers[layerName].cells.push([
				for (j in 0...layers[layerName].width)
					createEmptyCell()
			]);
		}
	}

	function setGridWidth(layerName:String):Int {
		return layers[layerName].width > gridWidth ? layers[layerName].width : gridHeight;
	}

	function setGridHeight(layerName:String):Int {
		return layers[layerName].height > gridHeight ? layers[layerName].height : gridHeight;
	}

	public override function render(graphics:Graphics, camera:Camera) {
		if (isVisible) {
			graphics.pushTransformation(camera.getTransformation());
			graphics.drawImage(tileRender, 0, 0);
			// for (layer in layers) {
			// 	for (y in 0...layer.height) {
			// 		for (x in 0...layer.width) {
			// 			// trace(x + " / " + y);
			// 			if (!layer.cells[y][x].isEmpty) {
			// 				graphics.drawSubImage(texture.image, layer.cells[y][x].x * tileWidth, layer.cells[y][x].y * tileHeight,
			// 					layer.cells[y][x].source.x, layer.cells[y][x].source.y, tileWidth, tileHeight);
			// 			}
			// 		}
			// 	}
			// }
			graphics.popTransformation();
		}
	}

	private function createRender(camera:Camera) {
		tileRender = Image.createRenderTarget(Std.int(gridWidth * tileWidth), Std.int(gridHeight * tileHeight));
		var tileGraphics = tileRender.g2;
		tileGraphics.begin(false);

		for (layer in layers) {
			for (y in 0...layer.height) {
				for (x in 0...layer.width) {
					if (!layer.cells[y][x].isEmpty) {
						tileGraphics.drawSubImage(texture.image, layer.cells[y][x].x * tileWidth, layer.cells[y][x].y * tileHeight,
							layer.cells[y][x].source.x, layer.cells[y][x].source.y, tileWidth, tileHeight);
					}
				}
			}
		}
		// tileRenderPosition = new Vector2(camera.position.x, camera.position.y);

		// var xRenderGridStart:Int = Std.int((tileRenderPosition.x - GameWindow.virtualWidth) / tileWidth);
		// var yRenderGridStart:Int = Std.int((tileRenderPosition.y - GameWindow.virtualHeight) / tileHeight);

		// tileGraphics.begin(false);
		// for (layer in layers) {
		// 	for (x in xRenderGridStart...xRenderGridStart + renderWidth) {
		// 		if (x >= 0 && x < gridWidth) {
		// 			for (y in yRenderGridStart...yRenderGridStart + renderHeight) {
		// 				if (y >= 0 && y < gridHeight) {
		// 					tileGraphics.drawSubImage(texture.image, x * tileWidth, y * tileHeight, layer.tiles[x][y].x, layer.tiles[x][y].y, tileWidth,
		// 						tileHeight);
		// 				}
		// 			}
		// 		}
		// 	}
		// }
		tileGraphics.end();
	}

	private function shouldRenderTilemap(camera:Camera):Bool {
		if (!hasRendered) {
			return true;
		} else if (camera.position.x > tileRenderPosition.x + GameWindow.virtualWidth * 0.5
			|| camera.position.x < tileRenderPosition.x - GameWindow.virtualWidth * 0.5
			|| camera.position.y > tileRenderPosition.y + GameWindow.virtualHeight * 0.5
			|| camera.position.y < tileRenderPosition.y - GameWindow.virtualHeight * 0.5) {
			return true;
		} else {
			return false;
		}
	}
}
