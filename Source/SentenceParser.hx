package;

import commands.*;

class SentenceParser {

	public static function parse(s:String, battle:Battle){

		var parts = s.split(" ");

		var subject:Soldier = null;
		var target:Soldier = null;

		// Get subject of sentence
		for(soldier in battle.soldiers){
			if(parts[0].toLowerCase() == soldier.lastName.toLowerCase())
				subject = soldier;
		}

		var action:String = parts[1];

		if(target == null){
			target = battle.axisSoldiers[Std.int(Math.random()*(battle.axisSoldiers.length))];
		}

		switch(action){
			case "fires": new ShootCommand(subject, target);
			case "shoots": new ShootCommand(subject, target);
		}

		return subject != null;
	}
}