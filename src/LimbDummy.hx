package;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.ColorTween;
import com.haxepunk.utils.Ease;

import hxmath.math.Vector2;

import EnemyResistance;

/**
 * ...
 * @author ...
 */
class LimbDummy extends Entity
{

	public function new(x:Float, y:Float, limbType:String) 
	{
		super(x, y - 60);
		
		if (limbType == "leg") { _sprite = new Spritemap("graphics/leg.png", 30, 30); addGraphic(_sprite); }
		else if (limbType == "arm") { var armImage:Image = new Image("graphics/arm.png"); addGraphic(armImage); }
		
		
		_colorTween = new ColorTween(function (e:Dynamic) { HXP.world.remove(this); }, TweenType.OneShot);
		_colorTween.tween(0.5, 1, 1, 1., 0., Ease.quadOut);
		addTween(_colorTween, true);
		
		var direction:Float = Math.random();
		if (direction <= 0.5)
		{
			direction = -1.;
		}
		else
		{
			direction = 1.;
		}
		
		_velocity = new Vector2(3. * direction, -3.);
	}
	
	
	override public function update():Void
	{
		cast(graphic, Image).alpha = _colorTween.alpha;
		moveBy(_velocity.x, _velocity.y);
	}
	
	private var _velocity:Vector2;
	private var _colorTween:ColorTween;
	private var _sprite:Spritemap;
}