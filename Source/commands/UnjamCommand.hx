package commands;

class UnjamCommand extends Command {

	private var success:Bool = false;
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();
		subject.gotoAndPlay(362);

		success = Math.random()>.2;

		if(!subject.jammed){
			battle.transcript += SentenceParser.chooseRandom([
				" His gun isn't even jammed. He laughs in embarrassment.",
				" His gun isn't jammed. He will never live this down."
			]);
			return;
		}

		if(success){
			subject.jammed = false;
			battle.transcript += SentenceParser.chooseRandom([
				" He knocks his gun around a bit and a shell comes loose.",
				" An old shell falls from the barrel.",
				" Something clicks and the gun starts working again."
			]);
		}
		else {
			subject.jammed = true;
			battle.transcript += SentenceParser.chooseRandom([
				" Nothing changes.",
				" It has no affect.",
				" No use, still as jammed as ever."
			]);
		}
	}
}