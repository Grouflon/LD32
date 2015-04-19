package;

import com.haxepunk.utils.Ease;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;

/**
 * ...
 * @author ...
 */
class BloodSquirt extends Entity
{

	public function new()
	{
		super(x, y);
		
		_emitter = new Emitter("graphics/blood_drop.png", 4, 4);
		
		_emitter.newType("squirt", [0]);
		_emitter.setMotion("squirt", 0, 20, 1, 360, 10, 1, Ease.quadOut);
		_emitter.setAlpha("squirt", 1, 0.5);
		_emitter.setGravity("squirt", 3, 1);
		graphic = _emitter;
	}
	
	
	public function squirt(x:Float, y:Float):Void
	{
		for (i in 0...10)
		{
			_emitter.emit("squirt", x, y);
		}
	}
	
	
	private var _emitter:Emitter;
}