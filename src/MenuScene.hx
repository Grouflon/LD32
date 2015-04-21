package;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.misc.ColorTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Tween.TweenType;

import MainScene;
import GameController;

/**
 * ...
 * @author ...
 */
class MenuScene extends Scene
{

	public function new() 
	{
		super();
	}
	
	
	override public function begin()
	{
		_image = new Image("graphics/splash_screen.png");
		_image.alpha = 0.0;
		addGraphic(_image);
		
		_fadeTween = new ColorTween(function(e:Dynamic):Void { }, TweenType.Persist);
		_fadeTween.tween(2.0, 0x000000, 0x000000, _image.alpha, 1, Ease.quadOut);
		addTween(_fadeTween, true);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		_image.alpha = _fadeTween.alpha;
		
		if (Input.pressed(Key.ENTER))
		{
			_fadeTween.cancel();
			_fadeTween = new ColorTween(function(e:Dynamic):Void { _action(); }, TweenType.Persist);
			_fadeTween.tween(1.5, 0x000000, 0x000000, _image.alpha, 0.0, Ease.quadOut);
			addTween(_fadeTween, true);
		}
	}
	
	
	private function _action():Void
	{
		
		GameController.clean();
		GameController.startGame("levels/level_1.oel");
	}
	
	private var _image:Image;
	private var _fadeTween:ColorTween;
	
}