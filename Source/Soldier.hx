package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;

class Soldier extends Sprite {

	public static inline var HEALTHBAR_WIDTH = 60;
	
	public var health:Int;
	public var maxHealth:Int;
	public var alignment:Int;
	public var lastName:String;

	private var healthBar:Sprite;

	public function new(alignment:Int, name:String, x:Int, y:Int){
		super();

		this.alignment = alignment;
		this.x = x;
		this.y = y;
		health = maxHealth = 10;

		this.graphics.beginFill(alignment>0?0xff3344:0x33cc88);
		this.graphics.drawRect(0, 0, 30, 60);
		this.graphics.endFill();

		var format = new TextFormat("Arial");
		format.align = TextFormatAlign.CENTER;
		format.color = 0xffffff;

		var nameField = new TextField();
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
	}

	public function update(){
		healthBar.width = HEALTHBAR_WIDTH*(maxHealth/health);
	}
}