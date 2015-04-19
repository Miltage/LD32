package;

class Command {

	public var subject:Soldier;
	public var target:Soldier;
	public var complete:Bool = false;
	public var drawn:Bool = false;

	private var battle:Battle;
	
	public function new(subject, target, battle){
		this.subject = subject;
		this.target = target;
		this.battle = battle;
	}

	public function perform(){		
		complete = true;
	}

	public function drawEffects(){
		drawn = true;
	}
}