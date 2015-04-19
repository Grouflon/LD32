import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;
import PlayerGUI;

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
		add(new PlayerGUI());

	}
	
	private var player:Player;
}