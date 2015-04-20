package;

import hxmath.math.Vector2;

/**
 * ...
 * @author ...
 */
class GB
{

	public function new()
	{	
	}
	
	// PLAYER
	//               jump
	static public var playerTallReach:Float 	= 12;
	static public var playerShortReach:Float	= 10;
	
	//               speed
	static public var playerSpeed:Float			= 4.;
	static public var playerLeglessSpeed:Float 	= 0.;
	
	//               shake 
	static public var playerTouchesGroundShakeIntensity = 2;
	static public var playerTouchesGroundShakeDuration = 0.2;
	
	// LIMBS
	static public var legBounceAttenuation:Float 	= 0.8;
	static public var maxBounceAmount:Int 			= 3;
	
	// GAME
	static public var gravity:Vector2 	= new Vector2(0., 0.5);
	
	// MELEE ENEMY 
	static public var meleeSpeed = 60;
	static public var meleeVisionRange = 150;
	static public var meleeSameYVisionRange = 400;
	static public var meleeChargeSpeed = 120;
	
	// RANGE ENEMY
	static public var rangeSpeed = 75;
	static public var rangeVisionRange = 200;
	static public var rangeEnemyProjectileSpeed = 200;
	static public var rangeEnemyProjectileRange = 400;
	static public var rangeAttackCooldown = 1;
	static public var rangeStateChangeCooldown = 3;
	
	// BOSS
	static public var bossLife = 6;
	static public var bossSpeed = 100;
	static public var bossInitialLegCooldown = 5;
	
	
	/*static public var limbToResist = 3;	
	static public var initialBossArm = 0;
	static public var initialBossLeg = 0;
	
	static public var bossFireLegCooldown = 6;
	static public var bossFireArmCooldown = 5;
	static public var bossFireCooldown = 4;*/
	
}