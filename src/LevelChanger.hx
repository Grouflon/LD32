package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

/**
 * ...
 * @author Etienne
 */
class LevelChanger extends Entity
{

	public function new(_x :Int, _y : Int, _width : Int, _height : Int, _nextLevel : String) 
	{
		super(_x, _y, Image.createRect(_width, _height, 0xBB00FF));
		collidable = true;
		setHitbox(_width, _height, 0, 0);
		layer = 150;
		type = "levelChanger";
		nextLevel = _nextLevel;
	}
	
	public function changeLevel()
	{
		GameController.switchLevel(nextLevel);
	}
	
	private var nextLevel : String;
	
}