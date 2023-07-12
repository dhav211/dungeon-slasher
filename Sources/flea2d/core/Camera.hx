package flea2d.core;

import kha.math.FastMatrix3;
import kha.math.Vector2;

class Camera {
	public var position:Vector2;
	public var zoom:Float;

	public function new(position:Vector2) {
		this.position = position;
		this.zoom = 1;
	}

	public function getTransformation():FastMatrix3 {
		return FastMatrix3.translation(-position.x, -position.y).multmat(FastMatrix3.scale(zoom, zoom));
	}
}
