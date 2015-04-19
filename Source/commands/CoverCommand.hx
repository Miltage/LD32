package commands;

import openfl.geom.Point;

class CoverCommand extends Command {

	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		if(subject.inCover){
			battle.transcript += " He decides against it, seeing as he is already in cover.";
			return;
		}

		var possibilities:Array<Cover> = new Array<Cover>();

		for(c in battle.cover){
			if(c.alignment == subject.alignment && c.occupant == null)
				possibilities.push(c);
		}

		if(possibilities.length == 0){
			battle.transcript += SentenceParser.chooseRandom([
				" He sees that there is nowhere for him to take cover..",
				" He finds all the available spots for cover occupied."
			]);
			return;
		}

		var pos:Point = new Point(subject.x, subject.y+60);

		possibilities.sort(function(a, b){
			return Point.distance(new Point(a.x, a.y), pos) > Point.distance(new Point(b.x, b.y), pos) ? 1:-1;
		});

		var cover = possibilities[0];
		subject.moveTo(cover.x+50, cover.y-55);
		cover.occupant = subject;
		subject.cover = cover;
	}

	public override function postCommand(){
		super.postCommand();
		subject.inCover = true;
		subject.shooting = false;
		subject.gotoAndPlay(485);
	}
	
}