import haxe.xml.Fast;
import sys.io.File;


class Parsing
{
	static public function createBlock(scene) 
	{
		var xmlString:String = sys.io.File.getContent("levels/testlevel.oel");
		var xml:Xml = Xml.parse(xmlString);
		
		xml = xml.firstElement();
		xml = xml.firstElement();
		
		for ( elt in xml.elements())
		{
			var x:Int = Std.parseInt(elt.get("x")) * 32;
			var y:Int = Std.parseInt(elt.get("y")) * 32;
			var ty:Int = Std.parseInt(elt.get("tx"));

			if (ty == 1)
				scene.add(new SolidBlock(x, y));
		}
	}	
}