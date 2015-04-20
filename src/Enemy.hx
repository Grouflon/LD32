package;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Screen;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween;
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

	public function new(_owner : EnemySpawner, _isBoss : Bool, _xPos : Float, _yPos : Float, _width : Int, _height : Int, _speed : Int, _visionRange : Int, _resistance : EnemyResistance, _life : Int, _sprite : Spritemap) 
	{
		super(_xPos, _yPos, _sprite);
	
		sprite.play("normal");
		
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
		resistance = _resistance;
		life = _life;
		
		playerSpotted = false;
			
		isBoss = _isBoss;
		
		owner = _owner;
		
		resistArm = new Text("This arm is way too weak to hurt me !", x - 80, y - 60, 0, 0);
		resistLeg = new Text("Nope, I didn't skip leg day !", x - 60, y - 80, 0, 0);
		
		resistArm.visible = false;
		resistLeg.visible = false;
		
		HXP.scene.addGraphic(resistArm);
		HXP.scene.addGraphic(resistLeg);
	}
	
	public function applyGravity()
	{
		velocity.y += 1;
	}
	
	public function applyMovement()
	{
		if (GameController.isPlayerAlive())
		{
			if (!isBoss)
				moveBy(velocity.x, velocity.y, ["block", "platform", "player"]);
			else
				moveBy(velocity.x, velocity.y, ["block", "player"]);
		}
		
		if (direction == Direction.LEFT)
			sprite.flipped = true;
		else if (direction == Direction.RIGHT)
			sprite.flipped = false;
			
		velocity.x = 0;
	}
	
	private function canIGoLeft() : Bool
	{
		if (!isBoss)
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
		else
		{
			if (collide("block", x - this.halfWidth, y + 1) != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	
	private function canIGoRight() : Bool
	{
		if (!isBoss)
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
		else
		{
			if (collide("block", x + this.halfWidth, y + 1) != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	
	private function isPlayerSpotted() : Bool
	{
		var player : Player = cast(HXP.scene, MainScene).player;
		
		var playerY : Float = player.y;
		
		if (distanceFrom(player, true) < visionRange)
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
			if (e.type == "block" || (!isBoss && e.type == "platform"))
			{
				onGround = true;
				velocity.y = 0;
			}
		}
		
		return true;
	}

	public override function moveCollideX(e:Entity):Bool
	{		
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
		
		if (owner != null)
			owner.notifyEnemyDeath();
	}
	
	public function notifyDamage(projectileType : EnemyResistance):Void
	{
		if (projectileType != resistance)
		{
			life--;
			
			if (life <= 0)
				HXP.scene.remove(this);
		}
		else
		{
			var limbDummy:LimbDummy;
			
			if (resistance == EnemyResistance.ARM)
			{
				trace("Resistant to arm");
				resistArm.visible = true;
				limbDummy = new LimbDummy(x, y, "arm");
				HXP.scene.add(limbDummy);
				this.addTween(new Alarm(2., function (e:Dynamic) {
					resistArm.visible = false;
				}, TweenType.OneShot), true);
			}
			else if (resistance == EnemyResistance.LEG)
			{
				resistLeg.visible = true;
				limbDummy = new LimbDummy(x, y, "leg");
				HXP.scene.add(limbDummy);
				this.addTween(new Alarm(2., function (e:Dynamic) {
					resistLeg.visible = false;
				}, TweenType.OneShot), true);
			}

		}
	}
	
	private var speed:Float;
	private var velocity:Vector;
	private var direction:Direction;
	private var onGround:Bool;
	private var visionRange:Int;
	private var resistance:EnemyResistance;
	private var life : Int;
	private var playerSpotted:Bool;
	private var state:EnemyState;
	private var isBoss : Bool;
	
	private var sprite : Spritemap;
	private var owner : EnemySpawner;
	
	private var resistLeg:Text;
	private var resistArm:Text;
}