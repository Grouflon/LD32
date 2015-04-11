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
		_sprite = new Spritemap("graphics/player-sprite.png", 42, 57);
		
		_sprite.add("idle", [0]);
		_sprite.add("walk", [1, 2, 3, 4], 15);
		
		_sprite.x = -21;
		_sprite.y = -57;
		super(x, y, _sprite, null);
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (Input.check(Key.LEFT))
		{
			_sprite.scaleX = 1;
			_sprite.x = -21;
			_sprite.play("walk");
		}
		else if (Input.check(Key.RIGHT))
		{
			_sprite.scaleX = -1;
			_sprite.x = 21;
			_sprite.play("walk");
		}
		else
		{
			_sprite.play("idle");
		}
		
		_applyGravity();
		_applyVelocity();
	}
	
	private function _applyGravity():Void
	{
		_velocity = Vector2.add(_velocity, Vector2.multiply(_gravity, HXP.elapsed));
	}
	
	private function _applyVelocity():Void
	{
		moveBy(_velocity.x, _velocity.y);
		var groundLevel:Int = HXP.height - 100;
		if (y > groundLevel)
		{
			y = groundLevel;
			_velocity.y = 0;
		}
	}
	
	private var _gravity:Vector2 = new Vector2(0. , 10.);
	private var _velocity:Vector2 = new Vector2(0., 0.);
	
	private var _sprite:Spritemap;
}