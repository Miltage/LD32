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
			var action:String = parts[1];

			if(target == null){
				target = battle.getRandomAxisSoldier();
			}

			switch(action){
				case "fires": command = new ShootCommand(subject, target);
				case "shoots": command = new ShootCommand(subject, target);
			}

			if(command != null) command.perform();
		}		

		return command != null;
	}
}