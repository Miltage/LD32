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
				Main.transcript += SentenceParser.chooseRandom([
						" He is dead and thus his actions don't have much effect. ",
						" His corpse isn't very good at it. "
					]);
				return false;
			}

			var action:String = parts[1];

			var object:String = parts[parts.length-3] + " " + parts[parts.length-2] + " " + parts[parts.length-1];

			target = battle.getSoldierByName(object);

			if(target == null){
				target = battle.getRandomAxisSoldier();
			}

			// Single word actions
			switch(action){
				case "fires": command = new ShootCommand(subject, target, battle);
				case "shoots": command = new ShootCommand(subject, target, battle);
				case "unjams": command = new UnjamCommand(subject, target, battle);
				case "waits": command = new Command(subject, target, battle);
				case "yells": command = new YellCommand(subject, target, battle);
				case "reloads": command = new ReloadCommand(subject, target, battle);
				case "ducks": command = new DuckCommand(subject, target, battle);
				case "leaves": command = new LeaveCoverCommand(subject, target, battle);

			}

			if(command == null)
				action = parts[1] + " " +parts[2];

			// Two word actions
			switch(action){
				case "does nothing": command = new Command(subject, target, battle);
				case "takes cover": command = new CoverCommand(subject, target, battle);
			}

			if(command == null)
				action = parts[1] + " " +parts[2] + " " + parts[3];

			// Three word actions
			switch(action){
				case "flips the bird": command = new FlipBirdCommand(subject, target, battle);
				case "runs for cover": command = new CoverCommand(subject, target, battle);
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

	public static function possessive(name:String){
		if(StringTools.endsWith(name, "s")) return name+"'";
		return name+"'s";
	}

	public static function parseSetting(s:String, battle:Battle){

		if(~/\b(inside|outside)\b/gi.match(s)){
			if(Main.step == 0){
				var regex = ~/\b(inside)\b/gi;
				if(!regex.match(s))
					battle.bg.gotoAndStop(2);
				Main.showHint("Good! Now say something about how many soldiers there were.");
				Battle.show = true;
				Main.step++;
			}else
				Main.showHint("Alright, we know where the battle took place. Say something about the number of soldiers now.");
		}
		else if(~/\b(soldiers|soldier)\b/gi.match(s)){
			var regex = ~/\b(1|2|3|4|5|6|one|two|three|four|five|six)\b/gi;
			if(!regex.match(s)){
				Main.showHint("Try something else.");
				return;
			}
			var amount = regex.matched(1);
			battle.createSoldiers(amount);
			if(Main.step == 1){
				Main.showHint("Great! Now you can start writing about the battle. \nTry \"(Soldier Name) fires his weapon.\"");
				Main.step++;
			}else
				Main.showHint("Try something else.");
		}
	}

	public static function formatList(list:Array<String>){
		var result = "";

		if(list.length == 1) return list[0];

		for(i in 0...list.length-1){
			result += list[i]+", ";
		}
		result = result.substr(0, result.length-2);

		result += " and "+list[list.length-1];

		return result;

	}
}