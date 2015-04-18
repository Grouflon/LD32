import com.haxepunk.HXP;

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
	
	public function isPlayer():Bool
	{
		if (HXP.scene.getInstance("player") == null)
		{
			destroy();
			return false;
		}
		return true;
	}
}