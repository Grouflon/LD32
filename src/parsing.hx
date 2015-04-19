import haxe.xml.Fast;
import sys.io.File;
import com.haxepunk.HXP;

class Parsing
{
	static public function createBlock() 
	{
		var xmlString:String = sys.io.File.getContent("levels/testlevel.oel");
		var xml:Xml = Xml.parse(xmlString).firstElement();
		
		var it_1:Iterator<Xml> = xml.elementsNamed("Terrain");
		var it_2:Iterator<Xml> = xml.elementsNamed("spawn");
		var it_3:Iterator<Xml> = xml.elementsNamed("platform");
		
		var terrain:Xml = it_1.next();
		var spawner:Xml = it_2.next();
		var platformer:Xml = it_3.next();
		
		for (block in terrain.elements()) 
		{
			var x:Int = Std.parseInt(block.get("x")) * 32;
			var y:Int = Std.parseInt(block.get("y")) * 32;
			var tx:Int = Std.parseInt(block.get("tx"));
			var ty:Int = Std.parseInt(block.get("ty"));
			
			if (tx == 1)
				HXP.scene.add(new SolidBlock(x, y));
		}
		
		for (spawn in spawner.elements())
		{
			var x:Int = Std.parseInt(spawn.get("x"));
			var y:Int = Std.parseInt(spawn.get("y"));
			var enemy_1_timer:Float = Std.parseInt(spawn.get("enemy_1_timer"));
			var enemy_1_number:Int = Std.parseInt(spawn.get("enemy_1_number"));
			
			HXP.scene.add(new EnemySpawner(x, y, enemy_1_timer, enemy_1_number, EnemyResistance.BOTH, DamageType.BOTH));
		}
		
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
}