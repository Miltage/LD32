package;

import commands.*;

class AI {

	public var command:String;
	
	private var battle:Battle;

	public function new(b:Battle){
		battle = b;
		command = "";
	}

	public function takeTurn(){
		command = "Here is an example command performed by the AI.";
		var subject = battle.axisSoldiers[Std.int(Math.random()*(battle.axisSoldiers.length))];
		var target = battle.alliesSoldiers[Std.int(Math.random()*(battle.alliesSoldiers.length))];
		new ShootCommand(subject, target);
	}

	public function getNextCharacter(){
		var c = command.substr(0, 1);
		command = command.substr(1);
		return c;
	}
}