package src;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import src.Limb;

/**
 * ...
 * @author ...
 */
class Arm extends Limb
{

	public function new(x:Float, y:Float, direction:Int, playerHeight:Int) 
	{
		super(x, y - (playerHeight / 3) * 2, direction);
		
		addGraphic(Image.createRect(20, 6, 0x3366FF, 1));
		
		setHitbox(20, 6); //temporary
		width 	= 20; //temporary
		height 	= 6; //temporary
	}
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		super.moveCollideX(e);
		
		if (e.type == "block")
		{
			_velocity.x = 0;
			this.type = "block";
			addTween(new Alarm(5., function (e:Dynamic = null):Void { HXP.world.remove(this); }, TweenType.OneShot), true);
		}
		
		return true;
	}
	
	
	override public function update():Void
	{
		moveBy(_velocity.x, 0., ["enemy", "block"]);
		
		if (!onCamera)
		{
			HXP.world.remove(this);
		}
	}
}