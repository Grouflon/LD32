package;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

/**
 * ...
 * @author Etienne
 */
class RangeEnemy extends Enemy
{

	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _width : Int, _height : Int, _speed : Int, _visionRange : Int) 
	{
		super(_owner, _xPos, _yPos, _width, _height, _speed, _visionRange);
		
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
		if (attackTimer <= 0)
		{
			var player : Entity = HXP.scene.getInstance("player");
			
			HXP.scene.add(new EnemyProjectile(x + halfWidth, y - 40, player.x, player.y - 40, 200, visionRange));
			attackTimer = attackCooldown;
		}
		else
		{
			attackTimer -= HXP.elapsed;
		}
	}
	
	private var attackCooldown : Int;
	private var attackTimer : Float;
	
	private var stateCooldown : Int;
	private var stateTimer : Float;
}