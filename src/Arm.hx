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

	public function new(x:Float, y:Float, direction:Int, orientation:Orientation, playerHeight:Int, friendly:Bool)
	{
		super(x + direction * 15, y - (playerHeight / 3) * 2, direction, friendly);
		
		var img:Image = new Image("graphics/arm.png");
		img.flipped = direction < 0;
		img.centerOrigin();
		addGraphic(img);
		setHitboxTo(graphic);
		height -= 6;
		width -= 6;
		originX = cast(Math.round(width * 0.5), Int);
		originY = cast(Math.round(height * 0.5), Int);
		
		_playerDirection = direction;
		
		_blood = new BloodSquirt();
		HXP.scene.add(_blood);
		
		switch orientation
		{
			case N:
				{
					_velocity.x = 0.;
					_velocity.y = -10.;
				}
			case E:
				{
					_velocity.x = 10.;
					_velocity.y = 0.;
				}
			case S:
				{
					_velocity.x = 0.;
					_velocity.y = 10.;
				}
			case W:
				{
					_velocity.x = -10.;
					_velocity.y = 0.;
				}
			case NE:
				{
					_velocity.x = 5.;
					_velocity.y = -5.;
				}
			case SE:
				{
					_velocity.x = 5.;
					_velocity.y = 5.;
				}
			case SW:
				{
					_velocity.x = -5.;
					_velocity.y = 5.;
				}
			case NW:
				{
					_velocity.x = -5.;
					_velocity.y = -5.;
				}
			case NNE:
				{
					_velocity.x = 3.;
					_velocity.y = -7.;
				}
			case NEE:
				{
					_velocity.x = 7.;
					_velocity.y = -3.;
				}
			case SEE:
				{
					_velocity.x = 7.;
					_velocity.y = 3.;
				}
			case SSE:
				{
					_velocity.x = 3.;
					_velocity.y = 7.;
				}
			case SSW:
				{
					_velocity.x = -3.;
					_velocity.y = 7.;
				}
			case SWW:
				{
					_velocity.x = -7.;
					_velocity.y = 3.;
				}
			case NWW:
				{
					_velocity.x = -7.;
					_velocity.y = -3.;
				}
			case NNW:
				{
					_velocity.x = -3.;
					_velocity.y = -7.;
				}
		}
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
		
		if (e.type == "block")
		{
			_velocity.x = 0;
			this.type = "platform";
			addTween(new Alarm(5., function (e:Dynamic = null):Void { HXP.world.remove(this); }, TweenType.OneShot), true);
			
			if (_playerDirection < 0)	_blood.squirt(x + 8, y);
			else 						_blood.squirt(x - 9, y);
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
				return false;
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
		
		if (e.type == "block")
		{
			_velocity.x = 0;
			this.type = "platform";
			addTween(new Alarm(5., function (e:Dynamic = null):Void { HXP.world.remove(this); }, TweenType.OneShot), true);
			
			if (_playerDirection < 0)	_blood.squirt(x + 8, y);
			else 						_blood.squirt(x - 9, y);
		}
		
		return true;
	}
	
	
	override public function update():Void
	{
		moveBy(_velocity.x, _velocity.y, ["enemy", "player", "block"]);
		
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
	
	private var _blood:BloodSquirt;
	private var _playerDirection:Int;
}