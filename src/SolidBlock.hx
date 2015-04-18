import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;

class SolidBlock extends Entity
{
	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		addGraphic(Image.createRect(32, 32, 0xFFFFFF, 1));
		setHitbox(32, 32);
		name = "block";
		type = "block";
		collidable = true;
	}
}