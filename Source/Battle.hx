package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.events.TextEvent;
import openfl.Lib;
import openfl.events.Event;

@:font("assets/TravelingTypewriter.ttf") class DefaultFont extends Font {}

class Battle extends Sprite {

	public var field:TextField;
	public var soldiers:Array<Soldier>;
	public var turn:Int = 0;

	private var ai:AI;

	public function new(){
		super();

		Font.registerFont (DefaultFont);
		ai = new AI(this);

		var format = new TextFormat ("Traveling _Typewriter", 18, 0x111);

		// setup battlefield
		soldiers = new Array<Soldier>();
		var soldierNames = NameGenerator.getNames(4);

		for(i in 0...4){
			var soldier = new Soldier(0, soldierNames[i], 600 + Std.int(Math.random()*100), 100*i+80);
			soldiers.push(soldier);
			addChild(soldier);
		}

		for(i in 0...4){
			var soldier = new Soldier(1, "Enemy Soldier", 80 + Std.int(Math.random()*100), 100*i+80);
			soldiers.push(soldier);
			addChild(soldier);
		}

		field = new TextField();
		field.defaultTextFormat = format;
		field.embedFonts = true;
		field.text = "";
		field.x = Lib.current.stage.stageWidth*0.2;
		field.width = Lib.current.stage.stageWidth*0.6;
		field.multiline = true;
		field.wordWrap = true;
		field.type = TextFieldType.INPUT;
		addChild(field);

		Lib.current.stage.focus = field;

		field.addEventListener(TextEvent.TEXT_INPUT, handleInput);
		this.addEventListener(Event.ENTER_FRAME, update);
	}

	private function handleInput(t:TextEvent){
		if(t.text == "." || t.text == "?" || t.text == "!"){
			if(parseLastSentence()){
				turn = 1;
				field.text += " ";
				field.type = TextFieldType.DYNAMIC;
				ai.takeTurn();
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
		for(soldier in soldiers){
			soldier.update();
		}

		if(turn == 1 && ai.command.length > 0){
			field.text += ai.getNextCharacter();
			field.setSelection(field.text.length, field.text.length);
		}else if(turn == 1){
			turn = 0;
			field.text += " ";
			field.type = TextFieldType.INPUT;
			field.setSelection(field.text.length, field.text.length);
			Lib.current.stage.focus = field;
		}
	}
}