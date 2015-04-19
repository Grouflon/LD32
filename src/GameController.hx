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
			
		var player : Entity = HXP.scene.getInstance("player");
		if (player != null)
		{	
			if (player.x - HXP.halfWidth < 0)
				HXP.camera.x = 0;
			else if (player.x + HXP.halfWidth > HXP.width)
				HXP.camera.x = HXP.width - HXP.halfWidth;
			else
				HXP.camera.x = player.x - HXP.halfWidth;
			
			if (player.y + HXP.halfHeight > HXP.height)
				HXP.camera.y = HXP.height - HXP.halfHeight * 2;
			else if (player.y - HXP.halfHeight < 0)
				HXP.camera.y = 0;
			else	
				HXP.camera.y = player.y - HXP.halfHeight;
		}
	}
}