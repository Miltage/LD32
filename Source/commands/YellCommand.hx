package commands;

class YellCommand extends Command {
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();

		Main.transcript += SentenceParser.chooseRandom([
			" He shakes his fist angrily at the opposition.",
			" Foul words leave his mouth.",
			" He appears angry."
		]);

		if(subject.inCover)
			subject.getUp();
		else
			postPrepare();
		
	}

	public override function postPrepare(){
		subject.gotoAndPlay(314);
	}
}