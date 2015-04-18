package;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Screen;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.math.Vector;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import Direction;
import Player;

/**
 * Enemy class
 * 
 * @author Etienne
 */

class Enemy extends Entity
{

	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _width : Int, _height : Int, _speed : Int, _visionRange : Int) 
	{
		
		var rect : Image = Image.createRect(30, 50, 0xFF0000);
		rect.originX = cast(_width * 0.5, Int);
		rect.originY = _height;	
		
		super(_xPos, _yPos, rect);
	
		originX = cast(_width * 0.5, Int);
		originY = _height;
		
		setHitbox(_width, _height, originX, originY);
		
		collidable = true;
		
		name = "enemy";
		type = "enemy";

		layer = 20;
		
        velocity = new Vector(0,0);
		speed = _speed;
		direction = Direction.RIGHT;
		onGround = false;
		
		visionRange = _visionRange;
		
		playerSpotted = false;
		
		owner = _owner;
	}
	
	public function applyGravity()
	{
		velocity.y += 2;
	}
	
	public function applyMovement()
	{
		moveBy(velocity.x, velocity.y, ["block", "platform", "player"]);
		
		velocity.x = 0;
	}
	
	private function canIGoLeft() : Bool
	{
		if (collideTypes(["block", "platform"], x - this.halfWidth, y + 1) != null)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	private function canIGoRight() : Bool
	{
		if (collideTypes(["block", "platform"], x + this.halfWidth, y + 1) != null)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	private function isPlayerSpotted() : Bool
	{
		var player : Entity = HXP.scene.getInstance("player");
		
		var playerY : Float = player.y;
		
		if (distanceFrom(player, true) < 300)
		{
			if (bottom + 25 < player.top)
			{
				return false;
			}
			else if (top - 25 > player.bottom)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return false;
		}
	}
	
	public override function moveCollideY(e:Entity):Bool
	{
		var velocitySign:Int = HXP.sign(velocity.y);
		if (velocitySign > 0)
		{
			if (e.type == "block" || e.type == "platform")
			{
				onGround = true;
				velocity.y = 0;
			}
		}
		
		return true;
	}

	public override function moveCollideX(e:Entity):Bool
	{
		if (e.type == "player")
		{
			HXP.scene.remove(e);
		}
		
		if (e.type == "block" || e.type == "platform")
		{
			if (direction == Direction.RIGHT)
				direction = Direction.LEFT;
			else
				direction = Direction.RIGHT;
		
			velocity.x = 0;
		}
		
		return true;
	}
	
	public override function removed():Void 
	{
		super.removed();
		
		owner.notifyEnemyDeath();
	}
	
	private var speed:Float;
	private var velocity:Vector;
	private var direction:Direction;
	private var onGround:Bool;
	private var visionRange:Int;
	
	private var playerSpotted:Bool;
	private var state:EnemyState;
	
	private var owner : EnemySpawner;
}