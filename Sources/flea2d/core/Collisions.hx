package flea2d.core;

class Collisons {
	static public function circleRectangle(radius:Float, cirX:Float, cirY:Float, rectX:Float, rectY:Float, rectW:Float, rectH:Float):Bool {
		var testX:Float = cirX;
		var testY:Float = cirY;

		if (cirX < rectX) // test left edge
			testX = rectX;
		else if (cirX > rectX + rectW) // right edge
			testX = rectX + rectH;

		if (cirY < rectY) // top edge
			testY = rectY;
		else if (cirY > rectY + rectH) // bottom edge
			testY = rectY + rectH;

		// get the distance from the closest edges
		var distX = cirX - testX;
		var distY = cirY - testY;
		var distance = Math.sqrt((distX * distX) + (distY * distY));

		if (distance <= radius)
			return true;

		return false;
	}
}
