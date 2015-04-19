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
<<<<<<< HEAD
=======
		
		add(new LegAmmunition(300, HXP.screen.height - 130));
		add(new LegAmmunition(320, HXP.screen.height - 130));
		
		add(new ArmAmmunition(340, HXP.screen.height - 130));
		add(new ArmAmmunition(360, HXP.screen.height - 130));
>>>>>>> a7443da2195e24ebfa389aed7649ad9cb79e5e07

		levelHeight = level._height;
		levelWidth = level._width;
		
		var boss : BossEnemy = new BossEnemy(null, 100, HXP.height - 100, 50, 50, 50, 200, 10);
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
				
			HXP.camera.y = 0;
		}
		
		super.update();
	}

	public var player:Player;
	public var levelHeight:Int;
	public var levelWidth:Int;
}