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
	static public var playerTallReach:Float 	= 9.5;
	static public var playerShortReach:Float	= 7;
	
	static public var playerSpeed:Float			= 4.;
	static public var playerLeglessSpeed:Float 	= 0.;
	
	// LIMBS
	static public var legBounceAttenuation:Float 	= 0.8;
	static public var maxBounceAmount:Int 			= 3;
	
	// GAME
	static public var gravity:Vector2 	= new Vector2(0., 20.);
		
	// MELEE ENEMY 
	static public var meleeSpeed = 60;
	static public var meleeVisionRange = 150;
	
	// RANGE ENEMY
	static public var rangeSpeed = 75;
	static public var rangeVisionRange = 200;
	static public var rangeEnemyProjectileSpeed = 200;
	static public var rangeEnemyProjectileRange = 400;
	
	// BOSS
	static public var limbToResist = 3;	
	static public var initialBossArm = 0;
	static public var initialBossLeg = 0;
	
	static public var bossFireLegCooldown = 6;
	static public var bossFireArmCooldown = 5;
	static public var bossFireCooldown = 4;
	
}