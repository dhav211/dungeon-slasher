package flea2d.core;

import kha.Color;
import kha.math.FastMatrix3;
import flea2d.gameobject.GameObjectManager;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import flea2d.core.GameWindow;
import kha.Window;
import kha.math.Random;
import kha.Assets;
import kha.Scheduler;
import kha.System;
import flea2d.gameobject.GameObjectManager;
import flea2d.core.Input;

class Project {
	var backbuffer:Image;
	var framebuffer:Framebuffer;

	public function new() {}

	public function run(mainScene:Scene) {
		System.start({title: "Dungeon Slasher", width: 1280, height: 720}, function(_) {
			// Set the seed for random so it can be called from anywhere
			Random.init(cast(Date.now().getTime()));
			GameWindow.set(1280, 720, 320, 180, FastMatrix3.identity(), 4, 0);
			Input.setup();
			CameraManager.setupDefaultCamera();

			var window:Window = Window.get(0);
			var delta:Float = 0;
			var currentTime:Float = 0;

			backbuffer = Image.createRenderTarget(320, 180);
			window.notifyOnResize(onWindowResize);
			mainScene.initialize();

			var hasScaleBeenSet:Bool = false;

			Scheduler.addFrameTask(function() {
				delta = Scheduler.time() - currentTime;
				GameObjectManager.updateGameObjects(delta);
				mainScene.update(delta);
				Input.endFrame();
				currentTime = Scheduler.time();
			}, 0);
			System.notifyOnFrames(function(frames) {
				framebuffer = frames[0];
				final graphics = backbuffer.g2;

				// The scale needs to be set here because it needs an initial framebuffer to calculate the value
				if (!hasScaleBeenSet) {
					GameWindow.resize(1280, 720, getWindowScale());
				}

				graphics.begin();
				GameObjectManager.gameobjectRenderer.render(graphics, CameraManager.currentCamera, true);
				graphics.end();

				// Draw the backbuffer to the front buffer, scaling in the process
				frames[0].g2.begin();
				Scaler.scale(backbuffer, frames[0], System.screenRotation);
				frames[0].g2.end();
			});
		});
	}

	function onWindowResize(width:Int, height:Int) {
		GameWindow.resize(width, height, getWindowScale());
	}

	function getWindowScale():FastMatrix3 {
		var target = Scaler.targetRect(backbuffer.width, backbuffer.height, framebuffer.width, framebuffer.height, System.screenRotation);
		return Scaler.getScaledTransformation(backbuffer.width, backbuffer.height, framebuffer.width, framebuffer.height, System.screenRotation);
	}
}
