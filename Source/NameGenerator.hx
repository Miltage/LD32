package;

class NameGenerator {
	
	private static var names = [
		"Williams",
		"Carter",
		"Johnson",
		"Daniels",
		"Jameson",
		"Turner",
		"Richardson",
		"Harris",
		"Clark",
		"Lewis",
		"Jackson",
		"Jefferson",
		"Anderson",
		"Davids",
		"Davis",
		"Thompson",
		"Walker",
		"Miller",
		"Roberts",
		"Baker",
		"Collins",
		"Phillips",
		"Cooper",
		"Sanders",
		"Barnes",
		"Woods",
		"Harrison",
		"Tucker",
		"Robertson",
		"Mills"
	];

	public static function getNames(amount:Int){
		var result = new Array<String>();
		for(i in 0...amount){
			var n = names[Std.int(Math.random()*names.length)];
			while(result.indexOf(n) >= 0)
				n = names[Std.int(Math.random()*names.length)];
			result.push(n);
		}
		return result;
	}
}