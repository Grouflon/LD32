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

/**
 * Enemy class
 * 
 * @author Etienne
 */

class Enemy extends Entity
{

	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _width : Int, _height : Int, defaultState : EnemyState, _speed : Int) 
	{
		super(_xPos, _yPos, Image.createRect(_width, _height, 0xFF0000));
	
		setHitbox(_width, _height);
		collidable = true;
		
		name = "enemy";
		type = "enemy";

		layer = 20;
		
        velocity = new Vector(0,0);
		speed = _speed;
		playerSpotted = false;
		moveDirection = Direction.RIGHT;
		this.defaultState = defaultState;
		onGround = false;
		
		owner = _owner;
	}
	
	public override function update()
	{
		// Gravité
		velocity.y += 2;
		
		// Mise à jour de l'état de l'ennemi
		if (isPlayerSpotted())
		{
			trace("Player is spotted");
			playerSpotted = true;
			state = EnemyState.CHASE;
		}
		else
		{
			playerSpotted = false;
			state = defaultState;
		}

		// Si le joueur n'est pas vu, on fait l'action par défaut
		if (!playerSpotted)
		{
			if (state == EnemyState.PATROL)
			{
				patrol();
			}
			else if (state == EnemyState.IDLE)
			{
				idle();
			}
			else
			{
				trace("This shouldn't happen : Enemy behavior isnt either patrol or idle when player is not spotted.");
			}
		}
		// Le joueur est repéré, on le poursuit
		else
		{
			chase();
		}
		
		moveBy(velocity.x, velocity.y, ["block", "platform", "player"]);
		
		velocity.x = 0;
		
		super.update();
	}
	
	private function canIGoLeft() : Bool
	{
		if (collide("block", x - this.width, y + 1) != null)
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
		if (collide("block", x + this.width, y + 1) != null)
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
		return false;
		var thisToPlayer:Vector = new Vector(0, 0);
		
		if (thisToPlayer.length > 200)
			return false
		else
			return true;
	}
	
	private function patrol()
	{
		// Si la direction actuelle est la gauche
		if (moveDirection == Direction.LEFT)
		{
			// Puis-je aller encore à gauche ?
			if (canIGoLeft())
			{
				velocity.x -= speed * HXP.elapsed;
			}
			// Sinon, puis-je aller à droite ?
			else if (canIGoRight())
			{
				moveDirection = Direction.RIGHT;
				velocity.x += speed * HXP.elapsed;
			}
		}
		// Si la direction actuelle est la droite
		else if (moveDirection == Direction.RIGHT)
		{
			// Puis-je aller encore à droite ?
			if (canIGoRight())
			{
				velocity.x += speed * HXP.elapsed;
			}
			// Sinon, puis-je aller à droite ?
			else if (canIGoLeft())
			{
				moveDirection = Direction.LEFT;
				velocity.x -= speed * HXP.elapsed;
			}
		}
		
	}
	
	private function idle()
	{
		
	}
	
	private function chase()
	{
	}
	
	private function distanceAttack()
	{
	}
	
	public override function moveCollideY(e:Entity):Bool
	{
		var velocitySign:Int = HXP.sign(velocity.y);
		if (velocitySign > 0)
		{
			if (e.type == "block")
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
		
		if (e.type == "block")
		{
			if (moveDirection == Direction.RIGHT)
				moveDirection = Direction.LEFT;
			else
				moveDirection = Direction.RIGHT;
		
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
	private var moveDirection:Direction;
	private var onGround:Bool;
	
	private var playerSpotted:Bool;
	private var state:EnemyState;
	private var defaultState:EnemyState;
	
	private var owner : EnemySpawner;
}