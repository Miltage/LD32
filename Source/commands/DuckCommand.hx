package commands;

import openfl.geom.Point;

class DuckCommand extends Command {

	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		if(!subject.inCover){
			battle.transcript += " He finds nothing for him to duck behind.";
			return;
		}
		
		subject.shooting = false;
		subject.gotoAndPlay(546);
		
	}

	public override function postCommand(){
		
	}
	
}