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

		if(subject.jammed){
			command = new UnjamCommand(subject, target, battle);
			battle.transcript += "An enemy soldier attempts to unjam his weapon.";
		}
		else if(subject.bullets == 0){
			command = new ReloadCommand(subject, target, battle);
			battle.transcript += "An enemy soldier reloads his weapon.";
		}
		else{
			command = new ShootCommand(subject, target, battle);
			if(battle.numAxisAlive() == 1) battle.transcript += "The last remaining enemy soldier";
			else battle.transcript += Math.random()>.5?"An enemy soldier":"One of the enemy soldiers";
			battle.transcript += " shoots at "+target.lastName+".";
		}

		subject.command = command;

	}

	public function runCommand(){
		command.perform();

		battle.transcript += " ";
	}
}