import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;
import PlayerGUI;
import Parsing;

class MainScene extends Scene
{
	public function new()
    {
        super();
    }
	
	public override function begin()
	{
		var level:Parsing = new Parsing();
		add(new Player(100, HXP.screen.height - 400));
		add(new PlayerGUI());

	}
	
	private var player:Player;
}