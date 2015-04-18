package commands;

class ShootCommand extends Command {
	
	public function new(subject, target){
		super(subject, target);
	}

	public override function perform(){
		subject.gotoAndPlay(132);	
		target.takeDamage(4);
	}

	public override function drawEffects(){
		Battle.effects.graphics.lineStyle(2, 0xffffff);
		Battle.effects.graphics.moveTo(subject.x, subject.y);
		Battle.effects.graphics.lineTo(target.x, target.y);
	}
}