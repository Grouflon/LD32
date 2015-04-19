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
		var level:Parsing = new Parsing("levels/layers_testlevel.oel", this);
		
		player = new Player(200, HXP.screen.height - 100);
		add(player);
		add(new PlayerGUI());
		
		levelHeight = level._height;
		levelWidth = level._width;
		
		var boss : BossEnemy = new BossEnemy(null, 75, 100, 50, 50, 50, 200, 10);
		add(boss);
	}
	
	public override function update()
	{	
		if (player != null)
		{	
			if (player.x - HXP.halfWidth < 0)
				HXP.camera.x = 0;
			else if (player.x + HXP.halfWidth > levelWidth)
				HXP.camera.x = levelWidth - HXP.width;
			else
				HXP.camera.x = player.x - HXP.halfWidth;
			
			/*if (player.y + HXP.halfHeight > levelHeight)
				HXP.camera.y = levelHeight - HXP.height;
			else if (player.y - HXP.halfHeight < 0)
				HXP.camera.y = 0;
			else	
				HXP.camera.y = player.y - HXP.halfHeight;*/
				HXP.camera.y = 0;
		}
		
		super.update();
	}
	
	
	private var player:Player;
	public var levelHeight:Int;
	public var levelWidth:Int;
}