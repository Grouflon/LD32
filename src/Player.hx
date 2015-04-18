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
import com.haxepunk.utils.Joystick;
import hxmath.math.Vector2;
import src.Arm;
import src.Leg;

/**
 * ...
 * @author ...
 */
class Player extends Entity
{

	public function new(x:Float=0, y:Float=0)
	{
		super(x, y);
		
		addGraphic(Image.createRect(30, cast(_height, Int), 0xFFFFFF, 1));
		
		setHitbox(30, cast(_height, Int));
		collidable = true;
		
		width = 30;
		height = cast(_height, Int);
		
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
			_height = 30;
			_resizePlayer();
		}
		else
		{
			_height = 50;
			_resizePlayer();
		}
		
		_playerMovement();
		_applyGravity();
	}
	
	
	private function _resizePlayer():Void
	{
		graphic = Image.createRect(30, cast(_height, Int), 0xFFFFFF, 1);
		
		setHitbox(30, cast(_height, Int));
		
		height = cast(_height, Int);
	}
	
	
	private function _fireArm()
	{
		if (_armCount > 0)
		{
			HXP.scene.add(new Arm(x, y, _direction));
			_armCount--;
		}
		
		trace("I have " + _armCount + " arms left...");
	}
	
	
	private function _fireLeg()
	{
		if (_legCount > 0)
		{
			HXP.scene.add(new Leg(x, y, _direction));
			_legCount--;
		}
		trace("I have " + _legCount + " legs left...");
	}
	
	
	private function _doJump():Void
	{
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
		moveBy(_velocity.x * _direction, _velocity.y, "block");
	}
	
	private var _gravity:Vector2 = new Vector2(0. , 20.);
	private var _velocity:Vector2 = new Vector2(0., 0.);
	
	private var _height:Float = 50.;
	
	private var _direction:Int = 1;
	private var _speed:Float = 5.;
	private var _reach:Float = 7.;
	
	private var _armCount:Int = 2;
	private var _legCount:Int = 2;
	
	private var _onGround:Bool = false;

}