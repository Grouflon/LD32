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
import com.haxepunk.graphics.Text;
import hxmath.math.Vector2;

// Local Imports
import GB;
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
		Input.define("MoveDown", [Key.CONTROL, Key.DOWN]);
		Input.define("FireArm", [Key.Q]);
		Input.define("FireLeg", [Key.E]);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		_checkGround();
		
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
		
		if (Input.check("MoveDown"))
		{
			_onKeyDown = true;
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
		_updateSize();

		
		_playerMovement();
		_applyGravity();
		
		_updateGraphics();
	
		_onKeyDown = false;
		_firedArm = false;
		_firedLeg = false;
		_hitPlatformLastFrame = _hitPlatform;
		_hitPlatform = false;
		_lastFramePosition.x = x;
		_lastFramePosition.y = y;
	}

	
	public function addLeg():Void
	{
		if (_maxLegCount < 2)
		{
			_maxLegCount++;
		}
		
		_legCount++;
	}
	
	
	public function addArm():Void
	{
		if (_maxArmCount < 2)
		{
			_maxArmCount++;
		}
		
		_armCount++;
	}
	
	
	private function _fireArm()
	{
		if (_armCount > 0 && _canFireArm)
		{
			_firedArm = true;
			_canFireArm = false;
			_armCount--;
			
			addTween(new Alarm(_limbFireDelay, function (e:Dynamic = null):Void { HXP.scene.add(new Arm(x, y, _direction, _height, true)); }, TweenType.OneShot), true);
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (this._armCount < _maxArmCount) this._armCount++; }, TweenType.OneShot), true);
			addTween(new Alarm(_limbFireCooldown, function (e:Dynamic = null):Void { _canFireArm = true; }, TweenType.OneShot), true);
		}
	}
	
	
	private function _fireLeg()
	{
		if (_legCount > 0 && _canFireLeg)
		{
			_firedLeg = true;
			_canFireLeg = false;
			_legCount--;
			
			addTween(new Alarm(_limbFireDelay, function (e:Dynamic = null):Void { HXP.scene.add(new Leg(x, y, _direction, _height, true)); }, TweenType.OneShot), true);
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (this._legCount < _maxLegCount) this._legCount++; }, TweenType.OneShot), true);
			addTween(new Alarm(_limbFireCooldown, function (e:Dynamic = null):Void { _canFireLeg = true; }, TweenType.OneShot), true);
		}
	}
	
		
	private function _looseArm()
	{
		if (_armCount > 0)
		{
			_armCount--;
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (this._armCount < _maxArmCount) this._armCount++; }, TweenType.OneShot), true);
		}
	}
	
	
	private function _looseLeg()
	{
		if (_legCount > 0)
		{
			_legCount--;
			addTween(new Alarm(5., function (e:Dynamic = null):Void { if (this._legCount < _maxLegCount) this._legCount++; }, TweenType.OneShot), true);
		}
	}

	
	private function _doJump():Void
	{
		if (_short)
		{
			_reach = GB.playerShortReach;
		}
		else
		{
			_reach = GB.playerTallReach;
		}
		_onGround = false;
		_velocity.y = -_reach;
	}
	
	override public function moveCollideY(e:Entity):Bool
	{		
		if (e.type == "enemy")
		{
			takeDamage(DamageType.MELEE);
			return true;
		}
		
		else if (e.type == "platform")
		{
			_hitPlatform = true;
			if (_onGround)
			{
				_velocity.y = 0;
				return true;
			}
			else if (!_hitPlatformLastFrame && _velocity.y > 0 && y > _lastFramePosition.y)
			{
				var startY:Int = cast(Math.ceil(y), Int);
				var endY:Int = cast(Math.floor(_lastFramePosition.y), Int);
				
				while (startY >= endY)
				{
					var e:Entity = collide("platform", x, startY);
					if (e == null)
					{
						_onGround = true;
						_velocity.y = 0;
						return true;
					}
					--startY;
				}
				return false;
			}
			else
			{
				return false;
			}
			/*if ((e.top >= this.bottom || _onGround) && !_onKeyDown)
			{
				_onGround = true;
				_velocity.y = 0;
				return true;
			}*/
		}
		
		else if (e.type == "block")
		{
			if (_velocity.y >= 0)
			{
				_onGround = true;
				_velocity.y = 0;
			}
			return true;
		}
		
		return false;
	}
	
	override public function moveCollideX(e:Entity):Bool
	{
		if (e.type == "enemy")
		{
			takeDamage(DamageType.MELEE);
		}
		
		if (e.type == "platform")
		{
			_hitPlatform = true;
			return false;
		}
		
		return true;
	}
	
	override public function render():Void
	{
		super.render();
		/*var xI:Int = cast(Math.round(x), Int);
		var yI:Int = cast(Math.round(y), Int);
		Draw.circle(xI, yI, 5, 0x00FF00);
		Draw.hitbox(this, true);*/
	}
	
	
	private function _applyGravity():Void
	{
		_velocity = Vector2.add(_velocity, Vector2.multiply(GB.gravity, HXP.elapsed));
	}
	
	private function _playerMovement():Void
	{
		if (_short && _onGround)
		{
			_speed = GB.playerLeglessSpeed;
		}
		else
		{
			_speed = GB.playerSpeed;
		}
		
		moveBy(_velocity.x * _direction, _velocity.y, ["block", "platform", "enemy"]);
	}
	
	private function _initGraphics():Void
	{
		_legsSprite = new Spritemap("graphics/player_legs_spritesheet.png", 78, 75);
		_legsSprite.add("idle", [0], 10);
		_legsSprite.add("idle_1leg", [70], 10);
		_legsSprite.add("idle_0leg", [80], 10);
		_legsSprite.add("walk", [10, 11, 12, 13, 14, 15, 16], 13);
		_legsSprite.add("walk_1leg", [50, 51, 52, 53, 54, 55, 56], 13);
		_legsSprite.add("jump_ascend", [20, 21], 13, false);
		_legsSprite.add("jump_ascend_1leg", [90, 91], 13, false);
		_legsSprite.add("jump_ascend_0leg", [100, 101], 13, false);
		_legsSprite.add("jump_ascend_loop", [22, 23], 13, true);
		_legsSprite.add("jump_ascend_loop_1leg", [92, 93], 13, true);
		_legsSprite.add("jump_ascend_loop_0leg", [102, 103], 13, true);
		_legsSprite.add("jump_descent", [24, 25], 13, false);
		_legsSprite.add("jump_descent_1leg", [94, 95], 13, false);
		_legsSprite.add("jump_descent_0leg", [104, 105], 13, false);
		_legsSprite.add("jump_descent_loop", [26, 27], 13, true);
		_legsSprite.add("jump_descent_loop_1leg", [96, 97], 13, true);
		_legsSprite.add("jump_descent_loop_0leg", [106, 107], 13, true);
		_legsSprite.add("leg1_tearing", [30, 31, 32, 33], 13, false);
		_legsSprite.add("leg2_tearing", [40, 41, 42, 43], 13, false);
		
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
	
	private function _updateSize():Void
	{
		if (_legCount == 0)
		{
			if (!_short)
			{
				_short = true;
				_shortAlarm = new Alarm(_limbFireDelay, function (e:Dynamic = null):Void {
					height = _shortHeight;
					originY = height;
					
					_legsSprite.originY = _legsSprite.height - (_height - _shortHeight);
					_chestSprite.originY = _chestSprite.height - (_height - _shortHeight);
					
					if (_onGround)
					{
						moveBy(0, -_height + _shortHeight, ["block", "platform", "enemy"]);
					}
					
					_shortAlarm = null;
				}, TweenType.OneShot);
				
				addTween(_shortAlarm, true);
			}
		}
		else
		{
			if (_short)
			{
				if (_shortAlarm != null) _shortAlarm.cancel();
				_short = false;
				height = _height;
				originY = height; 
				
				_legsSprite.originY = _legsSprite.height;
				_chestSprite.originY = _chestSprite.height;
				
				if (!_onGround)
				{
					moveBy(0, _height - _shortHeight, ["block", "platform", "enemy"]);
				}
			}
		}
	}
	
	private function _updateGraphics():Void
	{
		// CHEST
		if (_firedArm && (_armCount == 1)) _chestSprite.play("arm1_tearing");
		if (_firedArm && (_armCount== 0)) _chestSprite.play("arm2_tearing");
		
		var armStr:String = "";
		if (_armCount == 1) armStr = "_1arm";
		else if (_armCount== 0) armStr = "_0arm";
		
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
		
		// LEGS
		if (_firedLeg && (_legCount == 1)) _legsSprite.play("leg1_tearing");
		if (_firedLeg && (_legCount == 0)) _legsSprite.play("leg2_tearing");
		
		var legStr:String = "";
		if (_legCount == 1) legStr = "_1leg";
		else if (_legCount == 0) legStr = "_0leg";
		
		if ((_legsSprite.currentAnim != "leg1_tearing" && _legsSprite.currentAnim != "leg2_tearing") || _legsSprite.complete)
		{
			if (!_onGround)
			{
				if ((_legsSprite.currentAnim != "jump_ascend" && _legsSprite.currentAnim != "jump_ascend_1leg" && _legsSprite.currentAnim != "jump_ascend_0leg") &&
					(_legsSprite.currentAnim != "jump_ascend_loop" && _legsSprite.currentAnim != "jump_ascend_loop_1leg" && _legsSprite.currentAnim != "jump_ascend_loop_0leg") &&
					(_legsSprite.currentAnim != "jump_descent" && _legsSprite.currentAnim != "jump_descent_1leg" && _legsSprite.currentAnim != "jump_descent_0leg") &&
					(_legsSprite.currentAnim != "jump_descent_loop" && _legsSprite.currentAnim != "jump_descent_loop_1leg" && _legsSprite.currentAnim != "jump_descent_loop_0leg"))
				{
					_legsSprite.play("jump_ascend" + legStr);
				}
				else if ((_legsSprite.currentAnim == "jump_ascend" && _legsSprite.currentAnim == "jump_ascend_1leg" && _legsSprite.currentAnim == "jump_ascend_0leg") && _legsSprite.complete)
				{
					_legsSprite.play("jump_ascend_loop" + legStr);
				}
				
				if (_velocity.y > -1 && (_legsSprite.currentAnim != "jump_descent" && _legsSprite.currentAnim != "jump_descent_1leg" && _legsSprite.currentAnim != "jump_descent_0leg") && (_legsSprite.currentAnim != "jump_descent_loop" && _legsSprite.currentAnim != "jump_descent_loop_1leg" && _legsSprite.currentAnim != "jump_descent_loop_0leg"))
				{
					_legsSprite.play("jump_descent" + legStr);
				}
				else if ((_legsSprite.currentAnim == "jump_descent" || _legsSprite.currentAnim == "jump_descent_1leg" || _legsSprite.currentAnim == "jump_descent_0leg") && _legsSprite.complete)
				{
					_legsSprite.play("jump_descent_loop" + legStr);
				}
			}
			else if (Math.abs(_velocity.x) > 0)
			{
				_legsSprite.play("walk" + legStr);
			}
			else
			{
				_legsSprite.play("idle" + legStr);
			}
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
			GameController.playerJustDied(this, false);
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
	
	
	public function getArmCount():Int { return _armCount; }
	public function getLegCount():Int { return _legCount; }
	
	private function _checkGround():Void
	{
		_onGround = false;
		if (_velocity.y >= 0)
		{
			var types:Dynamic = ["block", "platform"];
			for (i in 0...2)
			{
				var e:Entity = scene.collideRect(types[i], x - halfWidth, y, width, 1);
				if (e != null)
				{
					_onGround = true;
					break;
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
	private var _shortHeight:Int = 54;
	private var _shortAlarm:Alarm = null;
	
	private var _reach:Float = GB.playerTallReach;
	private var _speed:Float = GB.playerSpeed;
	
	private var _direction:Int = 1;

	private var _onKeyDown:Bool = false;
	
	private var _hitPlatform:Bool = false;
	private var _hitPlatformLastFrame:Bool = false;
	private var _lastFramePosition:Vector2 = new Vector2(0., 0.);

	private var _maxArmCount:Int = 0;
	private var _maxLegCount:Int = 0;
	
	private var _armCount:Int = 0;
	private var _legCount:Int = 0;
	
	private var _onGround:Bool = false;
	private var _firedArm:Bool = false;
	private var _firedLeg:Bool = false;
	private var _canFireArm:Bool = true;
	private var _canFireLeg:Bool = true;
	private var _limbFireCooldown:Float = .3;
	private var _limbFireDelay:Float = .15;
	
	private var _text:Text;
}