package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;

import Ammunition;

/**
 * ...
 * @author ...
 */
class ArmAmmunition extends Ammunition
{

	public function new(x:Float, y:Float) 
	{
		super(x, y, 7, 18);
		
		addGraphic(Image.createRect(7, 18, 0x33CC33, 1));
	}
		
		
	override public function addLimb(p:Player):Void
	{
		p.addArm();
		super.addLimb(p);
	}
}