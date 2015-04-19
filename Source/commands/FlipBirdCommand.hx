package commands;

class FlipBirdCommand extends Command {
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();

		Main.transcript += SentenceParser.chooseRandom([
			" He heaves a mighty finger at the enemy.",
			" This riles up the opposition beyond belief.",
			" All those years of angry driving culminates into this glorious moment."
		]);

		if(subject.inCover)
			subject.getUp();
		else
			postPrepare();
		
	}

	public override function postPrepare(){
		subject.gotoAndPlay(266);
	}
}