import com.haxepunk.Engine;
import com.haxepunk.HXP;
import GameController;

class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end
		gameController = new GameController();
	}
	
	override public function update()
	{
		gameController.update();
		super.update();
	}
	
	public static function main() { new Main(); }
	private var gameController:GameController;
}