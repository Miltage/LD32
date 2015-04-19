package commands;

import openfl.geom.Point;

class LeaveCoverCommand extends Command {

	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();
		if(!subject.inCover){
			battle.transcript += " He's not even in cover. He decides to leave spiritually instead.";
			return;
		}

		subject.getUp();
		
	}

	public override function postPrepare(){
		subject.moveTo(subject.x + 20 + Math.random()*60, subject.y + Math.random()*200-100);
	}

	public override function postCommand(){
		subject.gotoAndPlay(1);
	}
	
}