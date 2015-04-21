package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author ...
 */
class VictoryLimb extends Entity
{

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		var sprite:Spritemap = new Spritemap("graphics/victory_pickup.png", 33, 75);
		sprite.add("float", [0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 2, 2, 1, 1], 13);
		height = 33;
		width = 75;
		
		originX = cast(Math.round(sprite.width * 0.5), Int);
		originY = cast(Math.round(sprite.height * 0.5), Int);
		
		sprite.originX = originX;
		sprite.originY = originY;
		
		addGraphic(sprite);
		sprite.play("float");
		
		name = "victory";
		type = "victory";
	}
	
}