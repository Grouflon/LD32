package src;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import hxmath.math.Vector2;

/**
 * ...
 * @author ...
 */
class Limb extends Entity
{

	public function new(x:Float, y:Float, direction:Int) 
	{
		super(x, y);
		
		collidable = true;
		
		_velocity.x = 10 * direction;
	}
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		if (e.type == "enemy")
		{
			HXP.world.remove(e);
			HXP.world.remove(this);
		}
		
		return true;
	}
	
	
	override public function update():Void
	{
		moveBy(_velocity.x, 0., "enemy");
		
		if (!onCamera)
		{
			HXP.world.remove(this);
		}
	}
	
	
	private var _velocity:Vector2 = new Vector2(0., 0.);
}