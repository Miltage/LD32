package;

import commands.*;

class AI {

	public var command:Command;
	public var commandText:String;
	
	private var battle:Battle;

	public function new(b:Battle){
		battle = b;
		command = null;
	}

	public function takeTurn(){
		var subject = battle.getRandomAxisSoldier();
		var target = battle.getRandomAlliedSoldier();
		command = new ShootCommand(subject, target);
		commandText = "Enemy soldier shoots.";
	}

	public function runCommand(){
		command.perform();
	}

	public function getNextCharacter(){
		var c = commandText.substr(0, 1);
		commandText = commandText.substr(1);
		return c;
	}
}