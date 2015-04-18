import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import Enemy;

class MainScene extends Scene
{
	public function new()
    {
        super();
    }
	
	public override function begin()
	{
		
		var i:Int = 0;
		var u:Int = 0;
		
		while (i < 632)
		{
			add(new SolidBlock(i, 400));
			i += 32;
		}
		
		while (u < 400)
		{
			add(new SolidBlock(0, u));
			add(new SolidBlock(600, u));
			u += 32;
		}
		
		//add(new Enemy(HXP.screen.width / 2, HXP.screen.height / 2, Image.createRect(50, 100, 0xFF0000), EnemyState.PATROL));
		
	}
}