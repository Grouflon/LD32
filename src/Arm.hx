package;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.utils.Draw;
import Limb;

/**
 * ...
 * @author ...
 */
class Arm extends Limb
{

	public function new(x:Float, y:Float, direction:Int, playerHeight:Int) 
	{
		super(x + direction * 15, y - (playerHeight / 3) * 2, direction);
		
		var img:Image = new Image("graphics/arm.png");
		img.flipped = direction < 0;
		img.centerOrigin();
		addGraphic(img);
		setHitboxTo(graphic);
		trace(width);
		trace(height);
		originX = cast(Math.round(width * 0.5), Int);
		originY = cast(Math.round(height * 0.5), Int);
	}
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		super.moveCollideX(e);
		
		if (e.type == "enemy")
		{
			var e : Enemy = cast(e, Enemy);
			e.notifyDamage(EnemyResistance.ARM);
			
			HXP.world.remove(this);
		}
		
		if (e.type == "block")
		{
			_velocity.x = 0;
			this.type = "platform";
			addTween(new Alarm(5., function (e:Dynamic = null):Void { HXP.world.remove(this); }, TweenType.OneShot), true);
		}
		
		return true;
	}
	

	override public function moveCollideY(e:Entity):Bool
	{
		super.moveCollideY(e);
		
		if (e.type == "enemy")
		{
			var e : Enemy = cast(e, Enemy);
			e.notifyDamage(EnemyResistance.ARM);
			
			HXP.world.remove(this);
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
	
	
	/*override public function render():Void
	{
		super.render();
		Draw.hitbox(this);
	}*/
}