package;

import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.events.TextEvent;
import openfl.Lib;
import openfl.events.Event;
import openfl.Assets;
import openfl.display.Loader;
import openfl.display.MovieClip;

class Battle extends Sprite {

	public static var instance:Battle;
	public static var effects:Sprite;
	public static var groundEffects:Sprite;
	public static var running:Bool = false;
	public static var show:Bool = false;

	public var soldiers:Array<Soldier>;
	public var axisSoldiers:Array<Soldier>;
	public var alliesSoldiers:Array<Soldier>;
	public var cover:Array<Cover>;
	public var turn:Int = 0;
	public var bg:MovieClip;

	private var ai:AI;
	private var wait:Int = 0;
	private var endWait:Int = 0;
	private var ended:Bool = false;

	private var bulletTrails:Array<Sprite>;
	private var extras:Array<Extra>;
	private var holder:Sprite;

	public function new(){
		super();
		instance = this;

		ai = new AI(this);

		effects = new Sprite();
		groundEffects = new Sprite();
		holder = new Sprite();

		// setup battleMain.field
		soldiers = new Array<Soldier>();
		axisSoldiers = new Array<Soldier>();
		alliesSoldiers = new Array<Soldier>();

		cover = new Array<Cover>();
		generateCover();		

		Lib.current.stage.focus = Main.field;

		this.addEventListener(Event.ENTER_FRAME, update);

		var bytes = Assets.getBytes("assets/scene.swf");
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
			bg = cast(loader.content, MovieClip);
			bg.stop();
			addChildAt(bg, 0);
			addChildAt(groundEffects, 1);
		});

		addChild(holder);
		addChild(effects);
		bulletTrails = new Array<Sprite>();
		extras = new Array<Extra>();
	}

	public function createSoldiers(m){

		var amount = 4;

		if(m == "one" || m == "1") amount = 1;
		else if(m == "two" || m == "2") amount = 2;
		else if(m == "three" || m == "3") amount = 3;
		else if(m == "four" || m == "4") amount = 4;
		else if(m == "five" || m == "5") amount = 5;
		else if(m == "six" || m == "6") amount = 6;

		var soldierNames = NameGenerator.getNames(amount);

		for(i in 0...amount){
			var soldier = new Soldier(0, soldierNames[i], 650 + Std.int(Math.random()*80), Std.int((400/amount)*i+80));
			soldiers.push(soldier);
			alliesSoldiers.push(soldier);
			holder.addChild(soldier);
		}

		for(i in 0...amount){
			var soldier = new Soldier(1, "Enemy Soldier "+(i+1), 40 + Std.int(Math.random()*80), Std.int((400/amount)*i+80));
			soldiers.push(soldier);
			axisSoldiers.push(soldier);
			holder.addChild(soldier);
		}

		running = true;
	}

	public function playerTakeTurn(){
		if(parseLastSentence()){
			Main.started = true;
			Main.field.type = TextFieldType.DYNAMIC;
			Main.field.text += " ";
			Main.transcript += " ";
			wait = 50;

			if(anyAxisAlive()){
				turn = 1;
				ai.takeTurn();
			}
		}
	}

	private function parseLastSentence(){
		var lastEnd = Math.max(Math.max(Main.field.text.lastIndexOf("."), Main.field.text.lastIndexOf("?")), Main.field.text.lastIndexOf("!"));
		if(lastEnd<0) lastEnd = 0;
		var sentence = StringTools.ltrim(Main.field.text.substr(Std.int(lastEnd+lastEnd/lastEnd)));
		var r = ~/[\r|\n]+/gi;
		sentence = r.replace(sentence, " ");
		return SentenceParser.parse(sentence, this);
	}

	private function update(e:Event){
		if(ended) return;

		effects.graphics.clear();
		ParticleEngine.draw();

		if(wait > 0) wait--;
		if(endWait > 0) endWait--;

		if(endWait == 400 && Main.started && !running){
			Main.transcript += "\n\nTHE END.";
			if(numAlliedAlive() == alliesSoldiers.length) endWait = 100;
		}
		else if(endWait == 300 && Main.started && !running){
			var dead = new Array<String>();
			for(s in alliesSoldiers)
				if(!s.alive) dead.push(s.lastName);
			if(dead.length>0) Main.transcript += "\n\nIn loving memory of "+SentenceParser.formatList(dead)+".";
		}
		else if(endWait == 0 && Main.started && !running){
			Main.started = false;
			ended = true;
			Main.instance.restart();
		}

		for(soldier in soldiers){
			soldier.update();
		}

		// End enemy turn
		if(turn == 1 && Main.transcript.length == Main.field.text.length && !ai.command.complete && wait == 0){
			ai.runCommand();
		}
		else if(turn == 1 && Main.transcript.length == Main.field.text.length && wait == 0 && anyAlliedAlive()){
			turn = 0;
			Main.field.type = TextFieldType.INPUT;
			Main.field.setSelection(Main.field.text.length, Main.field.text.length);
			Lib.current.stage.focus = Main.field;
		}
		else if(!anyAlliedAlive() && running && ai.command.drawn && Main.started){
			showEnding(1);
		}
		else if(!anyAxisAlive() && turn == 0 && Main.transcript.length == Main.field.text.length && wait == 0 && running && Main.started){
			showEnding(0);
		}

		for(trail in bulletTrails){
			trail.alpha -= 0.08;
			if(trail.alpha <= 0 && effects.contains(trail)){
				effects.removeChild(trail);
				bulletTrails.remove(trail);
			}
		}

		for(extra in extras)
			extra.update();

		for(i in 0...holder.numChildren-1){
			if(holder.getChildAt(i).y > holder.getChildAt(i+1).y)
				holder.swapChildrenAt(i, i+1);
		}

	}

	private function showEnding(victors){
		var winners = victors>0?"enemy":"allied";
		Main.transcript += SentenceParser.chooseRandom([
			"And with that, the "+winners+" soldiers won the battle.",
			"And with that, the "+winners+" soldiers were victorious.",
			"Ultimately, the "+winners+" soldiers lived to tell this story.",
			"And with that the "+winners+" soldiers were the victors."
		]);

		for(soldier in soldiers){
			if(soldier.alive) soldier.gotoAndPlay(Math.random()>.5?244:266);
		}

		endWait = 500;
		running = false;
	}

	private function generateCover(){
		var count:Int = 0;
		for(i in 0...4){
			if(Math.random()>.5 || i == 3 && count == 0){
				var c = new Cover(220, 100 + 120 * i, 1);
				cover.push(c);
				addChild(c);
				count++;
			}
		}

		count = 0;
		for(i in 0...4){
			if(Math.random()>.5 || i == 3 && count == 0){
				var c = new Cover(580, 100 + 120 * i, 0);
				cover.push(c);
				addChild(c);
				count++;
			}
		}
	}

	// Convenience functions //

	public function getRandomAxisSoldier():Soldier {
		var s = axisSoldiers[Std.int(Math.random()*(axisSoldiers.length))];
		while(!s.alive)
			s = axisSoldiers[Std.int(Math.random()*(axisSoldiers.length))];
		return s;
	}

	public function getRandomAlliedSoldier():Soldier {
		var s = alliesSoldiers[Std.int(Math.random()*(alliesSoldiers.length))];
		while(!s.alive)
			s = alliesSoldiers[Std.int(Math.random()*(alliesSoldiers.length))];
		return s;
	}

	public function getSoldierByName(n:String):Soldier {
		for(s in soldiers)
			if(s.lastName.toLowerCase() == n.toLowerCase())
				return s;
		return null;
	}

	public function numAxisAlive():Int {
		var count:Int = 0;
		for(s in axisSoldiers)
			if(s.alive) count++;
		return count;
	}

	public function anyAxisAlive():Bool {
		return numAxisAlive()>0;
	}

	public function numAlliedAlive():Int {
		var count:Int = 0;
		for(s in alliesSoldiers)
			if(s.alive) count++;
		return count;
	}

	public function anyAlliedAlive():Bool {
		return numAlliedAlive()>0;
	}

	public function addBulletTrail(trail){
		bulletTrails.push(trail);
		effects.addChild(trail);
	}

	public function addBloodPuddle(puddle){
		extras.push(puddle);
		groundEffects.addChild(puddle);
	}
}