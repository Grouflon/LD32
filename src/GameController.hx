import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class GameController
{

	public function new()
	{
		HXP.scene = new MenuScene();
	}

	static public function startGame():Void
	{
		_inGame = true;
		HXP.scene.removeAll();
		HXP.scene = new MainScene();
	}
	
	static public function clean()
	{
		HXP.scene.removeAll();
	}
	
	public function isPlayerAlive():Bool
	{
		if (HXP.scene.getInstance("player") == null)
		{
			return false;
		}
		return true;
	}
	
	public function update():Void
	{
		if (Input.pressed(Key.P))
		{
			clean();
			startGame();
		}
		
		if (!isPlayerAlive() && _inGame)
		{
			startGame();
		}
	}
	
	static private var _inGame:Bool = false;
}