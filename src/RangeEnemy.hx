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

	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _speed : Int, _visionRange : Int, _life : Int, _resistance : EnemyResistance) 
	{
		sprite = new Spritemap("graphics/enemy_woman_spritesheet.png", 84, 81);
		super(_owner, false, _xPos, _yPos, 44, 69, _speed, _visionRange, _resistance, _life, sprite);
		sprite.add("walk", [0, 1, 2, 3, 4, 5, 6, 7], 13);
		sprite.add("walk_arm", [10, 11, 12, 13, 14, 15, 16, 17], 13);
		sprite.add("walk_leg", [20, 21, 22, 23, 24, 25, 26, 27], 13);
		
		if (_resistance == EnemyResistance.ARM)
		{
			sprite.play("walk_arm");
		}
		else if (_resistance == EnemyResistance.LEG)
		{
			sprite.play("walk_leg");
		}
		else
		{
			sprite.play("walk");
		}
		
		sprite.originX = cast(sprite.width * 0.5, Int);
		sprite.originY = sprite.height;
		
		attackCooldown = GB.rangeAttackCooldown;
		attackTimer = 0;
		
		stateCooldown = GB.rangeStateChangeCooldown;
		stateTimer = 0;
	}
	
	override public function update() 
	{
		if (_isEnemyAlive)
		{
			if (GameController.isPlayerAlive())
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
				
				
				if (direction == Direction.LEFT)
				{
					originX = cast(width * 0.5, Int) + 12;
					sprite.flipped = true;
				}
				else
				{
					originX = cast(width * 0.5, Int) - 12;
					sprite.flipped = false;
				}
			}
		}
		else
			_fadeOut();
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
				
			HXP.scene.add(new EnemyProjectile(x + halfWidth, y - 40, player.x, player.y - 40, GB.rangeEnemyProjectileSpeed, GB.rangeEnemyProjectileRange));
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
			GameController.enemyKillplayer(this, false);
		}
		
		super.moveCollideX(e);
		
		return true;
	}
	
	private var attackCooldown : Int;
	private var attackTimer : Float;
	
	private var stateCooldown : Int;
	private var stateTimer : Float;
}