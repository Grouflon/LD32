package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import com.haxepunk.graphics.Text;
import hxmath.math.Vector2;
import src.Arm;
import src.Leg;

class Player extends Entity
{

	public function new(x:Float=0, y:Float=0)
	{
		super(x, y);
		
		_initGraphics();
		
		setHitbox(24, _height);
		collidable = true;
		
		originX = cast(width * 0.5, Int);
		originY = height;
		
		name = "player";
		type = "player";
		
		Input.define("Jump", [Key.W, Key.UP, Key.SPACE]);
		Input.define("MoveLeft", [Key.A, Key.LEFT]);
		Input.define("MoveRight", [Key.D, Key.RIGHT]);
		Input.define("FireArm", [Key.Q]);
		Input.define("FireLeg", [Key.E]);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		if (Input.check("MoveLeft"))
		{
			_direction = -1;
			_velocity.x = _speed;
		}
		
		if (Input.check("MoveRight"))
		{
			_direction = 1;
			_velocity.x = _speed;
		}
		
		if (!Input.check("MoveLeft") && !Input.check("MoveRight"))
		{
			_velocity.x = 0;
		}
		
		if (Input.pressed("Jump"))
		{
			if (_onGround)
			{
				_doJump();
			}
		}
				
		if (Input.pressed("FireArm"))
		{
			_fireArm();
		}
		
		if (Input.pressed("FireLeg"))
		{
			_fireLeg();
		}
		
		if (_legCount == 0)
		{
			_short = true;
			_height = 57;
		}
		else
		{
			_short = false;
			_height = 72;
		}
		
		_playerMovement();
		_applyGravity();
		
		_updateGraphics();
	}

	
	private function _fireArm()
	{
		if (_armCount > 0)
		{
			HXP.scene.add(new Arm(x, y, _direction, _height));
			_armCount--;
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (this._armCount < 2) this._armCount++; }, TweenType.OneShot), true);
		}
	}
	
	
	private function _fireLeg()
	{
		if (_legCount > 0)
		{
			HXP.scene.add(new Leg(x, y, _direction, _height));
			_legCount--;
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (this._legCount < 2) this._legCount++; }, TweenType.OneShot), true);
		}
	}
	
	
	private function _doJump():Void
	{
		if (_short)
		{
			_reach = 7.;
		}
		else
		{
			_reach = 9.5;
		}
		
		_onGround = false;
		_velocity.y = -_reach;
	}
	
	
	override public function moveCollideY(e:Entity):Bool
	{
		if (e.type == "enemy")
		{
			HXP.scene.remove(this);
		}
		
		if (_velocity.y >= 0)
		{
			_onGround = true;
		}
		
		_velocity.y = 0;
		
		return true;
	}
	
	override public function moveCollideX(e:Entity):Bool
	{
		if (e.type == "enemy")
		{
			HXP.scene.remove(this);
		}
		
		
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
		if (_short && _onGround)
		{
			_speed = 0;
		}
		else
		{
			_speed = 4.;
		}
		
		moveBy(_velocity.x * _direction, _velocity.y, ["block", "platform", "enemy"]);
	}
	
	private function _initGraphics():Void
	{
		_sprite = new Spritemap("graphics/player_spritesheet.png", 78, 75);
		_sprite.add("idle", [0, 1, 2, 3], 10);
		_sprite.add("walk", [10, 11, 12, 13, 14, 15, 16], 13);
		_sprite.add("jump_ascend", [20, 21], 13, false);
		_sprite.add("jump_ascend_loop", [22, 23], 13, true);
		_sprite.add("jump_descent", [24, 25], 13, false);
		_sprite.add("jump_descent_loop", [26, 27], 13, true);
		
		graphic = _sprite;
		_sprite.play("idle");
		
		_sprite.originX = _sprite.width / 2;
		_sprite.originY = _sprite.height;
	}
	
	private function _updateGraphics():Void
	{
		/*
		if (_short)
		{
		}
		else
		{
		}
		*/
		
		if (!_onGround)
		{
			if (_sprite.currentAnim != "jump_ascend" && _sprite.currentAnim != "jump_ascend_loop" && _sprite.currentAnim != "jump_descent" && _sprite.currentAnim != "jump_descent_loop")
			{
				_sprite.play("jump_ascend");
			}
			else if (_sprite.currentAnim == "jump_ascend" && _sprite.complete)
			{
				_sprite.play("jump_ascend_loop");	
			}
			
			if (_velocity.y > -1 && _sprite.currentAnim != "jump_descent" && _sprite.currentAnim != "jump_descent_loop")
			{
				_sprite.play("jump_descent");
			}
			else if (_sprite.currentAnim == "jump_descent" && _sprite.complete)
			{
				_sprite.play("jump_descent_loop");
			}
		}
		
		else if (Math.abs(_velocity.x) > 0)
		{
			_sprite.play("walk");
		}
		else
		{
			_sprite.play("idle");
		}
		
		if (_direction > 0)
		{
			_sprite.flipped = false;
		}
		else if (_direction < 0)
		{
			_sprite.flipped = true;
		}
	}
	
	public function getArmCount():Int { return _armCount; }
	public function getLegCount():Int { return _legCount; }
	
	private var _sprite:Spritemap;
	
	private var _gravity:Vector2 = new Vector2(0. , 20.);
	private var _velocity:Vector2 = new Vector2(0., 0.);

	private var _short:Bool = false;
	private var _height:Int = 72;
	
	private var _direction:Int = 1;

	private var _speed:Float = 4.;
	private var _reach:Float = 9.5;

	
	private var _armCount:Int = 2;
	private var _legCount:Int = 2;
	
	private var _onGround:Bool = false;
	
	private var _text:Text;
}