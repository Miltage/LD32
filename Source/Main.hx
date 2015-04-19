package;


import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.events.TextEvent;
import openfl.Lib;

@:font("assets/TravelingTypewriter.ttf") class DefaultFont extends Font {}

class Main extends Sprite {

	public static var transcript:String = "";
	public static var field:TextField;
	
	private var battle:Battle;

	public function new () {
		
		super ();
		
		init();

		Font.registerFont (DefaultFont);

		
	}

	public function init(){

		var format = new TextFormat ("Traveling _Typewriter", 18, 0x111);
		format.align = openfl.text.TextFormatAlign.CENTER;

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


		battle = new Battle();
		addChild(battle);
		
		addChild(field);
	}
	
	
}