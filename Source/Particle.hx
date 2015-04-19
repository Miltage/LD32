package;

class Particle {
	
	public var x:Float;
	public var y:Float;
	public var vx:Float;
	public var vy:Float;
	public var size:Float;

	public var remove:Bool;

	private var deltaSize:Float;
	private var startY:Float;

	public function new(x:Float, y:Float, vx:Float, vy:Float, size:Float, ?deltaSize:Float){
		this.x = x;
		this.y = startY = y;
		this.vx = vx;
		this.vy = vy;
		this.size = size;
		this.deltaSize = deltaSize;

		remove = false;
	}

	public function update(){
		x += vx;
		y += vy;

		vy += 0.2;

		if(y - startY > 50) vy = -vy*0.7;

		size += deltaSize;

		if(size < 0.1) remove = true;
	}

	public function draw(){
		Battle.effects.graphics.beginFill(0xcc0000);
		Battle.effects.graphics.drawCircle(x, y, size);
		Battle.effects.graphics.endFill();
	}
}