package;


import openfl.display.Sprite;
import openfl.display.MovieClip;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.events.TextEvent;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.Assets;
import openfl.media.Sound;
import flash.media.SoundMixer;
import flash.media.SoundTransform;

@:font("assets/TravelingTypewriter.ttf") class DefaultFont extends Font {}

class Main extends Sprite {

	public static var transcript:String = "";
	public static var instance:Main;
	public static var field:TextField;
	public static var hintField:TextField;
	public static var step:Int = 0;
	public static var fadeWait:Int = 0;
	public static var started:Bool = false;
	public static var mute:Bool = false;
	
	private var battle:Battle;

	private var typistCount:Int = 0;
	private var timeSinceType:Int = 100;
	private var writer:MovieClip;
	private var bg:Sprite;

	private var typingSounds:Array<Sound>;
	private var theme:Sound;

	private var gramophone:Sprite;
	private var gclip:MovieClip;

	public function new () {
		
		super ();

		instance = this;		
		init();

		Font.registerFont (DefaultFont);

		addEventListener(Event.ENTER_FRAME, update);

		typingSounds = new Array<Sound>();
		typingSounds[0] = Assets.getSound("assets/type1.mp3");
		typingSounds[1] = Assets.getSound("assets/type2.mp3");
		typingSounds[2] = Assets.getSound("assets/type3.mp3");
		theme = Assets.getSound("assets/mightywriter.mp3");

		theme.play(0, 10000);
	}

	public function init(){

		Main.started = false;
		Main.fadeWait = 0;
		Main.step = 0;
		Battle.show = false;
		Battle.running = false;

		Main.transcript = "The Mighty Writer.\n A game made in 48 hours for Ludum Dare 32: An Unconventional Weapon.";

		bg = new Sprite();
		bg.graphics.beginFill(0x111111);
		bg.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		bg.graphics.endFill();

		var format = new TextFormat ("Traveling _Typewriter", 18, 0x111111);
		format.align = openfl.text.TextFormatAlign.CENTER;

		var format2 = new TextFormat ("Arial", 18, 0xcccccc);
		format2.align = openfl.text.TextFormatAlign.CENTER;

		field = new TextField();
		field.defaultTextFormat = format;
		field.embedFonts = true;
		field.text = "";
		field.x = Lib.current.stage.stageWidth*0.3;
		field.y = 340;
		field.width = Lib.current.stage.stageWidth*0.4;
		field.multiline = true;
		field.wordWrap = true;
		field.type = TextFieldType.INPUT;
		field.addEventListener(TextEvent.TEXT_INPUT, handleInput);

		hintField = new TextField();
		hintField.defaultTextFormat = format2;
		hintField.embedFonts = false;
		hintField.x = Lib.current.stage.stageWidth*0.3;
		hintField.y = 0;
		hintField.height = 300;
		hintField.width = Lib.current.stage.stageWidth*0.4;
		hintField.multiline = true;
		hintField.wordWrap = true;

		battle = new Battle();
		addChild(battle);		
		addChild(bg);

		var backing = new Sprite();
		backing.graphics.beginFill(0xffffff, 0.4);
		backing.graphics.drawRect(Lib.current.stage.stageWidth*0.3-10, 340-10, Lib.current.stage.stageWidth*0.4+15, 100+15);
		backing.graphics.endFill();

		addChild(backing);
		addChild(field);
		addChild(hintField);

		var bytes = Assets.getBytes("assets/writer.swf");
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
			writer = cast(loader.content, MovieClip);
			writer.x = 300;
			writer.y = 380;
			addChild(writer);
		});

		var bytes = Assets.getBytes("assets/gramophone.swf");
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
			gclip = cast(loader.content, MovieClip);
			gclip.stop();
			gramophone = new Sprite();
			gramophone.addChild(gclip);
			gramophone.x = 480;
			gramophone.y = 480;
			gramophone.buttonMode = true;
			addChild(gramophone);

			gramophone.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			gramophone.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			gramophone.addEventListener(MouseEvent.MOUSE_UP, mouseClick);
		});

		showHint("You are an author recounting a war story.");
		showHint("Start your story with the battle location (indoors/outdoors).");
		showHint("Example: \"The battle took place outside.\"");
	}

	public function restart(){
		while(numChildren > 0) removeChildAt(0);
		init();
	}

	public function update(e:Event){

		if(Battle.show && bg.alpha > 0) bg.alpha -= 0.01;

		if(fadeWait == 0 && Main.started && hintField.alpha > 0) hintField.alpha -= 0.005;
		else if(fadeWait > 0 && Main.started) fadeWait--;

		typistCount++;
		if(transcript.length > field.text.length && typistCount % 3 == 0){
			field.text += transcript.charAt(field.text.length);
			field.setSelection(field.text.length, field.text.length);
			timeSinceType = 0;
			if(typistCount % 6 == 0)typingSounds[Std.int(Math.random()*3)].play(0, 0, new openfl.media.SoundTransform(0.5));
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

	private function handleInput(t:TextEvent){
		timeSinceType = 0;
		typingSounds[Std.int(Math.random()*3)].play(0, 0, new openfl.media.SoundTransform(0.5));

		if(t.text == "." || t.text == "?" || t.text == "!"){
			Main.transcript = Main.field.text + t.text;

			if(!Battle.running){
				parseLastSentence();
				Main.transcript += " ";
			}else{
				// End player turn
				battle.playerTakeTurn();
			}
		}
	}

	public static function showHint(h:String){
		hintField.text += "\n\n"+h;
		hintField.setSelection(hintField.text.length, hintField.text.length);
		hintField.alpha = 1;
		fadeWait = 100;
	}

	private function parseLastSentence(){
		var lastEnd = Math.max(Math.max(Main.field.text.lastIndexOf("."), Main.field.text.lastIndexOf("?")), Main.field.text.lastIndexOf("!"));
		if(lastEnd<0) lastEnd = 0;
		var sentence = StringTools.ltrim(Main.field.text.substr(Std.int(lastEnd+lastEnd/lastEnd)));
		var r = ~/[\r|\n]+/gi;
		sentence = r.replace(sentence, " ");
		return SentenceParser.parseSetting(sentence, battle);
	}

	private function mouseOver(m:MouseEvent){
		gclip.gotoAndStop(2);
	}

	private function mouseOut(m:MouseEvent){
		gclip.gotoAndStop(1);
	}

	private function mouseClick(m:MouseEvent){
		Main.mute = !Main.mute;

		if(Main.mute)
			SoundMixer.soundTransform = new SoundTransform(0);
		else
			SoundMixer.soundTransform = new SoundTransform(1);
		
	}
	
	
}