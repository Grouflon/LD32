import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.Tween;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import Player;

class GameController
{

	public function new()
	{
		HXP.scene = new MenuScene();
	}

	
	static public function startGame(file:String):Void
	{
		if (!_inGame) _inGame = true;
		HXP.scene.removeAll();
		HXP.scene = new MainScene(file);
		
		_levelName = file;
		_isPlayerAlive = true;
	}
	
	
	static public function winGame():Void
	{
		cast(HXP.scene, MainScene).addGraphic(new Text("CONGRATULATIONS, YOU WON !!!", HXP.halfWidth - 200, HXP.halfHeight, 100, 15));
		HXP.scene.addTween(new Alarm(5, function (e:Dynamic) {
			HXP.scene = new MenuScene();
		}, TweenType.OneShot), true);
	}
	
	
	static public function clean()
	{
		HXP.scene.removeAll();
	}
	
	static public function enemyKillplayer(e:Entity, boss:Bool = false) : Void
	{
		var player : Player = cast(HXP.scene.getInstance("player"), Player);
		player.diePlayerDie();
		
		if (e.type == "player")
		{
			HXP.scene.addGraphic(new Text("You are so bad ! You died !", e.x - 60, e.y - 80, 0, 0));
		}
		else if (e.type == "enemy")
		{
			if (boss)
			{
				HXP.scene.addGraphic(new Text("DIEEEEEEEEE HUMANNNNN ", e.x - 100, e.y - 175, 0, 0));
			}
			else
			{
				HXP.scene.addGraphic(new Text("I'll have you know that I just killed you.", e.x - 140, e.y - 80, 0, 0));
			}
		}
	}
	
	static public function playerJustDied():Void
	{
		var player : Entity = HXP.scene.getInstance("player");
		
		trace("Player about to be removed");
		
		HXP.scene.remove(player);
		_isPlayerAlive = false;
		

		HXP.scene.addTween(new Alarm(2., function (e:Dynamic) {
			startGame(_levelName);
		 }, TweenType.OneShot), true);
	}
	
	static public function isPlayerAlive():Bool
	{
		if (_isPlayerAlive == false)
		{
			return false;
		}
		return true;
	}
	
	public function update():Void
	{
		if (Input.pressed(Key.P))
		{
			clean();
			startGame(_levelName);
		}
	}
	
	static public function switchLevel(file:String):Void
	{
		startGame(file);
	}
	
	static private var _levelName:String;
	static private var _isPlayerAlive:Bool;
	static private var _inGame:Bool = false;
}