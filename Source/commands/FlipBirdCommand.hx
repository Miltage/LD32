package commands;

class FlipBirdCommand extends Command {
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();
		subject.gotoAndPlay(266);

		battle.transcript += SentenceParser.chooseRandom([
			" He heaves a mighty finger at the enemy.",
			" This riles up the opposition beyond belief.",
			" All those years of angry driving culminates into this glorious moment."
		]);
		
	}
}