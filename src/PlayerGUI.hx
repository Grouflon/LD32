package;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Text;

import Player;
import MainScene;

/**
 * ...
 * @author ...
 */
class PlayerGUI extends Entity
{

	public function new()
	{	
		super();
		
		layer = 0;
		
		_playerArms = new Text("Arms : " + cast(HXP.scene, MainScene).player.getArmCount());
		_playerArms.size = 20;
		_playerLegs = new Text("Legs : " + cast(HXP.scene, MainScene).player.getLegCount(), 0., 25.);
		_playerLegs.size = 20;
		
		addGraphic(_playerArms);
		addGraphic(_playerLegs);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		_playerArmCount = cast(HXP.scene, MainScene).player.getArmCount();
		//cast(HXP.scene.getInstance("player"), Player).getArmCount();
		_playerLegCount = cast(HXP.scene, MainScene).player.getLegCount();
		//cast(HXP.scene.getInstance("player"), Player).getLegCount();
		
		_displayStats();
	}
	
	
	private function _displayStats()
	{
		switch _playerArmCount
		{
			case 0:
			{
				_playerArms.richText = "Arms : 0";
			}
			case 1:
			{
				_playerArms.richText = "Arms : 1";
			}
			case 2:
			{
				_playerArms.richText = "Arms : 2";
			}
		}
		
		switch _playerLegCount
		{
			case 0:
			{
				_playerLegs.richText = "Legs : 0";
			}
			case 1:
			{
				_playerLegs.richText = "Legs : 1";
			}
			case 2:
			{
				_playerLegs.richText = "Legs : 2";
			}
		}
	}
	
	private var _playerArms:Text;
	private var _playerLegs:Text;
	
	private var _playerArmCount:Int = 0;
	private var _playerLegCount:Int = 0;
}