package commands;

class ShootCommand extends Command {

	private var success:Bool = false;
	private var hit:Bool = false;
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();
		subject.gotoAndPlay(132);

		success = Math.random()>.05;
		hit = Math.random()>.2;

		if(subject.bullets == 0){
			battle.transcript += SentenceParser.chooseRandom([
				" Click. He's out of ammo.",
				" He realises there are no bullets in his gun."
			]);
			success = false;
			return;
		}

		if(subject.jammed){
			battle.transcript += SentenceParser.chooseRandom([
				" His gun is still jammed, he cannot use it."
			]);
			success = false;
			return;
		}

		if(success){
			target.takeDamage(4);
			subject.bullets--;
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
		super.drawEffects();
		if(!success) return;

		Battle.effects.graphics.lineStyle(2, 0xffffff);
		Battle.effects.graphics.moveTo(subject.x - 40 + subject.alignment*100, subject.y);
		Battle.effects.graphics.lineTo(target.x, target.y);

		if(target.alive) target.gotoAndPlay(156);
		else target.gotoAndPlay(209);
	}
}