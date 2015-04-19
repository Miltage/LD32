package commands;

class ReloadCommand extends Command {
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();

		if(subject.bullets == 3){
			battle.transcript += " His gun is already full of ammo.";
			return;
		}

		subject.gotoAndPlay(403);	
	}
}