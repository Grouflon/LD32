package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import hxmath.math.Vector2;

/**
 * ...
 * @author ...
 */
class Player extends Entity
{

	public function new(x:Float=0, y:Float=0)
	{
		super(x, y);
		
		addGraphic(Image.createRect(30, 50, 0xFFFFFF, 1));
		
		setHitbox(30, 50);
		collidable = true;
		
		width = 30;
		height = 50;
		
		name = "player";
		type = "player";
	}
	
	
	override public function update():Void
	{
		super.update();
		
		if (Input.check(Key.LEFT))
		{
			_velocity.x = -_speed;
		}
		
		if (Input.check(Key.RIGHT))
		{
			_velocity.x = _speed;
		}
		
		if (!Input.check(Key.RIGHT) && !Input.check(Key.LEFT))
		{
			_velocity.x = 0;
		}
		
		if (Input.pressed(Key.SPACE))
		{
			if (_onGround)
			{
				_doJump();
			}
		}
		
		_playerMovement();
		_applyGravity();
	}
	
	
	private function _doJump():Void
	{
		if (!_onGround) return;
		
		_onGround = false;
		_velocity.y = -_reach;
	}
	
	
	override public function moveCollideY(e:Entity):Bool
	{
		if (_velocity.y >= 0)
		{
			_onGround = true;
		}
		
		_velocity.y = 0;
		
		return true;
	}
	
	
	private function _applyGravity():Void
	{
		_velocity = Vector2.add(_velocity, Vector2.multiply(_gravity, HXP.elapsed));
	}
	
	private function _playerMovement():Void
	{
		moveBy(_velocity.x, _velocity.y, "block");
	}
	
	private var _gravity:Vector2 = new Vector2(0. , 20.);
	private var _velocity:Vector2 = new Vector2(0., 0.);
	
	private var _speed:Float = 5.;
	private var _reach:Float = 7.;
	
	private var _onGround:Bool = false;

}