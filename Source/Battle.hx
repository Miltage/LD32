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
	public static var running:Bool = true;

	public var soldiers:Array<Soldier>;
	public var axisSoldiers:Array<Soldier>;
	public var alliesSoldiers:Array<Soldier>;
	public var cover:Array<Cover>;
	public var turn:Int = 0;

	private var ai:AI;
	private var timeSinceType:Int = 100;
	private var typistCount:Int = 0;
	private var wait:Int = 0;
	private var writer:MovieClip;

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
		var soldierNames = NameGenerator.getNames(4);

		cover = new Array<Cover>();
		generateCover();

		for(i in 0...4){
			var soldier = new Soldier(0, soldierNames[i], 650 + Std.int(Math.random()*80), 100*i+80);
			soldiers.push(soldier);
			alliesSoldiers.push(soldier);
			holder.addChild(soldier);
		}

		for(i in 0...4){
			var soldier = new Soldier(1, "Enemy Soldier "+(i+1), 40 + Std.int(Math.random()*80), 100*i+80);
			soldiers.push(soldier);
			axisSoldiers.push(soldier);
			holder.addChild(soldier);
		}

		

		Lib.current.stage.focus = Main.field;

		Main.field.addEventListener(TextEvent.TEXT_INPUT, handleInput);
		this.addEventListener(Event.ENTER_FRAME, update);

		var bytes = Assets.getBytes("assets/writer.swf");
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
			writer = cast(loader.content, MovieClip);
			writer.x = 300;
			writer.y = 380;
			addChild(writer);
		});

		var bytes = Assets.getBytes("assets/scene.swf");
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
			var bg = cast(loader.content, MovieClip);
			bg.gotoAndStop(2);
			addChildAt(bg, 0);
			addChildAt(groundEffects, 1);
		});

		addChild(holder);
		addChild(effects);
		bulletTrails = new Array<Sprite>();
		extras = new Array<Extra>();
	}

	private function handleInput(t:TextEvent){
		timeSinceType = 0;
		if(t.text == "." || t.text == "?" || t.text == "!"){
			Main.transcript = Main.field.text + t.text;
			// End player turn
			if(parseLastSentence()){
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
		effects.graphics.clear();
		ParticleEngine.draw();

		if(wait > 0) wait--;

		for(soldier in soldiers){
			soldier.update();
		}

		typistCount++;
		if(Main.transcript.length > Main.field.text.length && typistCount % 2 == 0){
			Main.field.text += Main.transcript.charAt(Main.field.text.length);
			Main.field.setSelection(Main.field.text.length, Main.field.text.length);
			timeSinceType = 0;
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
		else if(!anyAlliedAlive() && running && ai.command.drawn){
			showEnding(1);
		}
		else if(!anyAxisAlive() && turn == 0 && Main.transcript.length == Main.field.text.length && wait == 0 && running){
			showEnding(0);
		}

		// Writer animation logic
		timeSinceType++;
		if(writer != null && writer.currentFrame == 20 && timeSinceType > 20){
			writer.gotoAndPlay(1);
		}else if(writer != null && writer.currentFrame == 65 && timeSinceType < 10){
			writer.gotoAndPlay(38);
		}else if(writer != null && writer.currentFrame > 20 && writer.currentFrame < 66 && timeSinceType > 20){
			writer.gotoAndPlay(66);
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