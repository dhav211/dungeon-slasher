package flea2d.content;

import kha.AssetError;
import kha.Image;
import kha.Assets;

class ContentManager {
	static var textures:Map<String, Texture> = new Map<String, Texture>();
	static var remainingContentToLoad:Int = 0;
	static var onContentLoaded:Void->Void;

	public static function startContentLoading(onLoaded:Void->Void) {
		onContentLoaded = onLoaded;
	}

	public static function loadTexture(path:String, name:String) {
		remainingContentToLoad++;
		var conentLoader:ContentLoader = new ContentLoader();
		conentLoader.loadTexture(path, name, onLoadTexture, onContentLoadFailed);
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

	static function onLoadTexture(image:Image, currentTextureLoading:String) {
		remainingContentToLoad--;
		var texture:Texture = new Texture(image, image.width, image.height);

		if (textures.exists(currentTextureLoading)) { // Replace current texture with this name
			textures[currentTextureLoading] = texture;
		} else {
			textures.set(currentTextureLoading, texture);
		}

		if (remainingContentToLoad <= 0) {
			onContentLoaded();
		}
	}

	public static function isTextureLoaded(name:String) {
		return textures.exists(name);
	}

	static function onContentLoadFailed() {
		remainingContentToLoad--;
	}
}

class ContentLoader {
	var currentContentLoading:String = "";
	var onLoadTexture:(Image, String) -> Void;
	var onFail:Void->Void;

	public function new() {}

	public function loadTexture(path:String, currentTextureLoading:String, onLoadTexture:(Image, String) -> Void, onFail:Void->Void) {
		currentContentLoading = currentTextureLoading;
		this.onLoadTexture = onLoadTexture;
		this.onFail = onFail;
		Assets.loadImageFromPath(path, true, onImageLoaded, onImageFailed);
	}

	function onImageLoaded(image:Image) {
		onLoadTexture(image, currentContentLoading);
	}

	function onImageFailed(assetError:AssetError) {
		onFail();
		trace("Failed to load Texture from " + assetError.url);
	}
}
