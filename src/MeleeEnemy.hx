package;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.math.Vector;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Draw;

/**
 * ...
 * @author Etienne
 */
class MeleeEnemy extends Enemy
{

	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _speed : Int, _visionRange : Int, _life : Int, _resistance : EnemyResistance) 
	{				
		sprite = new Spritemap("graphics/enemy_man_spritesheet.png", 84, 81);
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
		
		
		visionRangeDefault = _visionRange;
	}
	
	override public function update() 
	{
		super.update();
		
		applyGravity();
		
		if (cast(HXP.scene, MainScene).player.y == y)
			visionRange = GB.meleeSameYVisionRange;
		else
			visionRange = visionRangeDefault;
			
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
		var player : Entity = cast(HXP.scene, MainScene).player;
		
		var playerPosition : Vector = new Vector(player.x, player.y);
		var thisPosition : Vector = new Vector(x, y);
		
		var thisToPlayer : Vector = playerPosition - thisPosition;
		
		var playerDirection : Direction = Direction.RIGHT;
		
		if (thisToPlayer.x < 0)
			playerDirection = Direction.LEFT;
		else if (thisToPlayer.x > 0)
			playerDirection = Direction.RIGHT;
		
		if (playerDirection == Direction.LEFT)
		{
			if (canIGoLeft())
			{
				velocity.x -= GB.meleeChargeSpeed * HXP.elapsed;
				direction = playerDirection;
			}
		}
		else if (playerDirection == Direction.RIGHT)
		{
			if (canIGoRight())
			{
				direction = playerDirection;
				velocity.x += GB.meleeChargeSpeed * HXP.elapsed;
			}
		}
	}
	
	override public function moveCollideX(e:Entity):Bool
	{
		if (e.type == "player")
		{
			GameController.playerJustDied(this, false);
		}
		
		super.moveCollideX(e);
		
		return true;
	}
	/*
	override public function render()
	{
		Draw.hitbox(this);
		Draw.circle(cast(x, Int), cast(y, Int), 5, 0x00FF00);
		super.render();
	}
	*/
	
	private var stateCooldown : Int;
	private var stateTimer : Float;
	
	private var visionRangeDefault : Int;
}