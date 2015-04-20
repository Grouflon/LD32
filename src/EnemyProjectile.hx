package;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import Player;

/**
 * ...
 * @author Etienne
 */
class EnemyProjectile extends Entity
{

	public function new(_x : Float, _y : Float, _xTarget : Float, _yTarget : Float, _speed : Int, _range : Int) 
	{
		super(_x, _y);
		
		var sprite:Spritemap = new Spritemap("graphics/scalpel_spritesheet.png", 24, 24);
		sprite.add("roll", [0, 1, 2, 3, 4, 5, 6, 7], 13);
		graphic = sprite;
		sprite.play("roll");
		
		layer = 100;
		
		speed = _speed;
		range = _range;
		
		xTarget = _xTarget;
		yTarget = _yTarget;
		
		distanceDone = 0;
	}
	
	
	public override function update()
	{	
		if (distanceDone < range)
		{
			distanceDone += speed * HXP.elapsed;
			moveTowards( xTarget, yTarget, speed * HXP.elapsed, ["block", "player"], true);
		}
		else
		{
			graphic = null;
			HXP.scene.remove(this);
		}
	}
	
	override public function moveCollideX(e:Entity):Bool 
	{	
		if (e.type == "player")
		{
			cast(HXP.scene.getInstance("player"), Player).takeDamage(DamageType.RANGE);
		}
		
		graphic = null;
		HXP.scene.remove(this);
		
		return true;
	}
	
	override public function moveCollideY(e:Entity):Bool 
	{
		if (e.type == "player")
		{
			cast(HXP.scene.getInstance("player"), Player).takeDamage(DamageType.RANGE);
		}
		
		graphic = null;
		HXP.scene.remove(this);

		return true;
	}

	private var distanceDone : Float;
	private var range : Int;
	private var speed : Int;
	private var yTarget : Float;
	private var xTarget : Float;
}