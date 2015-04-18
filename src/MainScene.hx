import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;
import Enemy;
import Parsing;

class MainScene extends Scene
{
	public function new()
    {
        super();
    }
	
	public override function begin()
	{
		add(new Player(HXP.screen.width / 2, HXP.screen.height - 200));

		Parsing.createBlock(this);
		//add(new Enemy(HXP.screen.width / 2, HXP.screen.height / 2, Image.createRect(50, 100, 0xFF0000), EnemyState.PATROL));
	}
}