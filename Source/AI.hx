package;

class AI {

	public var command:String;
	
	private var battle:Battle;

	public function new(b:Battle){
		battle = b;
		command = "";
	}

	public function takeTurn(){
		command = "Here is an example command performed by the AI.";
	}

	public function getNextCharacter(){
		var c = command.substr(0, 1);
		command = command.substr(1);
		return c;
	}
}