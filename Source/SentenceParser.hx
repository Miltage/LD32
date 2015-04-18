package;

class SentenceParser {

	public static function parse(s:String){

		var parts = s.split(" ");
		for(p in parts){
			trace(p);
		}
	}
}