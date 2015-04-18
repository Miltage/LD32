package;


import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.events.TextEvent;

@:font("assets/TravelingTypewriter.ttf") class DefaultFont extends Font {}


class Main extends Sprite {
	
	private var field:TextField;

	public function new () {
		
		super ();
		
		Font.registerFont (DefaultFont);

		var format = new TextFormat ("Traveling _Typewriter", 18, 0x111);

		field = new TextField();
		field.defaultTextFormat = format;
		field.embedFonts = true;
		field.text = "";
		field.x = stage.stageWidth*0.2;
		field.width = stage.stageWidth*0.6;
		field.multiline = true;
		field.wordWrap = true;
		field.type = TextFieldType.INPUT;
		addChild(field);

		stage.focus = field;

		field.addEventListener(TextEvent.TEXT_INPUT, handleInput);
		
	}

	private function handleInput(t:TextEvent){
		if(t.text == "." || t.text == "?" || t.text == "!"){
			var lastEnd = field.text.lastIndexOf(".");
			if(lastEnd<0) lastEnd = 0;
			var sentence = StringTools.ltrim(field.text.substr(lastEnd+Std.int(lastEnd/lastEnd)));
			SentenceParser.parse(sentence);
		}
	}
	
	
}