package;

import commands.*;

class SentenceParser {

	public static function parse(s:String, battle:Battle){

		var parts = s.split(" ");

		var subject:Soldier = null;
		var target:Soldier = null;
		var command:Command = null;

		// Get subject of sentence
		for(soldier in battle.soldiers){
			if(parts[0].toLowerCase() == soldier.lastName.toLowerCase())
				subject = soldier;
		}

		if(subject != null){
			if(!subject.alive){
				battle.transcript += SentenceParser.chooseRandom([
						" He is dead and thus his actions don't have much effect. ",
						" His corpse isn't very good at it. "
					]);
				return false;
			}

			var action:String = parts[1];

			if(target == null){
				target = battle.getRandomAxisSoldier();
			}

			switch(action){
				case "fires": command = new ShootCommand(subject, target, battle);
				case "shoots": command = new ShootCommand(subject, target, battle);
				case "unjams": command = new UnjamCommand(subject, target, battle);
			}

			if(command != null){
				subject.command = command;
				command.perform();
			}
		}		

		return command != null;
	}

	public static function chooseRandom(options:Array<Dynamic>){
		return options[Std.int(Math.random()*options.length)];
	}
}