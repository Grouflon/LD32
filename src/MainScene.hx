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
		var level:Parsing = new Parsing();
		
		player = new Player(100, HXP.screen.height - 400);
		add(player);
		add(new PlayerGUI());
		
		levelHeight = level._height;
		levelWidth = level._width;
	}
	
	public override function update()
	{	
		if (player != null)
		{	
			trace("player x : " + player.x + " y : " + player.y);

			if (player.x - HXP.halfWidth < 0)
				HXP.camera.x = 0;
			else if (player.x + HXP.halfWidth > levelWidth)
				HXP.camera.x = levelWidth - HXP.width;
			else
				HXP.camera.x = player.x - HXP.halfWidth;
			
			if (player.y + HXP.halfHeight > levelHeight)
				HXP.camera.y = levelHeight - HXP.height;
			else if (player.y - HXP.halfHeight < 0)
				HXP.camera.y = 0;
			else	
				HXP.camera.y = player.y - HXP.halfHeight;
		}
		
		super.update();
	}
	
	private var player:Player;
	public var levelHeight:Int;
	public var levelWidth:Int;
}