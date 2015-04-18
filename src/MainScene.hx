import com.haxepunk.Scene;

class MainScene extends Scene
{
	public override function begin()
	{
		add<Player> (new Player(0, 0));
	}
}