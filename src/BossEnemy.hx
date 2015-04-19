package;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.math.Vector;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween;

import Arm;
import Leg;

/**
 * ...
 * @author Etienne
 */
class BossEnemy extends Enemy
{

	public function new(_owner : EnemySpawner, _xPos : Float, _yPos : Float, _width : Int, _height : Int, _speed : Int, _visionRange : Int, _life : Int) 
	{
		var _resistance : EnemyResistance = EnemyResistance.BOTH;
		
		sprite = new Spritemap("graphics/boss.png", 50, 50);
		sprite.flipped = true;
		
		sprite.originX = cast(_width * 0.5, Int);
		sprite.originY = _height;
		
		sprite.add("normal", [0]);
		
		super(_owner, _xPos, _yPos, _width, _height, _speed, _visionRange, _resistance, _life, sprite);
		
		visionRangeDefault = _visionRange;
		
		armCount = 0;
		legCount = 0;
		
		canFire = true;
		canFireArm = true;
		canFireLeg = true;
		
		fireLegCooldown = 7;
		fireArmCooldown = 5;
		fireCooldown = 3;
		
		fireArmHeight = _height;
		fireLegHeight = _height;
	}
	
	override public function update() 
	{
		super.update();
		
		applyGravity();
		
		if (HXP.scene.getInstance("player").y == y)
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
		var player : Entity = HXP.scene.getInstance("player");
		
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
					velocity.x -= speed * 2 * HXP.elapsed;
					direction = playerDirection;
				}
			}
			else if (playerDirection == Direction.RIGHT)
			{
				if (canIGoRight())
				{
					direction = playerDirection;
					velocity.x += speed * 2 * HXP.elapsed;
				}
			}
		}
		/*trace ("Arm " + armCount + "  " + canFireArm + " " + canFire);
		trace ("Leg " + legCount + "  " + canFireLeg + " " + canFire);*/
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
	
	private function fireArm(_direction : Int)
	{
		trace("arm fired");
		canFireArm = false;
		canFire = false;
		armCount--;
		HXP.scene.add(new Arm(x, y, _direction, fireArmHeight));
		addTween(new Alarm(fireArmCooldown, function (e:Dynamic = null):Void { canFireArm = true; }, TweenType.OneShot), true);
		addTween(new Alarm(fireCooldown, function (e:Dynamic = null):Void { canFire = true; }, TweenType.OneShot), true);
	}
	
	private function fireLeg(_direction : Int)
	{
		canFireLeg = false;
		canFire = false;
		legCount--;
		HXP.scene.add(new Leg(x, y, _direction, fireLegHeight));
		addTween(new Alarm(fireLegCooldown, function (e:Dynamic = null):Void { canFireLeg = true; }, TweenType.OneShot), true);
		addTween(new Alarm(fireCooldown, function (e:Dynamic = null):Void { canFire = true; }, TweenType.OneShot), true);
	}
	
	public override function notifyDamage(projectileType : EnemyResistance)
	{
		if (projectileType != resistance)
		{
			life--;
			
			if (life <= 0)
				HXP.scene.remove(this);
		}
		
		if (projectileType == EnemyResistance.ARM)
		{
			armCount++;
		}
		else if (projectileType == EnemyResistance.LEG)
		{
			legCount++;
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
}