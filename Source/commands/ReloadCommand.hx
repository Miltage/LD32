package commands;

class ReloadCommand extends Command {
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();
		subject.gotoAndPlay(403);	
	}
}