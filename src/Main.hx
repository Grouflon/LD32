import com.haxepunk.Engine;
import com.haxepunk.HXP;
import GameController;

class Main extends Engine
{

	public function new()
	{
		super(990, 630);
	}
	
	override public function init()
	{
#if debug
		HXP.console.enable();
#end
		gameController = new GameController();
	}
	
	override public function update()
	{
		super.update();
		gameController.update();
	}
	
	public static function main() { new Main(); }
	private var gameController:GameController;
}