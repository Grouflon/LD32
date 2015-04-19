import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;

class Platform extends Entity
{
	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		addGraphic(Image.createRect(32, 16, 0x8D8D8D, 1));
		setHitbox(32, 16);
		name = "platform";
		type = "platform";
		collidable = true;
	}	
}