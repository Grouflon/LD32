import com.haxepunk.HXP;
import com.haxepunk.Scene;

class MainScene extends Scene
{
	public override function begin()
	{
		add(new Player(HXP.screen.width / 2, HXP.screen.height - 100));
	}
}