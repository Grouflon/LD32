package;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Screen;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.math.Vector;
import Direction;

/**
 * Enemy class
 * 
 * @author Etienne
 */

class Enemy extends Entity
{

	public function new(x : Float, y : Float, img : Graphic, defaultState : EnemyState) 
	{
		super(x, y, img);
	
		setHitbox(50, 100);
		
		collidable = true;
		name = "Enemy";
        velocity = new Vector(0,0);
		speed = 50;
		playerSpotted = false;
		moveDirection = Direction.RIGHT;
		this.defaultState = defaultState;
		onGround = false;
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
		
		moveBy(velocity.x, velocity.y, "block");
		
		velocity.x = 0;
	}
	
	private function canIGoLeft() : Bool
	{
		return true;
		if (x < 50)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	private function canIGoRight() : Bool
	{
		return true;
		if (x > HXP.screen.width - 50 - width)
			return false;
		else
			return true;
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
	
	private var speed:Float;
	private var velocity:Vector;
	private var moveDirection:Direction;
	private var onGround:Bool;
	
	private var playerSpotted:Bool;
	private var state:EnemyState;
	private var defaultState:EnemyState;
}