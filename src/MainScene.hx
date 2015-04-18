import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;

class MainScene extends Scene
{
	public function new()
    {
        super();
    }
	
	public override function begin()
	{
		Parsing.createBlock();
		add(new Player(HXP.screen.width / 2, HXP.screen.height - 400));
		
		add(new Enemy(HXP.screen.width / 2 - 100, 50, 30, 50, EnemyState.PATROL, 50));
		
		add(new Enemy(HXP.screen.width / 2 + 150, 50, 30, 50, EnemyState.IDLE, 50));
	}
	
	private var player:Player;
}