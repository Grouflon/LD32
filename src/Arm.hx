package src;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import src.Limb;

/**
 * ...
 * @author ...
 */
class Arm extends Limb
{

	public function new(x:Float, y:Float, direction:Int) 
	{
		super(x, y + 10, direction);
		
		addGraphic(Image.createRect(7, 4, 0x3366FF, 1));
		
		setHitbox(7, 4); //temporary
		width 	= 7; //temporary
		height 	= 4; //temporary
	}
	
}