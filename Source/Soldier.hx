package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.Assets;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.display.MovieClip;

class Soldier extends Sprite {

	public static inline var HEALTHBAR_WIDTH = 60;
	
	public var health:Int;
	public var maxHealth:Int;
	public var alignment:Int;
	public var lastName:String;
	public var alive:Bool;

	private var healthBar:Sprite;
	private var nameField:TextField;

	private var body:MovieClip;
	private var moving:Bool = false;

	public function new(alignment:Int, name:String, x:Int, y:Int){
		super();

		this.alignment = alignment;
		this.lastName = name;
		this.x = x;
		this.y = y;
		health = maxHealth = 10;
		alive = true;

		var format = new TextFormat("Arial");
		format.align = TextFormatAlign.CENTER;
		format.color = 0xffffff;

		nameField = new TextField();
		nameField.defaultTextFormat = format;
		nameField.text = name;
		nameField.selectable = false;
		nameField.y = 65;
		nameField.autoSize = TextFieldAutoSize.CENTER;
		nameField.x = 15 - nameField.width / 2;

		this.graphics.beginFill(0x000000, 0.6);
		this.graphics.drawRect(nameField.x-3, 65, nameField.width+5, 20);
		this.graphics.endFill();
		addChild(nameField);

		healthBar = new Sprite();
		healthBar.x = 15 - HEALTHBAR_WIDTH / 2;
		healthBar.y = nameField.y + nameField.height + 5;
		healthBar.graphics.beginFill(0xff0000);
		healthBar.graphics.drawRect(0, 0, 100, 2);
		healthBar.graphics.endFill();
		addChild(healthBar);

		var bytes = Assets.getBytes("assets/soldier.swf");
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
			body = cast(loader.content, MovieClip);
			body.x = -45;
			body.y = -45;
			addChild(body);
			body.gotoAndPlay(100);
		});
	}

	public function update(){
		healthBar.width = HEALTHBAR_WIDTH*(health/maxHealth);

		if(body != null && body.currentFrame == 99){
			body.gotoAndPlay(1);
		}else if(body != null && body.currentFrame == 131){
			body.gotoAndPlay(100);
		}
	}

	public function takeDamage(amount){
		health -= amount;
		if(health <= 0){
			health = 0;
			alive = false;
			trace("Soldier died");
		}
	}
}