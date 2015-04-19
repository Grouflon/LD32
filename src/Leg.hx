package;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween;
import hxmath.math.Vector2;

import Limb;

/**
 * ...
 * @author ...
 */
class Leg extends Limb
{

	public function new(x:Float, y:Float, direction:Int, playerHeight:Int, friendly:Bool) 
	{
		super(x, y - (playerHeight / 3) * 1, direction, friendly);
		
		_sprite = new Spritemap("graphics/leg_spritesheet.png", 30, 30);
		_sprite.add("roll_cw", [0, 1, 2, 3, 4, 5, 6, 7], 13);
		_sprite.add("roll_ccw", [7, 6, 5, 4, 3, 2, 1, 0], 13);
		_sprite.centerOrigin();
		addGraphic(_sprite);
		_sprite.play("roll_cw");
		
		setHitboxTo(_sprite);
		height -= 6;
		width -= 6;
		originX = cast(Math.round(_sprite.height / 2), Int);
		originY = cast(Math.round(_sprite.width / 2), Int);
		
		_velocity.x = 5. * direction;
		_velocity.y = -6;
	}
	
	
	override public function update():Void
	{	
		_applyGravity();
		
		super.update();
	}

	
	private function _applyGravity():Void
	{
		_velocity = Vector2.add(_velocity, Vector2.multiply(_gravity, HXP.elapsed));
	}
	
	override public function moveCollideX(e:Entity):Bool
	{
		super.moveCollideX(e);
		
		
		if (e.type == "enemy")
		{
			if (_friendly)
			{
				var e : Enemy = cast(e, Enemy);
				e.notifyDamage(EnemyResistance.LEG);
				
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
		
		_velocity.x = -_velocity.x * GB.legBounceAttenuation;
		reverseRotation();
		
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
				e.notifyDamage(EnemyResistance.LEG);
				
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
		
		_velocity.y = -_velocity.y * GB.legBounceAttenuation;
		reverseRotation();
		
		return true;
	}
	
	private function reverseRotation()
	{
		if (_sprite.currentAnim == "roll_cw") _sprite.play("roll_ccw");
		else _sprite.play("roll_cw");
	}
	
	private var _gravity:Vector2 = new Vector2(0., 10.);
	private var _sprite:Spritemap;
}