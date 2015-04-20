package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;

import Ammunition;

/**
 * ...
 * @author ...
 */
class LegAmmunition extends Ammunition
{

	public function new(x:Float, y:Float) 
	{
		var sprite:Spritemap = new Spritemap("graphics/leg_pickup.png", 33, 75);
		sprite.add("float", [0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 2, 2, 1, 1], 13);
		super(x, y, 33, 75);
		
		originX = cast(Math.round(sprite.width * 0.5), Int);
		originY = cast(Math.round(sprite.height * 0.5), Int);
		
		sprite.originX = originX;
		sprite.originY = originY;
		
		addGraphic(sprite);
		sprite.play("float");
	}
	
	
	override public function addLimb(p:Player):Void
	{
		p.addLeg();
		super.addLimb(p);
	}
}