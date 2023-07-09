package core;

import core.GameObjectManager;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import core.GameWindow;
import kha.Window;
import kha.math.Random;
import kha.Assets;
import kha.Scheduler;
import kha.System;
import core.App;
import core.Input;

class Project {
	var backbuffer:Image;
	var framebuffer:Framebuffer;

	public function new() {}

	public function run(mainScene:Scene) {
		System.start({title: "Dungeon Slasher", width: 1280, height: 720}, function(_) {
			Assets.loadEverything(function() {
				// Set the seed for random so it can be called from anywhere
				Random.init(cast(Date.now().getTime()));
				App.input = new Input();
				App.gameObjectManager = new GameObjectManager();
				App.gameWindow = new GameWindow(0, 0, 1280, 720, 320, 180, 4, 0);

				var window:Window = Window.get(0);
				var delta:Float = 0;
				var currentTime:Float = 0;

				backbuffer = Image.createRenderTarget(320, 180);
				window.notifyOnResize(onWindowResize);

				mainScene.initialize();

				var hasScaleBeenSet:Bool = false;

				Scheduler.addTimeTask(function() {
					delta = Scheduler.time() - currentTime;
					mainScene.update(delta);
					App.gameObjectManager.checkMouseInputListeners();
					App.input.endFrame();
					currentTime = Scheduler.time();
				}, 0, 1 / 60);
				System.notifyOnFrames(function(frames) {
					framebuffer = frames[0];

					final graphics = backbuffer.g2;

					if (!hasScaleBeenSet) {
						setWindowScale();
						hasScaleBeenSet = true;
					}

					graphics.begin();
					mainScene.render(graphics);
					graphics.end();

					frames[0].g2.begin();
					Scaler.scale(backbuffer, frames[0], System.screenRotation);
					frames[0].g2.end();
				});
			});
		});
	}

	function onWindowResize(width:Int, height:Int) {
		setWindowScale();
	}

	function setWindowScale() {
		var target = Scaler.targetRect(backbuffer.width, backbuffer.height, framebuffer.width, framebuffer.height, System.screenRotation);
		var scale = Scaler.getScaledTransformation(backbuffer.width, backbuffer.height, framebuffer.width, framebuffer.height, System.screenRotation);
		App.gameWindow.setGameWindow(target.x, target.y, target.width, target.height, scale, target.scaleFactor, 0);
	}
}
