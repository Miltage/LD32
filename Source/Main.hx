package;


import openfl.display.Sprite;
import openfl.events.Event;


class Main extends Sprite {
	
	private var battle:Battle;

	public function new () {
		
		super ();
		
		init();

		
	}

	public function init(){
		battle = new Battle();
		addChild(battle);
	}
	
	
}