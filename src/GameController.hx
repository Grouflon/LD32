import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class GameController
{

	public function new()
	{
		HXP.scene = new MainScene();
	}
	
	public function start()
	{
		HXP.scene = new MainScene();
	}
	
	public function destroy()
	{
		HXP.scene.removeAll();
	}
	
	public function isPlayerAlive():Bool
	{
		if (HXP.scene.getInstance("player") == null)
		{
			destroy();
			return false;
		}
		return true;
	}
	
	public function update():Void
	{
		if (Input.pressed(Key.P))
		{
			destroy();
			start();
		}
		
		if (!isPlayerAlive())
			start();
	}
}