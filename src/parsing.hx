import com.haxepunk.graphics.Tilemap;
import com.haxepunk.Scene;
import haxe.xml.Fast;
import sys.io.File;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.masks.Grid;

class Parsing
{
	public function new(file:String, scene:Scene) 
	{
		_scene = scene;
		var xmlString:String = sys.io.File.getContent(file);
		var xml:Xml = Xml.parse(xmlString);
		
		getSize(xml);
		
		xml = xml.firstElement();
		
		var it_1:Iterator<Xml> = xml.elementsNamed("Terrain");
		var it_2:Iterator<Xml> = xml.elementsNamed("item");
		var it_3:Iterator<Xml> = xml.elementsNamed("platform");
		var it_4:Iterator<Xml> = xml.elementsNamed("background");
		var it_5:Iterator<Xml> = xml.elementsNamed("props");
		
		var terrain:Xml = it_1.next();
		var items:Xml = it_2.next();
		var platformer:Xml = it_3.next();
		var background:Xml = it_4.next();
		var props:Xml = it_5.next();
	
		createBlock(terrain);
		createItem(items);
		createPlatform(platformer);
		createBackground(background);
		createProps(props);
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
		var e:Entity = new Entity();
		var m:Grid = new Grid(_width, _height, 30, 30);
		e.setHitbox(_width, _height);
		e.type = "block";
		e.name = "block";
		e.mask = m;
		
		for (miblock in terrain.elements()) 
		{
			var x:Int = Std.parseInt(miblock.get("x"));
			var y:Int = Std.parseInt(miblock.get("y"));
			var tx:Int = Std.parseInt(miblock.get("tx"));
			var ty:Int = Std.parseInt(miblock.get("ty"));
			
			if (tx == 1)
			{
				m.setTile(x, y, true);
			}
		}
		_scene.add(e);
	}
	
	private function createItem(items:Xml)
	{
		for (item in items.elements())
		{
			var name:String = item.nodeName;
			if (name == "spawn")
				createSpawn(item);
			else if (name == "ammo")
				createAmmo(item);
			else if (name == "player")
				createPlayer(item);
			else if (name == "boss")
				createBoss(item);
			else if (name == "goal")
				createGoal(item);
		}
	}
	private function createGoal(goal)
	{
		var x:Int = Std.parseInt(goal.get("x"));
		var y:Int = Std.parseInt(goal.get("y"));
		var w:Int = Std.parseInt(goal.get("w"));
		var h:Int = Std.parseInt(goal.get("h"));
		var nextLevel:String = goal.get("nextLevel");
		_scene.add(new LevelChanger(x, y, w, h, nextLevel));
	}
	
	
	private function createBoss(boss)
	{
		var x:Int = Std.parseInt(boss.get("x"));
		var y:Int = Std.parseInt(boss.get("y"));
		var speed:Int = Std.parseInt(boss.get("speed"));
		var range:Int = Std.parseInt(boss.get("visionRange"));
		var life:Int = Std.parseInt(boss.get("life"));
		_scene.add(new BossEnemy(null, x, y, 150, 150, speed, range, life));
	}
	
	private function createPlayer(player)
	{
		var x:Int = Std.parseInt(player.get("x"));
		var y:Int = Std.parseInt(player.get("y"));
		_player = new Player(x, y);
		_scene.add(_player);
	}
	
	private function createAmmo(spawn)
	{
		var x:Int = Std.parseInt(spawn.get("x"));
		var y:Int = Std.parseInt(spawn.get("y"));
		var limb:String = spawn.get("limb");

		switch (limb)
		{
			case "ARM":
			{
				_scene.add(new ArmAmmunition(x, y));
			}
			
			case "LEG":
			{
				_scene.add(new LegAmmunition(x, y));
			}
		}
	}
	
	private function createSpawn(spawn)
	{
		var x:Int = Std.parseInt(spawn.get("x"));
		var y:Int = Std.parseInt(spawn.get("y"));
		var timer:Float = Std.parseInt(spawn.get("timer"));
		var number:Int = Std.parseInt(spawn.get("number"));
		var damageStr:String = spawn.get("DamageType");
		var resitanceStr:String = spawn.get("Resitance");
		var damage:DamageType.DamageType;
		var resitance:EnemyResistance.EnemyResistance;
		
		switch (damageStr)
		{
			case "MELEE":
			{
				damage = MELEE;
			}
			
			case "RANGE":
			{
				damage = RANGE;
			}
			
			case "BOTH":
			{
				damage = BOTH;
			}
			
			default: damage = BOTH;
		}
		
		switch (resitanceStr)
		{
			case "LEG":
			{
				resitance = LEG;
			}
			
			case "ARM":
			{
				resitance = ARM;
			}
			
			case "BOTH":
			{
				resitance = BOTH;
			}
			
			default: resitance = BOTH;
		}
		
		_scene.add(new EnemySpawner(x, y, timer, number, resitance, damage));
	}
	
	private function createPlatform(platformer:Xml)
	{
		var e:Entity = new Entity();
		var m:Grid = new Grid(_width, _height, 30, 15);
		e.setHitbox(_width, _height);
		e.type = "platform";
		e.name = "platform";
		e.mask = m;
		
		for (miblock in platformer.elements()) 
		{
			var x:Int = Std.parseInt(miblock.get("x"));
			var y:Int = Std.parseInt(miblock.get("y"));
			var tx:Int = Std.parseInt(miblock.get("tx"));
			var ty:Int = Std.parseInt(miblock.get("ty"));
			
			if (tx == 1)
			{
				m.setTile(x, y, true);
			}
		}
		_scene.add(e);
	}
	
	private function createBackground(background:Xml)
	{
		var tileSize:Int = 30;
		var tilemapCols:Int = 5;
		var tilemap:Tilemap = new Tilemap("graphics/bg_tileset.png", _width, _height, tileSize, tileSize);
		
		for (tile in background.elements())
		{
			var x:Int = Std.parseInt(tile.get("x"));
			var y:Int = Std.parseInt(tile.get("y"));
			var tileIndex = Std.parseInt(tile.get("tx")) + Std.parseInt(tile.get("ty")) * tilemapCols;
			tilemap.setTile(x, y, tileIndex);
		}
		
		_scene.addGraphic(tilemap, 200);
	}
	
	private function createProps(props:Xml)
	{
		var tileSize:Int = 30;
		var tilemapCols:Int = 9;
		var tilemap:Tilemap = new Tilemap("graphics/props_tileset.png", _width, _height, tileSize, tileSize);
		
		for (tile in props.elements())
		{
			var x:Int = Std.parseInt(tile.get("x"));
			var y:Int = Std.parseInt(tile.get("y"));
			var tileIndex = Std.parseInt(tile.get("tx")) + Std.parseInt(tile.get("ty")) * tilemapCols;
			tilemap.setTile(x, y, tileIndex);
		}
		
		_scene.addGraphic(tilemap, 150);
	}

	public var _width:Int;
	public var _height:Int;
	public var _player:Player;
	
	private var _scene:Scene = null;
}