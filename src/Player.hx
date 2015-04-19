package;

// External imports
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

// Local Imports
import src.GB;
import Arm;
import Leg;

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
		
		GB.playerArmCount 	= 2;
		GB.playerLegCount 	= 2;
		GB.playerReach		= 9.5;
		GB.playerSpeed		= 4.;
	}
	
	
	override public function update():Void
	{
		super.update();
		
		if (Input.check("MoveLeft"))
		{
			_direction = -1;
			_velocity.x = GB.playerSpeed;
		}
		
		if (Input.check("MoveRight"))
		{
			_direction = 1;
			_velocity.x = GB.playerSpeed;
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
		
		if (GB.playerLegCount == 0)
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
		
		_firedArm = false;
	}

	
	private function _fireArm()
	{
		if (GB.playerArmCount > 0 && _canFireArm)
		{
			_firedArm = true;
			_canFireArm = false;
			GB.playerArmCount--;
			addTween(new Alarm(.15, function (e:Dynamic = null):Void { HXP.scene.add(new Arm(x, y, _direction, _height)); }, TweenType.OneShot), true);
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (GB.playerArmCount < 2) GB.playerArmCount++; }, TweenType.OneShot), true);
			addTween(new Alarm(.3, function (e:Dynamic = null):Void { _canFireArm = true; }, TweenType.OneShot), true);
		}
	}
	
	
	private function _fireLeg()
	{
		if (GB.playerLegCount > 0)
		{
			HXP.scene.add(new Leg(x, y, _direction, _height));
			GB.playerLegCount--;
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (GB.playerLegCount < 2) GB.playerLegCount++; }, TweenType.OneShot), true);
		}
	}
	
	private function _looseLeg()
	{
		if (_legCount > 0)
		{
			_legCount--;
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (this._legCount < 2) this._legCount++; }, TweenType.OneShot), true);
		}
	}
	
	private function _looseArm()
	{
		if (_armCount > 0)
		{
			_armCount--;
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (this._armCount < 2) this._armCount++; }, TweenType.OneShot), true);
		}
	}
	
	private function _doJump():Void
	{
		if (_short)
		{
			GB.playerReach = 7.;
		}
		else
		{
			GB.playerReach = 9.5;
		}
		
		_onGround = false;
		_velocity.y = -GB.playerReach;
	}
	
	
	override public function moveCollideY(e:Entity):Bool
	{
		if (e.type == "enemy")
		{
			takeDamage(DamageType.MELEE);
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
			takeDamage(DamageType.MELEE);
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
		_velocity = Vector2.add(_velocity, Vector2.multiply(GB.gravity, HXP.elapsed));
	}
	
	private function _playerMovement():Void
	{
		if (_short && _onGround)
		{
			GB.playerSpeed = 0;
		}
		else
		{
			GB.playerSpeed = 4.;
		}
		
		moveBy(_velocity.x * _direction, _velocity.y, ["block", "platform", "enemy"]);
	}
	
	private function _initGraphics():Void
	{
		_legsSprite = new Spritemap("graphics/player_legs_spritesheet.png", 78, 75);
		_legsSprite.add("idle", [0], 10);
		_legsSprite.add("walk", [10, 11, 12, 13, 14, 15, 16], 13);
		_legsSprite.add("jump_ascend", [20, 21], 13, false);
		_legsSprite.add("jump_ascend_loop", [22, 23], 13, true);
		_legsSprite.add("jump_descent", [24, 25], 13, false);
		_legsSprite.add("jump_descent_loop", [26, 27], 13, true);
		
		_chestSprite = new Spritemap("graphics/player_chest_spritesheet.png", 78, 75);
		_chestSprite.add("idle", [0, 1, 2, 3], 10);
		_chestSprite.add("idle_1arm", [70, 71, 72, 73], 10);
		_chestSprite.add("idle_0arm", [80, 81, 82, 83], 10);
		_chestSprite.add("walk_1arm", [50, 51, 52, 53, 54, 55, 56], 13);
		_chestSprite.add("walk_0arm", [60, 61, 62, 63, 64, 65, 66], 13);
		_chestSprite.add("walk", [10, 11, 12, 13, 14, 15, 16], 13);
		_chestSprite.add("jump_ascend", [20, 21], 13, false);
		_chestSprite.add("jump_ascend_1arm", [90, 91], 13, false);
		_chestSprite.add("jump_ascend_0arm", [100, 101], 13, false);
		_chestSprite.add("jump_ascend_loop", [22, 23], 13, true);
		_chestSprite.add("jump_ascend_loop_1arm", [92, 93], 13, true);
		_chestSprite.add("jump_ascend_loop_0arm", [102, 103], 13, true);
		_chestSprite.add("jump_descent", [24, 25], 13, false);
		_chestSprite.add("jump_descent_1arm", [94, 95], 13, false);
		_chestSprite.add("jump_descent_0arm", [104, 105], 13, false);
		_chestSprite.add("jump_descent_loop", [26, 27], 13, true);
		_chestSprite.add("jump_descent_loop_1arm", [96, 97], 13, true);
		_chestSprite.add("jump_descent_loop_0arm", [106, 107], 13, true);
		_chestSprite.add("arm1_tearing", [30, 31, 32, 33], 13, false);
		_chestSprite.add("arm2_tearing", [40, 41, 42, 43], 13, false);

		addGraphic(_legsSprite);
		addGraphic(_chestSprite);
		_legsSprite.play("idle");
		_chestSprite.play("idle");
		
		_legsSprite.originX = _legsSprite.width / 2;
		_chestSprite.originX = _chestSprite.width / 2;
		_legsSprite.originY = _legsSprite.height;
		_chestSprite.originY = _chestSprite.height;
	}
	
	private function _updateGraphics():Void
	{
		// CHEST
		if (_firedArm && (GB.playerArmCount == 1)) _chestSprite.play("arm1_tearing");
		if (_firedArm && (GB.playerArmCount == 0)) _chestSprite.play("arm2_tearing");
		
		var armStr:String = "";
		if (GB.playerArmCount == 1) armStr = "_1arm";
		else if (GB.playerArmCount == 0) armStr = "_0arm";
		
		if ((_chestSprite.currentAnim != "arm1_tearing" && _chestSprite.currentAnim != "arm2_tearing") || _chestSprite.complete)
		{
			if (!_onGround)
			{
				if ((_chestSprite.currentAnim != "jump_ascend" && _chestSprite.currentAnim != "jump_ascend_1arm" && _chestSprite.currentAnim != "jump_ascend_0arm") &&
					(_chestSprite.currentAnim != "jump_ascend_loop" && _chestSprite.currentAnim != "jump_ascend_loop_1arm" && _chestSprite.currentAnim != "jump_ascend_loop_0arm") &&
					(_chestSprite.currentAnim != "jump_descent" && _chestSprite.currentAnim != "jump_descent_1arm" && _chestSprite.currentAnim != "jump_descent_0arm") &&
					(_chestSprite.currentAnim != "jump_descent_loop" && _chestSprite.currentAnim != "jump_descent_loop_1arm" && _chestSprite.currentAnim != "jump_descent_loop_0arm"))
				{
					_chestSprite.play("jump_ascend" + armStr);
				}
				else if ((_chestSprite.currentAnim == "jump_ascend" && _chestSprite.currentAnim == "jump_ascend_1arm" && _chestSprite.currentAnim == "jump_ascend_0arm") && _chestSprite.complete)
				{
					_chestSprite.play("jump_ascend_loop" + armStr);
				}
				
				if (_velocity.y > -1 && (_chestSprite.currentAnim != "jump_descent" && _chestSprite.currentAnim != "jump_descent_1arm" && _chestSprite.currentAnim != "jump_descent_0arm") && (_chestSprite.currentAnim != "jump_descent_loop" && _chestSprite.currentAnim != "jump_descent_loop_1arm" && _chestSprite.currentAnim != "jump_descent_loop_0arm"))
				{
					_chestSprite.play("jump_descent" + armStr);
				}
				else if ((_chestSprite.currentAnim == "jump_descent" || _chestSprite.currentAnim == "jump_descent_1arm" || _chestSprite.currentAnim == "jump_descent_0arm") && _chestSprite.complete)
				{
					_chestSprite.play("jump_descent_loop" + armStr);
				}
			}
			else if (Math.abs(_velocity.x) > 0)
			{
				_chestSprite.play("walk" + armStr);
			}
			else
			{
				_chestSprite.play("idle" + armStr);
			}
		}
		
		if (!_onGround)
		{
			if (_legsSprite.currentAnim != "jump_ascend" && _legsSprite.currentAnim != "jump_ascend_loop" && _legsSprite.currentAnim != "jump_descent" && _legsSprite.currentAnim != "jump_descent_loop")
			{
				_legsSprite.play("jump_ascend");
			}
			else if (_legsSprite.currentAnim == "jump_ascend" && _legsSprite.complete)
			{
				_legsSprite.play("jump_ascend_loop");	
			}
			
			if (_velocity.y > -1 && _legsSprite.currentAnim != "jump_descent" && _legsSprite.currentAnim != "jump_descent_loop")
			{
				_legsSprite.play("jump_descent");
			}
			else if (_legsSprite.currentAnim == "jump_descent" && _legsSprite.complete)
			{
				_legsSprite.play("jump_descent_loop");
			}
		}
		else if (Math.abs(_velocity.x) > 0)
		{
			_legsSprite.play("walk");
		}
		else
		{
			_legsSprite.play("idle");
		}
		
		if (_direction > 0)
		{
			_legsSprite.flipped = false;
			_chestSprite.flipped = false;
		}
		else if (_direction < 0)
		{
			_legsSprite.flipped = true;
			_chestSprite.flipped = true;
		}
	}

	public function takeDamage(type : DamageType)
	{
		if (type == DamageType.MELEE)
		{
			HXP.scene.remove(this);
		}
		else if (type == DamageType.RANGE)
		{
			if (_legCount == 0)
			{
				_looseArm();
			}
			else if (_armCount == 0)
			{
				_looseLeg();
			}
			else
			{
				var rand : Float = Math.random();
				if (rand < 0.5)
				{
					_looseLeg();
				}
				else
				{
					_looseArm();
				}
			}
		}
	}
	
	private var _sprite:Spritemap;
	
	private var _legsSprite:Spritemap;
	private var _chestSprite:Spritemap;

	private var _velocity:Vector2 = new Vector2(0., 0.);
	
	private var _short:Bool = false;
	private var _height:Int = 72;
	
	private var _direction:Int = 1;
	
	private var _onGround:Bool = false;
	private var _firedArm:Bool = false;
	private var _canFireArm:Bool = true;
	
	private var _text:Text;
}