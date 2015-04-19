package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.events.TextEvent;
import openfl.Lib;
import openfl.events.Event;
import openfl.Assets;
import openfl.display.Loader;
import openfl.display.MovieClip;

@:font("assets/TravelingTypewriter.ttf") class DefaultFont extends Font {}

class Battle extends Sprite {

	public static var effects:Sprite;
	public static var groundEffects:Sprite;
	public static var running:Bool = true;

	public var field:TextField;
	public var soldiers:Array<Soldier>;
	public var axisSoldiers:Array<Soldier>;
	public var alliesSoldiers:Array<Soldier>;
	public var turn:Int = 0;

	public var transcript:String;

	private var ai:AI;
	private var timeSinceType:Int = 100;
	private var typistCount:Int = 0;
	private var wait:Int = 0;
	private var writer:MovieClip;

	public function new(){
		super();

		Font.registerFont (DefaultFont);
		ai = new AI(this);
		transcript = "";

		var format = new TextFormat ("Traveling _Typewriter", 18, 0x111);
		format.align = openfl.text.TextFormatAlign.CENTER;

		// setup battlefield
		soldiers = new Array<Soldier>();
		axisSoldiers = new Array<Soldier>();
		alliesSoldiers = new Array<Soldier>();
		var soldierNames = NameGenerator.getNames(4);

		for(i in 0...4){
			var soldier = new Soldier(0, soldierNames[i], 600 + Std.int(Math.random()*100), 100*i+80);
			soldiers.push(soldier);
			alliesSoldiers.push(soldier);
			addChild(soldier);
		}

		for(i in 0...4){
			var soldier = new Soldier(1, "Enemy Soldier", 80 + Std.int(Math.random()*100), 100*i+80);
			soldiers.push(soldier);
			axisSoldiers.push(soldier);
			addChild(soldier);
		}

		field = new TextField();
		field.defaultTextFormat = format;
		field.embedFonts = true;
		field.text = "";
		field.x = Lib.current.stage.stageWidth*0.3;
		field.y = 360;
		field.width = Lib.current.stage.stageWidth*0.4;
		field.multiline = true;
		field.wordWrap = true;
		field.type = TextFieldType.INPUT;
		addChild(field);

		Lib.current.stage.focus = field;

		field.addEventListener(TextEvent.TEXT_INPUT, handleInput);
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
			addChildAt(bg, 0);
			groundEffects = new Sprite();
			addChildAt(groundEffects, 1);
		});

		effects = new Sprite();
		addChild(effects);
	}

	private function handleInput(t:TextEvent){
		timeSinceType = 0;
		if(t.text == "." || t.text == "?" || t.text == "!"){
			transcript = field.text + t.text;
			// End player turn
			if(parseLastSentence()){
				field.type = TextFieldType.DYNAMIC;
				field.text += " ";
				transcript += " ";
				wait = 50;

				if(anyAxisAlive()){
					turn = 1;
					ai.takeTurn();
				}
			}
		}
	}

	private function parseLastSentence(){
		var lastEnd = Math.max(Math.max(field.text.lastIndexOf("."), field.text.lastIndexOf("?")), field.text.lastIndexOf("!"));
		if(lastEnd<0) lastEnd = 0;
		var sentence = StringTools.ltrim(field.text.substr(Std.int(lastEnd+lastEnd/lastEnd)));
		var r = ~/[\r|\n]+/gi;
		sentence = r.replace(sentence, " ");
		return SentenceParser.parse(sentence, this);
	}

	private function update(e:Event){
		effects.graphics.clear();
		if(wait > 0) wait--;

		for(soldier in soldiers){
			soldier.update();
		}

		typistCount++;
		if(transcript.length > field.text.length && typistCount % 2 == 0){
			field.text += transcript.charAt(field.text.length);
			field.setSelection(field.text.length, field.text.length);
			timeSinceType = 0;
		}

		// End enemy turn
		if(turn == 1 && transcript.length == field.text.length && !ai.command.complete && wait == 0){
			ai.runCommand();
		}
		else if(turn == 1 && transcript.length == field.text.length && wait == 0){
			if(anyAlliedAlive()){
				turn = 0;
				field.type = TextFieldType.INPUT;
				field.setSelection(field.text.length, field.text.length);
				Lib.current.stage.focus = field;
			}else if(running){
				showEnding(1);
			}
		}
		else if(turn == 0 && transcript.length == field.text.length && wait == 0 && running){
			if(!anyAxisAlive()) showEnding(0);
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

	}

	private function showEnding(victors){
		var winners = victors>0?"enemy":"allied";
		transcript += SentenceParser.chooseRandom([
			"And with that the "+winners+" soldiers won the battle.",
			"And with that the "+winners+" soldiers were victorious.",
			"Ultimately, the "+winners+" soldiers lived to tell this story.",
			"And with that the "+winners+" soldiers were the victors."
		]);

		for(soldier in soldiers){
			if(soldier.alive) soldier.gotoAndPlay(Math.random()>.5?244:266);
		}

		running = false;
	}

	// Convenience functions //

	public function getRandomAxisSoldier(){
		var s = axisSoldiers[Std.int(Math.random()*(axisSoldiers.length))];
		while(!s.alive)
			s = axisSoldiers[Std.int(Math.random()*(axisSoldiers.length))];
		return s;
	}

	public function getRandomAlliedSoldier(){
		var s = alliesSoldiers[Std.int(Math.random()*(alliesSoldiers.length))];
		while(!s.alive)
			s = alliesSoldiers[Std.int(Math.random()*(alliesSoldiers.length))];
		return s;
	}

	public function anyAxisAlive(){
		for(s in axisSoldiers)
			if(s.alive) return true;
		return false;
	}

	public function anyAlliedAlive(){
		for(s in alliesSoldiers)
			if(s.alive) return true;
		return false;
	}
}