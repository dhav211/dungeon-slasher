package flea2d.content;

class ContentManager {
	static var textures:Map<String, Texture> = new Map<String, Texture>();
	static var jsons:Map<String, String> = new Map<String, String>();

	public static function getTexture(name:String) {
		if (textures.exists(name)) {
			return textures[name];
		}

		return null; // TODO lets not return null, return a obviously errored texture
	}

	public static function isTextureLoaded(name:String) {
		return textures.exists(name);
	}

	static function setTexture(name:String, texture:Texture) {
		if (textures.exists(name)) { // Replace current texture with this name
			textures[name] = texture;
		} else {
			textures.set(name, texture);
		}
	}

	static function removeTexture(name:String) {
		if (textures.exists(name)) {
			textures[name].image.unload();
			textures.remove(name);
		}
	}

	public static function getJson(name:String) {
		if (jsons.exists(name)) {
			return jsons[name];
		}

		return "Failed to get json";
	}

	public static function isJsonLoaded(name:String) {
		return jsons.exists(name);
	}

	static function setJson(name:String, json:String) {
		if (jsons.exists(name)) { // Replace current json with this name
			jsons[name] = json;
		} else {
			jsons.set(name, json);
		}
	}

	static function removeJson(name:String) {
		if (jsons.exists(name)) {
			jsons.remove(name);
		}
	}

	public static function getContentCallbacks():ContentManagerCallbacks {
		return {
			onSetTexture: setTexture,
			onRemoveTexture: removeTexture,
			onSetJson: setJson,
			onRemoveJson: removeJson
		}
	}
}

typedef ContentManagerCallbacks = {
	var onSetTexture:(String, Texture) -> Void;
	var onRemoveTexture:String->Void;
	var onSetJson:(String, String) -> Void;
	var onRemoveJson:String->Void;
}
