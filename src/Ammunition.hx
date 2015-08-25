package;

import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import Player;

/**
 * ...
 * @author ...
 */
class Ammunition extends Entity
{

	public function new(x:Float, y:Float, width:Int, height:Int) 
	{
		super(x, y);
		collidable = true;
		setHitbox(width, height, 0, 0);
		_used = false;
	}

	
	override public function update():Void
	{
		if (!_used)
		{
			var collisioner = collideWith(cast(cast(HXP.scene, MainScene).player, Player), x, y);
			
			if (cast(HXP.scene, MainScene).player == collisioner)
			{
				addLimb(collisioner);
			}
		}
	}
	
	
	public function addLimb(p:Player):Void
	{
		_used = true;
		this.visible = false;
		_displayText.visible = true;
		
		this.addTween(new Alarm(2., function (e:Dynamic) {
			_displayText.visible = false;
			HXP.world.remove(this);
		}, TweenType.OneShot), true);
	}
	
	private var _used:Bool;
	private var _displayText:Text;
}