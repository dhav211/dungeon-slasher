package flea2d.tilemap;

import kha.math.Vector2i;
import haxe.Json;
import kha.Assets;
import kha.Image;
import flea2d.tilemap.Tilemap;

typedef TiledTilemapData = {
	height:Int,
	width:Int,
	tileheight:Int,
	tilewidth:Int,
	layers:Array<TiledTilemapLayer>,
	compressionlevel:Int,
	nextlayerid:Int,
	nextobjectid:Int,
	type:String,
}

typedef TiledTilemapLayer = {
	data:Array<Int>,
	height:Int,
	id:Int,
	name:String,
	opacity:Int,
	type:String,
	visible:Bool,
	width:Int,
	x:Int,
	y:Int,
}

class TiledTilemapLoader {
	public static function loadTilemap(pathToFile:String, tilemapSprite:Image):Tilemap {
		var tiledJson:String = Assets.blobs.test_dungeon_json.toString();
		var tiledData:TiledTilemapData = Json.parse(tiledJson);
		var layers:Array<TilemapLayer> = new Array<TilemapLayer>();

		for (tiledTilemapLayer in tiledData.layers) {
			var tiles:Array<Array<Vector2i>> = [
				for (y in 0...tiledTilemapLayer.height) [for (x in 0...tiledTilemapLayer.width) new Vector2i()]
			];

			var index:Int = 0;
			for (y in 0...tiledTilemapLayer.height) {
				for (x in 0...tiledTilemapLayer.width) {
					tiles[x][y].x = getTilePixelPositionX(tiledTilemapLayer.data[index], tiledTilemapLayer.width, tiledData.tilewidth);
					tiles[x][y].y = getTilePixelPositionY(tiledTilemapLayer.data[index], tiledTilemapLayer.width, tiledData.tilewidth);
					index++;
				}
			}

			layers.push({tiles: tiles});
		}

		return new Tilemap(tilemapSprite, layers, tiledData.tilewidth, tiledData.tileheight, tiledData.width, tiledData.height);
	}

	private static function getTilePixelPositionX(tileID:Int, tilesetWidth:Int, tileWidth:Int):Int {
		var gridWidth:Int = Std.int(112 / tileWidth);
		if (tileID > 0)
			tileID -= 1;

		return tileWidth * (tileID - gridWidth * Std.int(tileID / gridWidth));
	}

	private static function getTilePixelPositionY(tileID:Int, tilesetWidth:Int, tileWidth:Int):Int {
		var gridWidth:Int = Std.int(112 / tileWidth);
		if (tileID > 0)
			tileID -= 1;
		return tileWidth * Std.int(tileID / gridWidth);
	}
}
