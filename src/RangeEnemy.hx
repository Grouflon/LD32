package;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.math.Vector;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author Etienne
 */
class RangeEnemy extends Enemy
{

	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _width : Int, _height : Int, _speed : Int, _visionRange : Int, _life : Int, _resistance : EnemyResistance) 
	{	
		if (_resistance == EnemyResistance.ARM)
		{
			sprite = new Spritemap("graphics/range_arm.png", 32, 50);
		}
		else
		{
			sprite = new Spritemap("graphics/range_leg.png", 32, 50);
		}
		
		sprite.originX = cast(_width * 0.5, Int);
		sprite.originY = _height;
		
		sprite.add("normal", [0]);
		
		super(_owner, false, _xPos, _yPos, _width, _height, _speed, _visionRange, _resistance, _life,  sprite);
		
		attackCooldown = 1;
		attackTimer = 0;
		
		stateCooldown = 3;
		stateTimer = 0;
	}
	
	override public function update() 
	{
		super.update();
		
		applyGravity();
		
		// Mise à jour de l'état de l'ennemi
		if (isPlayerSpotted())
			playerSpotted = true;
		else
			playerSpotted = false;
		
		// Si le joueur n'est pas vu
		if (!playerSpotted)
		{
			// Alors qu'il était en combat, alors on reste encore un peu en attente
			if (state == EnemyState.COMBAT)
			{
				stateTimer = stateCooldown;
				
				stateTimer -= HXP.elapsed;
				
				if (stateTimer < 0)
				{
					state = EnemyState.CHILL;
					patrol();
				}
				else
				{
					combat();
				}
			}
			// Sinon on patrouille
			else
			{
				patrol();
			}
		}
		// Le joueur est repéré, attaque
		else
		{
			combat();
		}
		
		applyMovement();
	}
	
	
	private function patrol()
	{
		// Si la direction actuelle est la gauche
		if (direction == Direction.LEFT)
		{
			// Puis-je aller encore à gauche ?
			if (canIGoLeft())
			{
				velocity.x -= speed * HXP.elapsed;
			}
			// Sinon, puis-je aller à droite ?
			else if (canIGoRight())
			{
				direction = Direction.RIGHT;
				velocity.x += speed * HXP.elapsed;
			}
		}
		// Si la direction actuelle est la droite
		else if (direction == Direction.RIGHT)
		{
			// Puis-je aller encore à droite ?
			if (canIGoRight())
			{
				velocity.x += speed * HXP.elapsed;
			}
			// Sinon, puis-je aller à droite ?
			else if (canIGoLeft())
			{
				direction = Direction.LEFT;
				velocity.x -= speed * HXP.elapsed;
			}
		}	
		
		attackTimer = 0;
	}
	
	private function combat()
	{	
		var player:Player = cast(HXP.scene, MainScene).player;
		
		var playerPosition : Vector = new Vector(player.x, player.y);
		var thisPosition : Vector = new Vector(x, y);
		
		var thisToPlayer : Vector = playerPosition - thisPosition;
		var playerDirection : Direction = Direction.RIGHT;
		
		if (thisToPlayer.x < 0)
			playerDirection = Direction.LEFT;
		else if (thisToPlayer.x > 0)
			playerDirection = Direction.RIGHT;
		
		if (attackTimer <= 0)
		{	
			direction = playerDirection;
				
			HXP.scene.add(new EnemyProjectile(x + halfWidth, y - 40, player.x, player.y - 40, 200, visionRange));
			attackTimer = attackCooldown;
		}
		else
		{
			direction = playerDirection;
				
			attackTimer -= HXP.elapsed;
		}
	}
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		if (e.type == "player")
		{
			HXP.scene.remove(e);
			GameController.playerJustDied(this, false);
		}
		
		super.moveCollideX(e);
		
		return true;
	}
	
	
	private var attackCooldown : Int;
	private var attackTimer : Float;
	
	private var stateCooldown : Int;
	private var stateTimer : Float;
}