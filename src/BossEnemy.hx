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
		
		visionRangeDefault = _visionRange;
		
		armCount = GB.initialBossArm;
		legCount = GB.initialBossLeg;
		
		canFire = true;
		canFireArm = true;
		canFireLeg = true;
		
		fireLegCooldown = GB.bossFireLegCooldown;
		fireArmCooldown = GB.bossFireArmCooldown;
		fireCooldown = GB.bossFireCooldown;
		
		fireArmHeight = _height - 50;
		fireLegHeight = _height;
	}
	
	override public function update() 
	{
		super.update();
		
		applyGravity();
		
		if (cast(HXP.scene, MainScene).player.y == y)
			visionRange = 400;
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
	}
	
	
	private function patrol()
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
		var player:Player = cast(HXP.scene, MainScene).player;
		
		var playerPosition : Vector = new Vector(player.x, player.y);
		var thisPosition : Vector = new Vector(x, y);
		
		var thisToPlayer : Vector = playerPosition - thisPosition;
		
		var playerDirection : Direction = Direction.RIGHT;
		
		if (thisToPlayer.x < 0)
			playerDirection = Direction.LEFT;
		else if (thisToPlayer.x > 0)
			playerDirection = Direction.RIGHT;
			
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
	}
	
	
	override public function moveCollideX(e:Entity):Bool
	{
		if (e.type == "player")
		{
			GameController.enemyKillplayer(this, true);
		}
		
		super.moveCollideX(e);
		
		return true;
	}
	
	
	private function fireArm(_direction : Int)
	{
		canFireArm = false;
		canFire = false;
		armCount--;
		
		if (armCount < GB.limbToResist)
		{
			armResistance = false;
		}
		
		HXP.scene.add(new Arm(x, y, _direction, fireArmHeight, false));
		addTween(new Alarm(fireArmCooldown, function (e:Dynamic = null):Void { canFireArm = true; }, TweenType.OneShot), true);
		addTween(new Alarm(fireCooldown, function (e:Dynamic = null):Void { canFire = true; }, TweenType.OneShot), true);
	}
	
	private function fireLeg(_direction : Int)
	{
		canFireLeg = false;
		canFire = false;
		legCount--;
		
		if (legCount < GB.limbToResist)
		{
			legResistance = false;
		}
		
		HXP.scene.add(new Leg(x, y, _direction, fireLegHeight, false));
		addTween(new Alarm(fireLegCooldown, function (e:Dynamic = null):Void { canFireLeg = true; }, TweenType.OneShot), true);
		addTween(new Alarm(fireCooldown, function (e:Dynamic = null):Void { canFire = true; }, TweenType.OneShot), true);
	}
	
	public override function notifyDamage(projectileType : EnemyResistance)
	{
		if ((projectileType == EnemyResistance.ARM && !armResistance) || (projectileType == EnemyResistance.LEG && !legResistance))
		{
			life--;
			
			if (life <= 0)
				HXP.scene.remove(this);
		}
		else
		{
			trace("PAS DE DEGAT SUR CE PROJECTILE");
		}
		
		
		if (projectileType == EnemyResistance.ARM && !armResistance)
		{
			armCount++;
			
			if (armCount == GB.limbToResist)
			{
				armResistance = true;
				trace("boss resistant to arms");
			}
		}
		else if (projectileType == EnemyResistance.LEG && !legResistance)
		{
			legCount++;
			
			if (legCount == GB.limbToResist)
			{
				legResistance = true;
				trace("boss resistant to legs");
			}
		}
			
	
	}
	
	private var stateCooldown : Int;
	private var stateTimer : Float;
	
	private var legCount : Int;
	private var armCount : Int;
	
	private var canFireArm : Bool;
	private var fireArmCooldown : Float;
	private var fireArmHeight : Int;
	
	private var canFireLeg : Bool;
	private var fireLegCooldown : Float;
	private var fireLegHeight : Int;
	
	private var canFire : Bool;
	private var fireCooldown : Float;
	
	private var visionRangeDefault : Int;
	
	private var armResistance : Bool;
	private var legResistance : Bool;
}