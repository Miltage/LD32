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
import openfl.geom.Point;

class Soldier extends Sprite {

	public static inline var HEALTHBAR_WIDTH = 60;
	
	public var health:Int = 1;
	public var maxHealth:Int = 10;
	public var alignment:Int;
	public var lastName:String;
	public var alive:Bool;
	public var jammed:Bool;
	public var bullets:Int = 3;
	public var inCover:Bool;
	public var shooting:Bool;

	public var command:Command;

	private var healthBar:Sprite;
	private var bulletsCounter:Sprite;
	private var nameField:TextField;

	private var body:MovieClip;
	private var moving:Bool = false;
	private var targetPos:Point;

	public function new(alignment:Int, name:String, x:Int, y:Int){
		super();

		this.alignment = alignment;
		this.lastName = name;
		this.x = x;
		this.y = y;
		alive = true;
		jammed = false;
		inCover = false;
		shooting = false;

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

		bulletsCounter = new Sprite();
		bulletsCounter.x = 40;
		bulletsCounter.y = 50;
		drawBulletCounter();
		addChild(bulletsCounter);

		var bytes = Assets.getBytes("assets/soldier.swf");
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
			body = cast(loader.content, MovieClip);
			body.x = -45;
			body.y = -45;
			if(alignment == 1){
				body.scaleX = -1;
				body.x = 75;
			}
			addChild(body);
		});

	}

	public function update(){
		healthBar.width = HEALTHBAR_WIDTH*(health/maxHealth);

		if(targetPos != null && alive){
			var d:Point = targetPos.subtract(new Point(x, y));
			if(d.length < 2){
				targetPos = null;
				moving = false;
				if(command != null && !command.post)
					command.postCommand();
				else
					body.gotoAndPlay("idle");
			}else{				
				x += d.x/d.length*2;
				y += d.y/d.length*2;
				moving = true;
				if(body != null && (body.currentFrame < 100 || body.currentFrame > 131))
					body.gotoAndPlay("walk");
			}
		}

		// Soldier animation logic
		if(body != null && (body.currentFrame == 99 || body.currentFrame == 155 || body.currentFrame == 402 || body.currentFrame == 313 
			|| body.currentFrame == 208 || body.currentFrame == 361 || body.currentFrame == 484))
			body.gotoAndPlay("idle");
		else if(body != null && body.currentFrame == 131)
			body.gotoAndPlay("walk");
		else if(body != null && (body.currentFrame == 142 || body.currentFrame == 540) && command != null)
			command.drawEffects();
		else if(body != null && (body.currentFrame == 243 || body.currentFrame == 515 || body.currentFrame == 545 || body.currentFrame == 564))
			body.stop();
		else if(body != null && body.currentFrame == 265)
			body.gotoAndPlay(252);
		else if(body != null && body.currentFrame == 280 && !Battle.running)
			body.stop();
		else if(body != null && body.currentFrame > 440 && bullets < 3)
			bullets++;
		
		drawBulletCounter();
	}

	public function takeDamage(amount){
		health -= Std.int(amount);
		// Soldier death
		if(health <= 0){
			health = 0;
			alive = false;
		}
	}

	public function gotoAndPlay(frame:Int){
		body.gotoAndPlay(frame);
	}

	private function drawBulletCounter(){
		bulletsCounter.graphics.clear();
		if(!alive) return;
		bulletsCounter.graphics.beginFill(0xffffff);
		for(i in 0...bullets)
			bulletsCounter.graphics.drawRect(alignment*-60, 0-i*5, 6, 2);
		bulletsCounter.graphics.endFill();
	}

	public function moveTo(x:Float, y:Float){
		targetPos = new Point(x, y);
	}

	public function getFrame(){
		return body.currentFrame;
	}

}