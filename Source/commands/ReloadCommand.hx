package commands;

class ReloadCommand extends Command {
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();

		if(subject.bullets == 3){
			Main.transcript += " His gun is already full of ammo.";
			return;
		}

		if(subject.inCover)
			subject.getUp();
		else
			postPrepare();

	}

	public override function postPrepare(){
		subject.gotoAndPlay(403);	
	}
}