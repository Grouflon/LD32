import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;

import PlayerGUI;
import LegAmmunition;
import ArmAmmunition;
import Parsing;

class MainScene extends Scene
{
	public function new(file:String)
    {
        super();
		levelName = file;
    }
	
	public override function begin()
	{
		var level:Parsing = new Parsing(levelName, this);
		
		player = level._player;
		add(new PlayerGUI());

		levelHeight = level._height;
		levelWidth = level._width;
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
				
			HXP.camera.y = 0;
		}
		
		super.update();
	}
	private var levelName:String;
	public var player:Player;
	public var levelHeight:Int;
	public var levelWidth:Int;
}