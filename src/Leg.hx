package src;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween;
import hxmath.math.Vector2;
import src.Limb;

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
		
		_velocity.x = 5. * direction;
		_velocity.y = -6;
		
		addTween(new Alarm(1.5, function (e:Dynamic = null):Void {
			_disableVelocity();
		}, TweenType.OneShot), true);
	}
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		super.moveCollideX(e);
		return true;
	}
	
	
	override public function moveCollideY(e:Entity):Bool
	{
		super.moveCollideY(e);
		return true;
	}
	
	
	override public function update():Void
	{	
		_applyGravity();
		
		super.update();
	}

	
	private function _disableVelocity():Void
	{
		_velocity.y = 0;
	}
	

	private function _applyGravity():Void
	{
		_velocity = Vector2.add(_velocity, Vector2.multiply(_gravity, HXP.elapsed));
	}
	
	
	private var _gravity:Vector2 = new Vector2(0., 10.);
}