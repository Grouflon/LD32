package;

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

	public function new(x:Float, y:Float, direction:Int, friendly:Bool) 
	{
		super(x, y);
		
		collidable = true;
		_friendly = friendly;
		_velocity.x = 10 * direction;
	}
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		return true;
	}
	
	
	override public function moveCollideY(e:Entity):Bool
	{
		return true;
	}
	
	
	override public function update():Void
	{
		moveBy(_velocity.x, _velocity.y, ["enemy", "block", "player", "platform"]);
		
		if (!onCamera)
		{
			HXP.scene.remove(this);
		}
	}
	
	private var _friendly : Bool;
	private var _velocity:Vector2 = new Vector2(0., 0.);
}