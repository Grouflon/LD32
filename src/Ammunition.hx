package;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;

import Player;

/**
 * ...
 * @author ...
 */
class Ammunition extends Entity
{

	public function new(x:Float, y:Float, width:Int, height:Int) 
	{
		super(x, y);
		collidable = true;
		setHitbox(width, height, 0, 0);
	}

	
	override public function update():Void
	{
		var collisioner = collideWith(cast(cast(HXP.scene, MainScene).player, Player), x, y);
		
		if (cast(HXP.scene, MainScene).player == collisioner)
		{
			addLimb(collisioner);
		}
	}
	
	
	public function addLimb(p:Player):Void
	{
		HXP.world.remove(this);
	}
}