package commands;

class ShootCommand extends Command {

	private var success:Bool = false;
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();
		subject.gotoAndPlay(132);

		success = Math.random()>.1;

		if(subject.jammed){
			battle.transcript += SentenceParser.chooseRandom([
				" His gun is still jammed, he cannot use it."
			]);
			return;
		}

		if(success){
			target.takeDamage(4);
		}
		else {
			subject.jammed = true;
			battle.transcript += SentenceParser.chooseRandom([
				" His gun jams and he is unable to shoot.",
				" Something is blocking the barrel of his gun.",
				" However, the gun's inner workings malfunction, and he is unable to do so."
			]);
		}
	}

	public override function drawEffects(){
		if(!success) return;
		Battle.effects.graphics.lineStyle(2, 0xffffff);
		Battle.effects.graphics.moveTo(subject.x, subject.y);
		Battle.effects.graphics.lineTo(target.x, target.y);
	}
}