package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.utils.Draw;
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
		
		_initGraphics();
		
		setHitbox(24, 72);
		collidable = true;
		
		originX = cast(width * 0.5, Int);
		originY = height;
		
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
		
		_updateGraphics();
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
	
	
	override public function render():Void
	{
		super.render();
		//Draw.hitbox(this, true);
	}
	
	
	private function _applyGravity():Void
	{
		_velocity = Vector2.add(_velocity, Vector2.multiply(_gravity, HXP.elapsed));
	}
	
	private function _playerMovement():Void
	{
		moveBy(_velocity.x, _velocity.y, "block");
	}
	
	private function _initGraphics():Void
	{
		_sprite = new Spritemap("graphics/player_spritesheet.png", 78, 75);
		_sprite.add("idle", [0, 1, 2, 3], 10);
		_sprite.add("walk", [10, 11, 12, 13, 14, 15, 16], 13);
		
		graphic = _sprite;
		_sprite.play("idle");
		
		_sprite.originX = _sprite.width / 2;
		_sprite.originY = _sprite.height;
	}
	
	private function _updateGraphics():Void
	{
		if (Math.abs(_velocity.x) > 0)
		{
			_sprite.play("walk");
		}
		else
		{
			_sprite.play("idle");
		}
		
		if (_velocity.x > 0)
		{
			_sprite.flipped = false;
		}
		else if (_velocity.x < 0)
		{
			_sprite.flipped = true;
		}
	}
	
	private var _sprite:Spritemap;
	
	private var _gravity:Vector2 = new Vector2(0. , 20.);
	private var _velocity:Vector2 = new Vector2(0., 0.);
	
	private var _speed:Float = 4.;
	private var _reach:Float = 9.5;
	
	private var _onGround:Bool = false;

}