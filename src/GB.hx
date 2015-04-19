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
	
	// PLAYER RELATED
	static public var playerReach:Float = 9.5;
	static public var playerSpeed:Float	= 4.;
	
	// LIMBS RELATED
	static public var legBounceAttenuation = 0.8;
	
	// GAME RELATED
	static public var gravity:Vector2 	= new Vector2(0., 20.);
	
}