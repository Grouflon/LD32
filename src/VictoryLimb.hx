package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

/**
 * ...
 * @author ...
 */
class VictoryLimb extends Entity
{

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		addGraphic(Image.createRect(30, 30, 0xFFFFFF, 1));
		
		setHitbox(30, 30);
		collidable = true;
		
		name = "victory";
		type = "victory";
	}
	
}