package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import Limb;

/**
 * ...
 * @author ...
 */
class Leg extends Limb
{

	public function new(x:Float, y:Float, direction:Int, playerHeight:Int) 
	{
		super(x, y - (playerHeight / 3) * 1, direction);
		
		addGraphic(Image.createRect(25, 8, 0x3366FF, 1));
		
		setHitbox(25, 8); //temporary
		width 	= 25; //temporary
		height 	= 8; //temporary
	}
	
	override public function moveCollideX(e:Entity):Bool
	{
		super.moveCollideX(e);
		
		if (e.type == "enemy")
		{
			var e : Enemy = cast(e, Enemy);
			e.notifyDamage(EnemyResistance.LEG);
			
			HXP.world.remove(this);
		}
		
		return true;
	}
	
}