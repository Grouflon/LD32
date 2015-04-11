import com.haxepunk.Entity;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.sound.Fader;
import com.haxepunk.tweens.sound.SfxFader;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import sys.db.Types.SFlags;

class MainScene extends Scene
{
	public function new()
	{
		super();
	}
	
	public override function begin()
	{
		_bg = addGraphic(new Backdrop("graphics/swirl_pattern.png"));
		_ground = addGraphic(new Backdrop("graphics/ground_pattern.png", true, false));
		_ground.y = HXP.height - 137;
		var player:Player = add(new Player(HXP.width * 0.5, 100));
		
		_bg.layer = 2;
		_ground.layer = 1;
		player.layer = 0;
		
		#if flash
		var sfx:Sfx = new Sfx("audio/background.mp3");
		#else
		var sfx:Sfx = new Sfx("audio/background.ogg");
		#end
		sfx.play(1, 0, true);
		sfx.volume = 0.0;
		
		var fader:SfxFader = new SfxFader(sfx);
		fader.fadeTo(1.0, 20.0, Ease.quadInOut);
		addTween(fader, true);
	}
	
	public override function update()
	{
		var bgSpeed:Float = 40.;
		var groundSpeed:Float = 80.;
		
		if (Input.check(Key.LEFT))
		{
			_bg.moveBy(bgSpeed * HXP.elapsed, 0.);
			_ground.moveBy(groundSpeed * HXP.elapsed, 0.);
		}
		else if (Input.check(Key.RIGHT))
		{
			_bg.moveBy(-bgSpeed * HXP.elapsed, 0.);
			_ground.moveBy(-groundSpeed * HXP.elapsed, 0.);
		}
		
		super.update();
	}
	
	private	var _bg:Entity;
	private var _ground:Entity;
}