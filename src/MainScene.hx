import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;

import Enemy;

class MainScene extends Scene
{
	public override function begin()
	{
		add(new Enemy(HXP.screen.width / 2, HXP.screen.height / 2, Image.createRect(50,100, 0xFF0000)));
	}
}