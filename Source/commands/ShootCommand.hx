package commands;

class ShootCommand extends Command {
	
	public function new(subject, target){
		super(subject, target);
		target.takeDamage(4);
	}
}