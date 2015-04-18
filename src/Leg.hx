package src;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import src.Limb;

/**
 * ...
 * @author ...
 */
class Leg extends Limb
{

	public function new(x:Float, y:Float, direction:Int, playerHeight:Int) 
	{
		super(x, y - (playerHeight / 3) * 1, direction);
		
		addGraphic(Image.createRect(10, 5, 0x3366FF, 1));
		
		setHitbox(10, 5); //temporary
		width 	= 10; //temporary
		height 	= 5; //temporary
	}
	
}