package;

import commands.*;

class AI {

	public var command:Command;
	
	private var battle:Battle;

	public function new(b:Battle){
		battle = b;
		command = null;
	}

	public function takeTurn(){
		var subject = battle.getRandomAxisSoldier();
		var target = battle.getRandomAlliedSoldier();
		command = new ShootCommand(subject, target);
		subject.command = command;

		battle.transcript += "Enemy soldier shoots at "+target.lastName+".";
	}

	public function runCommand(){
		command.perform();
	}
}