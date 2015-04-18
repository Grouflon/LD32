package;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Screen;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.math.Vector;
/**
 * Enemy class
 * 
 * @author Etienne
 */

class Enemy extends Entity
{

	public function new(x : Float, y : Float, img : Graphic) 
	{
		super(x, y, img);
	
		setHitbox(50, 100);
		
        velocity = new Vector(0,0);
		
		collidable = true;
		
		speed = 50;
		
		playerSpotted = false;
		xDirection = 1;
	}
	
	public override function update()
	{
		// Condition de mise à jour de playerSpotted
		
		// Si le joueur n'est pas vu, on patrouille
		if (!playerSpotted)
		{
			
			// Si la direction actuelle est la gauche
			if (xDirection == -1)
			{
				// Puis-je aller encore à gauche ?
				if (canIGoLeft())
				{
					velocity.x -= speed * HXP.elapsed;
				}
				// Sinon, puis-je aller à droite ?
				else if (canIGoRight())
				{
					xDirection = 1;
					velocity.x += speed * HXP.elapsed;
				}
			}
			// Si la direction actuelle est la droite
			else if (xDirection == 1)
			{
				// Puis-je aller encore à droite ?
				if (canIGoRight())
				{
					velocity.x += speed * HXP.elapsed;
				}
				// Sinon, puis-je aller à droite ?
				else if (canIGoLeft())
				{
					xDirection = -1;
					velocity.x -= speed * HXP.elapsed;
				}
			}
		}
		// Le joueur est repéré
		else
		{
				velocity = new Vector(0, 0);
		}
		
		set_x(x + velocity.x);
		set_y(y + velocity.y);
		
		velocity = new Vector(0, 0);
	}
	
	private function canIGoLeft() : Bool
	{
		if (x < 50)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	private function canIGoRight() : Bool
	{
		if (x > HXP.screen.width - 50 - width)
			return false;
		else
			return true;
	}
	
	private var speed:Float;
	private var velocity:Vector;
	private var xDirection:Float;
	private var playerSpotted:Bool;
	
}