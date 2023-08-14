package flea2d.content;

import kha.AssetError;
import kha.Image;
import kha.Assets;

class ContentManager {
	static var textures:Map<String, Texture> = new Map<String, Texture>();
	static var currentTextureLoading:String;

	public static function loadTexture(path:String, name:String) {
		currentTextureLoading = name;
		Assets.loadImageFromPath(path, true, onImageLoaded, onImageFailed);
	}

	public static function unloadTexture(name:String) {
		if (textures.exists(name)) {
			textures[name].image.unload();
			textures.remove(name);
		}
	}

	public static function getTexture(name:String) {
		if (textures.exists(name)) {
			return textures[name];
		}

		return null; // TODO lets not return null, return a obviously errored texture
	}

	public static function isTextureLoaded(name:String) {
		return textures.exists(name);
	}

	static function onImageLoaded(image:Image) {
		var texture:Texture = new Texture(image, image.width, image.height);

		if (textures.exists(currentTextureLoading)) { // Replace current texture with this name
			textures[currentTextureLoading] = texture;
		} else {
			trace(currentTextureLoading);
			textures.set(currentTextureLoading, texture);
		}
	}

	static function onImageFailed(assetError:AssetError) {
		trace("Failed to load Texture from " + assetError.url);
	}
}
