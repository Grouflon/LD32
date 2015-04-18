import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;
import Enemy;
import EnemyState;
import Parsing;

class MainScene extends Scene
{
	public function new()
    {
        super();
    }
	
	public override function begin()
	{
		add(new Player(HXP.screen.width / 2, HXP.screen.height - 400));

		Parsing.createBlock(this);
		
		add(new EnemySpawner(65, 28, 2, 1));
		
		add(new EnemySpawner(200, 190, 5, 2));
	}
}