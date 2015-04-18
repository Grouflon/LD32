package;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.math.Vector;

/**
 * ...
 * @author Etienne
 */
class MeleeEnemy extends Enemy
{

	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _width : Int, _height : Int, _speed : Int, _visionRange : Int) 
	{
		super(_owner, _xPos, _yPos, _width, _height, _speed, _visionRange);
	}
	
	override public function update() 
	{
		super.update();
		
		applyGravity();
		
		if (HXP.scene.getInstance("player").y == y)
			visionRange = 400;
		else
			visionRange = 200;
			
		// Mise à jour de l'état de l'ennemi
		if (isPlayerSpotted())
			playerSpotted = true;
		else
			playerSpotted = false;
		
		// Si le joueur n'est pas vu
		if (!playerSpotted)
		{
			patrol();
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
	}
	
	private function combat()
	{	
		var player : Entity = HXP.scene.getInstance("player");
		
		var playerPosition : Vector = new Vector(player.x, player.y);
		var thisPosition : Vector = new Vector(x, y);
		
		var thisToPlayer : Vector = playerPosition - thisPosition;
		
		var playerDirection : Direction = Direction.RIGHT;
		
		if (x < 0)
			playerDirection = Direction.LEFT;
		else if (x > 0)
			playerDirection = Direction.RIGHT;
		
		if (playerDirection == Direction.LEFT)
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
		else if (playerDirection == Direction.RIGHT)
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
	}
	
	private var stateCooldown : Int;
	private var stateTimer : Float;
}