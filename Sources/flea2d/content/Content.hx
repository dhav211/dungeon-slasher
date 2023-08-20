package flea2d.content;

import flea2d.content.ContentManager.ContentManagerCallbacks;
import flea2d.scene.Scene;
import kha.Blob;
import kha.AssetError;
import kha.Assets;
import kha.Image;

class Content {
	var remainingContentToLoad:Int = 0;
	var onContentLoaded:Scene->Void;
	var scene:Scene;

	public function new(scene:Scene, onContentLoaded:Scene->Void) {
		this.scene = scene;
		this.onContentLoaded = onContentLoaded;
	}

	public function loadTexture(path:String, name:String) {
		remainingContentToLoad++;
		new Loader(path, name, Texture, onFinish, ContentManager.getContentCallbacks());
	}

	public function loadJson(path:String, name:String) {
		remainingContentToLoad++;
		new Loader(path, name, Json, onFinish, ContentManager.getContentCallbacks());
	}

	function onFinish() {
		remainingContentToLoad--;

		if (remainingContentToLoad <= 0) {
			onContentLoaded(scene);
		}
	}
}

private enum ContentType {
	Texture;
	Json;
	Sound;
}

private class Loader {
	var path:String;
	var currentContentLoading:String;
	var contentType:ContentType;
	var onFinish:Void->Void;
	var contentManagerCallbacks:ContentManagerCallbacks;

	public function new(path:String, contentName:String, contentType:ContentType, onFinish:Void->Void, contentManagerCallbacks:ContentManagerCallbacks) {
		this.path = path;
		this.currentContentLoading = contentName;
		this.contentType = contentType;
		this.onFinish = onFinish;
		this.contentManagerCallbacks = contentManagerCallbacks;

		load();
	}

	function load() {
		switch (contentType) {
			case Texture:
				Assets.loadImageFromPath(path, true, onImageLoaded, onFail);
			case Json:
				Assets.loadBlobFromPath(path, onJsonLoaded, onFail);
			default:
				{}
		}
	}

	function onFail(assetError:AssetError) {
		trace("Failed to load content from " + assetError.url);
		onFinish();
	}

	function onImageLoaded(image:Image) {
		var texture:Texture = new Texture(image, image.width, image.height);
		contentManagerCallbacks.onSetTexture(currentContentLoading, texture);
		onFinish();
	}

	function onJsonLoaded(blob:Blob) {
		var json:String = blob.toString();
		contentManagerCallbacks.onSetJson(currentContentLoading, json);
		onFinish();
	}
}
