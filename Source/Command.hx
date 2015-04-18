package;

class Command {

	public var subject:Soldier;
	public var target:Soldier;
	
	public function new(subject, target){
		this.subject = subject;
		this.target = target;
	}

	public function perform(){

	}
}