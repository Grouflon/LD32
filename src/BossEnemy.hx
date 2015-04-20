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
		lastPhase = EnemyResistance.ARM;
		firstGroundTouch = false;
		
		phaseIntensity = 1;
		timeDashing = 0;
		isGoingUp = false;
		counterToMinusIntensity = 0;
		
		armPhaseDirection = Direction.RIGHT;
		legPhaseDirection = Direction.RIGHT;
		
		armLastXPos = 0;
		armLastXPosCounter = 0;
		
		legLastXPosCounter = 0;
		legLastXPos = 0;
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
	
	private function beginArmPhase()
	{
		isArmPhase = true;
		lastPhase = EnemyResistance.ARM;
		legPhaseDirection = Direction.RIGHT;
		addTween(new Alarm(GB.bossPhaseTimer * phaseIntensity, function (e:Dynamic = null):Void { setTired(); }, TweenType.OneShot), true);
	}
	
	private function beginLegPhase()
	{
		isLegPhase = true;
		lastPhase = EnemyResistance.LEG;
		legPhaseDirection = Direction.RIGHT;
		addTween(new Alarm(GB.bossPhaseTimer * phaseIntensity * 1.5, function (e:Dynamic = null):Void { setTired(); }, TweenType.OneShot), true);
	}
	
	private function wakeUp() : Void
	{
		awake = true;
		isInvincible = true;
		beginArmPhase();
		jumpOffPlatform();
	}
	
	private function notTiredAnymore() : Void
	{
		isInvincible = false;
		
		if (lastPhase == EnemyResistance.LEG)
			beginArmPhase();
		else
			beginLegPhase();
	}
	
	private function armPhase()
	{
		if (onGround)
		{
			if (armPhaseDirection == Direction.LEFT)
			{
				direction = armPhaseDirection;
				velocity.x -= speed * 1.5 * phaseIntensity * HXP.elapsed;
				timeDashing += HXP.elapsed;
				
				if (armLastXPos == x)
				{
					armLastXPosCounter++;
					
					if (armLastXPosCounter > 1)
					{
						armLastXPosCounter = 0;
						armPhaseDirection = Direction.RIGHT;
					}
						
				}
				armLastXPos = x;
			}
			else if (armPhaseDirection == Direction.RIGHT)
			{
				direction = armPhaseDirection;
				velocity.x += speed * 1.5 * phaseIntensity * HXP.elapsed;
				timeDashing += HXP.elapsed;
				
				if (armLastXPos == x)
				{
					armLastXPosCounter++;
					
					if (armLastXPosCounter > 1)
					{
						armPhaseDirection = Direction.LEFT;
						armLastXPosCounter = 0;
					}
				}
				
				armLastXPos = x;
			}
			
			/*if (armPhaseDirection == Direction.LEFT)
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
			}*/
			
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
			
			if (armPhaseDirection == Direction.LEFT)
			{
				velocity.x -= speed / 2 * phaseIntensity * HXP.elapsed;
				
				if (armLastXPos == x)
				{
					armLastXPosCounter++;
					
					if (armLastXPosCounter > 1)
					{
						armLastXPosCounter = 0;
						armPhaseDirection = Direction.RIGHT;
					}
						
				}
				armLastXPos = x;
			}
			else if (armPhaseDirection == Direction.RIGHT)
			{
				velocity.x += speed / 2 * phaseIntensity * HXP.elapsed;
				
				if (armLastXPos == x)
				{
					armLastXPosCounter++;
					
					if (armLastXPosCounter > 1)
					{
						armPhaseDirection = Direction.LEFT;
						armLastXPosCounter = 0;
					}
				}
				
				armLastXPos = x;
			}
			/*if (playerDirection == Direction.LEFT)
			{
				velocity.x -= speed / 2 * phaseIntensity * HXP.elapsed;
				direction = playerDirection;
			}
			else if (playerDirection == Direction.RIGHT)
			{
				direction = playerDirection;
				velocity.x += speed / 2 * phaseIntensity * HXP.elapsed;
			}*/
		}
	}
	
	private function armAttack()
	{
		timeDashing = 0;
		jump(15 + phaseIntensity * 2);
	}
	
	private function _armAttack()
	{
		var rand : Float = Math.random();
		
		if (phaseIntensity == 1)
		{
			if (rand > 0.5)
			{
				fireArm( -1, 20, 1);
				fireArm( -1, 20, 2);
				fireArm( 1, 20, 1);
				fireArm( 1, 20, 2);
			}
			else
			{
				fireArm( -1, 20, 3);
				fireArm( -1, 20, 1);
				fireArm( 1, 20, 4);
				fireArm( 1, 20, 2);
			}
		}
		else if (phaseIntensity == 2)
		{
			if (rand > 0.5)
			{
			fireArm( -1, 20, 1);
			fireArm( -1, 20, 2);
			fireArm( -1, 20, 3);
			fireArm( 1, 20, 1);
			fireArm( 1, 20, 2);
			fireArm( 1, 20, 3);
			}
			else
			{
			fireArm( -1, 20, 5);
			fireArm( -1, 20, 3);
			fireArm( -1, 20, 1);
			fireArm( 1, 20, 4);
			fireArm( 1, 20, 3);
			fireArm( 1, 20, 2);
			}
		}
		else if (phaseIntensity == 3)
		{
			fireArm( -1, 20, 1);
			fireArm( -1, 20, 2);
			fireArm( -1, 20, 3);
			fireArm( -1, 20, 4);
			fireArm( 1, 20, 1);
			fireArm( 1, 20, 2);
			fireArm( 1, 20, 3);
			fireArm( 1, 20, 4);
		}
		else if (phaseIntensity == 4)
		{
			fireArm( -1, 20, 1);
			fireArm( -1, 20, 2);
			fireArm( -1, 20, 3);
			fireArm( -1, 20, 4);
			fireArm( -1, 20, 5);
			fireArm( 1, 20, 1);
			fireArm( 1, 20, 2);
			fireArm( 1, 20, 3);
			fireArm( 1, 20, 4);
			fireArm( -1, 20, 5);
		}
	}
	
	private function legPhase()
	{	
		if (onGround)
		{
			legAttack();
		}
		else
		{	
			// declenche la leg attack au sommet du saut
			if (velocity.y > 0)
			{
				if (isGoingUp)
					_legAttack();
					
				isGoingUp = false;
			}
			
			if (legPhaseDirection == Direction.LEFT)
			{
				direction = legPhaseDirection;
				velocity.x -= speed * 1.5 * phaseIntensity * HXP.elapsed;
				
				if (legLastXPos == x)
				{
					legLastXPosCounter++;
					
					if (legLastXPosCounter > 1)
					{
						legLastXPosCounter = 0;
						legPhaseDirection = Direction.RIGHT;
					}
						
				}
				legLastXPos = x;
			}
			else if (legPhaseDirection == Direction.RIGHT)
			{
				direction = legPhaseDirection;
				velocity.x += speed * 1.5 * phaseIntensity * HXP.elapsed;
				
				if (legLastXPos == x)
				{
					legLastXPosCounter++;
					
					if (legLastXPosCounter > 1)
					{
						legPhaseDirection = Direction.LEFT;
						legLastXPosCounter = 0;
					}
				}
				
				legLastXPos = x;
			}
		}
	}
	
	private function legAttack()
	{	
		jump(15 + phaseIntensity * 2);
	}
	
	private function _legAttack()
	{
		var rand : Float = Math.random();
		if (rand < 0.5)
			HXP.scene.add(new Leg(x, y, playerDirectionInt, 20, false));
		else
			HXP.scene.add(new Leg(x, y, -playerDirectionInt, 20, false));
	}
	
	private function setTired()
	{
		isTired = true;
		velocity.x = 0;
		velocity.y = 0;
		
		x = 500;
		y = 150;
		
		isInvincible = false;
		isArmPhase = false;
		isLegPhase = false;
	}
	
	private function tired()
	{
		///
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

	override public function moveCollideX(e:Entity):Bool
	{
		if (e.type == "player")
		{
			GameController.playerJustDied(this, true);
		}
		
		super.moveCollideX(e);
		
		return true;
	}
	
	
	private function fireArm(_direction : Int, _fireHeight : Int, i : Int)
	{
		var orientation : Orientation;
		
		if (_direction < 0)
		{
			if (i == 0)
			{
				orientation = Orientation.NWW;
			}
			else if (i == 1)
			{
				orientation = Orientation.SWW;
			}
			else if (i == 2)
			{
				orientation = Orientation.W;
			}
			else if (i == 3)
			{
				orientation = Orientation.SW;
			}
			else if (i == 4)
			{
				orientation = Orientation.NW;
			}
			else
			{
				orientation = Orientation.NNW;
			}
		}
		else
		{
			if (i == 0)
			{
				orientation = Orientation.NEE;
			}
			else if (i == 1)
			{
				orientation = Orientation.SEE;
			}
			else if (i == 2)
			{
				orientation = Orientation.E;
			}
			else if (i == 3)
			{
				orientation = Orientation.SE;
			}
			else if (i == 4)
			{
				orientation = Orientation.NE;
			}
			else
			{
				orientation = Orientation.NNE;
			}
		}
		
		HXP.scene.add(new Arm(x, y, _direction, orientation, _fireHeight, false));
	}
	
	public override function notifyDamage(projectileType : EnemyResistance) : Void
	{
		if (awake)
		{
			if (!isInvincible)
			{
				if (life > 0)
				{
					life--;
					
					counterToMinusIntensity++;
					
					if (counterToMinusIntensity == GB.phaseNumberToPlusIntensity)
					{
						counterToMinusIntensity = 0;
						phaseIntensity++;
					}
					
					if (life <= 0)
						HXP.scene.remove(this);// bossEnd();
						
						notTiredAnymore();
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
	
	private var lastPhase : EnemyResistance;
	
	private var counterToMinusIntensity : Int;
	
	private var firstGroundTouch : Bool;
	
	private var canFireLeg : Bool;
	private var fireLegCooldown : Float;
	
	private var timeDashing : Float;
	
	private var legPhaseDirection : Direction;
	private var armPhaseDirection : Direction;
	
	private var legLastXPos : Float;
	private var legLastXPosCounter : Int;
	
	private var armLastXPos : Float;
	private var armLastXPosCounter : Int;
}