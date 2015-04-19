package;

class BloodPuddle extends Extra {

	private var growSpeed:Float;
	private var wait:Int;
	
	public function new(x:Float, y:Float, radius:Int, ?wait:Int=0){
		super();

		this.x = x;
		this.y = y;
		this.wait = wait;

		this.graphics.beginFill(0xcc0000);
		this.graphics.drawCircle(-radius, -radius, radius);
		this.graphics.endFill();

		scaleY = scaleX = 0.01;
		growSpeed = 0.05+Math.random()*0.2;
	}

	public override function update(){
		if(wait > 0){
			wait--;
			return;
		}

		if(scaleX < 1) scaleX += (1-scaleX)*growSpeed;
		scaleY = scaleX/2;
	}
}