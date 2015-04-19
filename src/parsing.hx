import haxe.xml.Fast;
import sys.io.File;
import com.haxepunk.HXP;

class Parsing
{
	public function new() 
	{
		var xmlString:String = sys.io.File.getContent("levels/testlevel.oel");
		var xml:Xml = Xml.parse(xmlString);
		
		getSize(xml);
		
		xml = xml.firstElement();
		
		var it_1:Iterator<Xml> = xml.elementsNamed("Terrain");
		var it_2:Iterator<Xml> = xml.elementsNamed("spawn");
		var it_3:Iterator<Xml> = xml.elementsNamed("platform");
		
		var terrain:Xml = it_1.next();
		var spawner:Xml = it_2.next();
		var platformer:Xml = it_3.next();
		
		createBlock(terrain);
		createSpawner(spawner);
		createPlatform(platformer);
		
		
	}
	
	private function getSize(xml:Xml)
	{
		for (lvl in xml.elements()) 
		{
			_width = Std.parseInt(lvl.get("width"));
			_height = Std.parseInt(lvl.get("height"));
		}
	}
	
	private function createBlock(terrain:Xml)
	{
		for (block in terrain.elements()) 
		{
			var x:Int = Std.parseInt(block.get("x")) * 32;
			var y:Int = Std.parseInt(block.get("y")) * 32;
			var tx:Int = Std.parseInt(block.get("tx"));
			var ty:Int = Std.parseInt(block.get("ty"));
			
			if (tx == 1)
				HXP.scene.add(new SolidBlock(x, y));
		}
	}
	
	private function createSpawner(spawner:Xml)
	{
		for (spawn in spawner.elements())
		{
			var x:Int = Std.parseInt(spawn.get("x"));
			var y:Int = Std.parseInt(spawn.get("y"));
			var enemy_1_timer:Float = Std.parseInt(spawn.get("enemy_1_timer"));
			var enemy_1_number:Int = Std.parseInt(spawn.get("enemy_1_number"));
			
			HXP.scene.add(new EnemySpawner(x, y, enemy_1_timer, enemy_1_number));
		}
	}
	
	private function createPlatform(platformer:Xml)
	{
		for (miblock in platformer.elements()) 
		{
			var x:Int = Std.parseInt(miblock.get("x")) * 32;
			var y:Int = Std.parseInt(miblock.get("y")) * 16;
			var tx:Int = Std.parseInt(miblock.get("tx"));
			var ty:Int = Std.parseInt(miblock.get("ty"));
			
			if (tx == 1)
				HXP.scene.add(new Platform(x, y));
		}
	}
	
	public var _width:Int;
	public var _height:Int;
}