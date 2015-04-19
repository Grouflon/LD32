import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;

import PlayerGUI;
import LegAmmunition;
import ArmAmmunition;

class MainScene extends Scene
{
	public function new()
    {
        super();
    }
	
	public override function begin()
	{
		Parsing.createBlock();
		player = new Player(100, HXP.screen.height - 400);
		add(player);
		add(new PlayerGUI());
		
		add(new LegAmmunition(50, HXP.screen.height - 200));
		add(new LegAmmunition(50, HXP.screen.height - 70));
		
		add(new ArmAmmunition(500, HXP.screen.height - 149));
		add(new ArmAmmunition(600, HXP.screen.height - 79));
	}
	
	public var player:Player;
}