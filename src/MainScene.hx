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
		_bass = new Sfx("audio/bassline.mp3", function():Void {
			if (Input.check(Key.LEFT) || Input.check(Key.RIGHT))
			{
				_lead.play(0.2);
				_leadFader.fadeTo(0.5, 2, Ease.quadOut);
				_leadFader.start();
				/*if (!_leadFader.active)
				{
					_lead.play(0.2);
					_leadFader.fadeTo(0.5, 2, Ease.quadOut);
					_leadFader.start();
				}
				else
				{
					_lead.play(0.5);
				}*/
			}
		});
		_lead = new Sfx("audio/lead.mp3");
		#else
		var sfx:Sfx = new Sfx("audio/background.ogg");
		_bass = new Sfx("audio/bassline.ogg", function():Void {
			if (Input.check(Key.LEFT) || Input.check(Key.RIGHT))
			{
				_lead.play(0.2);
				_leadFader.fadeTo(0.5, 2, Ease.quadOut);
				_leadFader.start();
				/*if (!_leadFader.active)
				{
					_lead.play(0.2);
					_leadFader.fadeTo(0.5, 2, Ease.quadOut);
					_leadFader.start();
				}
				else
				{
					_lead.play(0.5);
				}*/
			}
		});
		_lead = new Sfx("audio/lead.ogg");
		
		#end
		sfx.play(1, 0, true);
		sfx.volume = 0.0;
		
		
		var fader:SfxFader = new SfxFader(sfx);
		fader.fadeTo(1.0, 15.0, Ease.quadInOut);
		addTween(fader, true);
		
		_bassFader = new SfxFader(_bass);
		_bassFader.active = false;
		addTween(_bassFader);
		_bass.play(0., 0, true);
		_bassFader.active = true;
		_bassFader.fadeTo(1.0, 20, Ease.quadIn);
		_bassFader.start();

		_leadFader = new SfxFader(_lead);
		addTween(_leadFader);
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
	
	private var _bass:Sfx;
	private var _lead:Sfx;
	private var _bassFader:SfxFader;
	private var _leadFader:SfxFader;
	private	var _bg:Entity;
	private var _ground:Entity;
}