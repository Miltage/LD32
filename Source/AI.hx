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
		else if(subject.inCover && subject.shooting && Math.random()>.6){
			command = new DuckCommand(subject, target, battle);			
			battle.transcript += "An enemy soldier ducks behind cover.";
		}
		else if(coverAvailable() && !subject.inCover && Math.random()>.4){
			command = new CoverCommand(subject, target, battle);
			battle.transcript += SentenceParser.chooseRandom([
				" An enemy soldier runs for cover.",
				" An enemy soldier runs behind some nearby cover.",
				" An enemy soldier takes refuge behind some cover."
			]);
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

	public function coverAvailable(){
		for(c in battle.cover)
			if(c.alignment == 1 && c.occupant == null)
				return true;
		return false;
	}
}