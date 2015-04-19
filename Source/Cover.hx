package;

import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.display.MovieClip;

class Cover extends Sprite {

	public var occupant:Soldier;
	public var alignment:Int;
	
	public function new(x:Float, y:Float, alignment:Int){
		super();
		this.x = x;
		this.y = y;
		this.alignment = alignment;

		var bytes = Assets.getBytes("assets/cover.swf");
		var loader:Loader = new Loader();
		loader.loadBytes(bytes);
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
			var clip = cast(loader.content, MovieClip);
			clip.gotoAndStop(Std.int(Math.random()*clip.totalFrames)+1);
			addChild(clip);
		});
	}
}