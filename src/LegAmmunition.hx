package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;

import Ammunition;

/**
 * ...
 * @author ...
 */
class LegAmmunition extends Ammunition
{

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		addGraphic(Image.createRect(10, 25, 0x009933, 1));
	}
	
	
	override public function addLimb(p:Player):Void
	{
		p.addLeg();
		super.addLimb(p);
	}
}