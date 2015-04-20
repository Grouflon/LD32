package;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.math.Vector;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween;

import Arm;
import Leg;
import GB;

/**
 * ...
 * @author Etienne
 */
class BossEnemy extends Enemy
{
	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _width : Int, _height : Int, _speed : Int, _visionRange : Int, _life : Int) 
	{
		var _resistance : EnemyResistance = EnemyResistance.BOTH;
		
		sprite = new Spritemap("graphics/boss.png", _width, _height);
		sprite.flipped = true;
		
		sprite.originX = cast(_width * 0.5, Int);
		sprite.originY = _height;
		
		sprite.add("normal", [0]);
		
		super(_owner, true, _xPos, _yPos, _width, _height, _speed, _visionRange, _resistance, _life, sprite);
		
		awake = false;
		isInvincible = false;
		isTired = true;
		isArmPhase = false;
		isLegPhase = false;
		
		fireLegCooldown = GB.bossInitialLegCooldown;
		
		speed = GB.bossSpeed;
		
		firstGroundTouch = false;
		
		phaseIntensity = 1;
		timeDashing = 0;
		isGoingUp = false;
	}
	
	private function updatePlayerInfo() : Void
	{
		var playerPosition : Vector = new Vector(player.x, player.y);
		var thisPosition : Vector = new Vector(x, y);
		
		thisToPlayer = playerPosition - thisPosition;
		
		playerDirection = Direction.RIGHT;
		
		if (thisToPlayer.x <= 0)
		{
			playerDirection = Direction.LEFT;
			playerDirectionInt = -1;
		}
		else if (thisToPlayer.x > 0)
		{
			playerDirection = Direction.RIGHT;
			playerDirectionInt = 1;
		}
	}
	
	override public function update() 
	{
		if (GameController.isPlayerAlive())
		{
			player = cast(HXP.scene.getInstance("player"), Player);
			
			applyGravity();
		
			updatePlayerInfo();
			
			if (awake)
			{
				if (isArmPhase)
				{
					armPhase();
				}
				else if (isLegPhase)
				{
					legPhase();
				}
				else if (isTired)
				{
					tired();
				}
				else
				{
					trace("nothing to do ..?");
				}
			}
			
			applyMovement();
		}
	}
	
		
	private function wakeUp() : Void
	{
		awake = true;
		isInvincible = true;
		isArmPhase = true;
		jumpOffPlatform();
	}
	
	private function armPhase()
	{
		if (onGround)
		{
			if (playerDirection == Direction.LEFT)
			{
				velocity.x -= speed * phaseIntensity * HXP.elapsed;
				direction = playerDirection;
				timeDashing += HXP.elapsed;
				
			}
			else if (playerDirection == Direction.RIGHT)
			{
				direction = playerDirection;
				velocity.x += speed * phaseIntensity * HXP.elapsed;
				timeDashing += HXP.elapsed;
			}
			
			if (timeDashing > 5 - phaseIntensity)
				armAttack();
		}
		else
		{	
			// declenche l' arm attack au sommet du saut
			if (velocity.y > 0)
			{
				if (isGoingUp)
					_armAttack();
					
				isGoingUp = false;
			}
			
			if (playerDirection == Direction.LEFT)
			{
				velocity.x -= speed / 2 * phaseIntensity * HXP.elapsed;
				direction = playerDirection;
			}
			else if (playerDirection == Direction.RIGHT)
			{
				direction = playerDirection;
				velocity.x += speed / 2 * phaseIntensity * HXP.elapsed;
			}
		}
	}
	
	private function armAttack()
	{
		timeDashing = 0;
		jump(15 + phaseIntensity * 2);
	}
	
	private function _armAttack()
	{
		fireArm(-1, 20);
		fireArm(1, 30);
	}
	
	private function legPhase()
	{
	}
	
	private function tired()
	{
	}
	
	private function jump(reach : Int)
	{
		onGround = false;
		velocity.y -= reach;
		isGoingUp = true;
	}
	
	private function jumpOffPlatform()
	{
		onGround = false;
		velocity.y -= 15;
		velocity.x += 15;
	}
	
	
	
	/*private function patrol()
	{
		if (legCount > 0)
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
	}
	
	private function combat()
	{	
			
		if (legCount > 0)
		{
			if (playerDirection == Direction.LEFT)
			{
				if (canIGoLeft())
				{
					velocity.x -= speed * legCount * 2 * HXP.elapsed;
					direction = playerDirection;
				}
			}
			else if (playerDirection == Direction.RIGHT)
			{
				if (canIGoRight())
				{
					direction = playerDirection;
					velocity.x += speed * legCount * 2 * HXP.elapsed;
				}
			}
		}
		
		if (armCount > 0 && canFireArm && canFire)
		{
			if (playerDirection == Direction.RIGHT)
				fireArm(1);
			else
				fireArm(-1);
		}
		else if (legCount > 1 && canFireLeg && canFire)
		{
			if (playerDirection == Direction.RIGHT)
				fireLeg(1);
			else
				fireLeg(-1);
		}
	}*/
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		if (e.type == "player")
		{
			GameController.playerJustDied(this, true);
		}
		
		super.moveCollideX(e);
		
		return true;
	}
	
	
	private function fireArm(_direction : Int, _fireHeight : Int)
	{
		HXP.scene.add(new Arm(x, y, _direction, _direction < 0 ? W : E, _fireHeight, false));
	}
	
	/*private function fireLeg(_direction : Int) : Void
	{
		canFireLeg = false;
		canFire = false;
		
		HXP.scene.add(new Leg(x, y, _direction, fireLegHeight, false));
		addTween(new Alarm(fireLegCooldown, function (e:Dynamic = null):Void { canFireLeg = true; }, TweenType.OneShot), true);
		addTween(new Alarm(fireCooldown, function (e:Dynamic = null):Void { canFire = true; }, TweenType.OneShot), true);
	}*/
	
	public override function notifyDamage(projectileType : EnemyResistance) : Void
	{
		if (awake)
		{
			if (!isInvincible)
			{
				if (life > 0)
				{
					life--;
					
					if (life <= 0)
						HXP.scene.remove(this);// bossEnd();
				}
				else
				{
					trace("PAS DE DEGAT SUR CE PROJECTILE");
				}
			}
		}
		else
		{
			wakeUp();
		}
	}
	
	private var isGoingUp : Bool;
	
	private var player : Player;
	private var thisToPlayer : Vector;
	private var playerDirection : Direction;
	private var playerDirectionInt : Int;
	
	private var awake : Bool;
	private var isTired : Bool;
	private var isInvincible : Bool;
	
	private var phaseIntensity : Int;
	private var isArmPhase : Bool;
	private var isLegPhase : Bool;
	
	private var firstGroundTouch : Bool;
	
	private var canFireLeg : Bool;
	private var fireLegCooldown : Float;
	
	private var timeDashing : Float;
}