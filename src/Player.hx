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
		addGraphic(Image.createRect(50, 50, 0xFFFFFF, 1));
		
		super(x, y);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		if (Input.check(Key.LEFT))
		{
			_leftDown = true;
		}
		else
		{
			_leftDown = false;
		}
		
		if (Input.check(Key.RIGHT))
		{
			_rightDown = true;
		}
		else
		{
			_rightDown = false;
		}
		
		_applyGravity();
		
		_playerMovement();
	}
	
	
	private function _applyGravity():Void
	{
		_velocity = Vector2.add(_velocity, Vector2.multiply(_gravity, HXP.elapsed));
	}
	
	private function _playerMovement():Void
	{
		moveBy(0, _velocity.y);
		/*
		var groundLevel:Int = HXP.height - 100;
		if (y > groundLevel)
		{
			y = groundLevel;
			_velocity.y = 0;
		}
		*/
		if (_leftDown && !_rightDown)
		{
			moveBy(-_velocity.x, 0);
		}
		else if (!_leftDown && _rightDown)
		{
			moveBy(_velocity.x, 0);
		}
	}
	
	private var _gravity:Vector2 = new Vector2(0. , 10.);
	private var _velocity:Vector2 = new Vector2(0., 0.);
	
	private var _leftDown:Bool 	= false;
	private var _rightDown:Bool = false;
}