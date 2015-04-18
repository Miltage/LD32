package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;

class Soldier extends Sprite {
	
	public var health:Int;
	public var alignment:Int;
	public var lastName:String;

	public function new(alignment:Int){
		super();

		this.alignment = alignment;
		health = 10;

		x = 200;
		y = 300;

		this.graphics.beginFill(0xff0000);
		this.graphics.drawRect(0, 0, 30, 60);
		this.graphics.endFill();

		var format = new TextFormat("Arial");
		format.align = TextFormatAlign.CENTER;
		format.color = 0xffffff;

		var nameField = new TextField();
		nameField.defaultTextFormat = format;
		nameField.text = "Soldier Name";
		nameField.selectable = false;
		nameField.y = 65;
		nameField.autoSize = TextFieldAutoSize.CENTER;
		nameField.x = 15 - nameField.width / 2;

		this.graphics.beginFill(0x000000, 0.6);
		this.graphics.drawRect(nameField.x-3, 65, nameField.width+5, 20);
		this.graphics.endFill();
		addChild(nameField);
	}
}