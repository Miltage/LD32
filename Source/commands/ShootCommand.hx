package commands;

class ShootCommand extends Command {
	
	public function new(subject, target){
		super(subject, target);
	}

	public override function perform(){		
		target.takeDamage(4);
	}
}