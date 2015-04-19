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

	public function new(x:Float, y:Float, direction:Int, playerHeight:Int, friendly:Bool) 
	{
		super(x + direction * 15, y - (playerHeight / 3) * 2, direction, friendly);
		
		var img:Image = new Image("graphics/arm.png");
		img.flipped = direction < 0;
		img.centerOrigin();
		addGraphic(img);
		setHitboxTo(graphic);
		originX = cast(Math.round(width * 0.5), Int);
		originY = cast(Math.round(height * 0.5), Int);
	}
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		super.moveCollideX(e);
		
		if (e.type == "enemy")
		{
			if (_friendly)
			{
				var e : Enemy = cast(e, Enemy);
				e.notifyDamage(EnemyResistance.ARM);
				
				HXP.world.remove(this);
			}
			else
			{
				return false;
			}
		}
		
		trace(e.type);
		
		if (e.type == "player")
		{
			trace(_friendly);
			if (!_friendly)
			{
				var e : Player = cast(e, Player);
				e.takeDamage(DamageType.RANGE);
				
				HXP.world.remove(this);
			}
			else
			{
				return false;
			}
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
			if (_friendly)
			{
				var e : Enemy = cast(e, Enemy);
				e.notifyDamage(EnemyResistance.ARM);
				
				HXP.world.remove(this);
			}
			else
			{
				return false;
			}
		}
		
		if (e.type == "player")
		{
			if (!_friendly)
			{
				var e : Player = cast(e, Player);
				e.takeDamage(DamageType.RANGE);
				
				HXP.world.remove(this);
			}
			else
			{
				return false;
			}
		}
		
		return true;
	}
	
	
	override public function update():Void
	{
		moveBy(_velocity.x, 0., ["enemy", "player", "block"]);
		
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