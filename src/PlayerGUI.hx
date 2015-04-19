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
		
		var player:Player = cast(HXP.scene, MainScene).player;
		
		_playerArms = new Text("Arms : " + player.getArmCount() + "/" + player.getMaxArmCount());
		_playerArms.size = 20;
		_playerLegs = new Text("Legs : " + player.getLegCount() + "/" + player.getMaxLegCount(), 0., 25.);
		_playerLegs.size = 20;
		
		_playerArms.scrollX = 0;
		_playerLegs.scrollX = 0;
		
		addGraphic(_playerArms);
		addGraphic(_playerLegs);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		_playerArmCount = cast(HXP.scene, MainScene).player.getArmCount();
		
		_playerLegCount = cast(HXP.scene, MainScene).player.getLegCount();
		
		_displayStats();
	}
	
	
	private function _displayStats()
	{
		var player:Player = cast(HXP.scene, MainScene).player;
		
		switch _playerArmCount
		{
			case 0:
			{
				_playerArms.richText = "Arms : 0/" + player.getMaxArmCount();
			}
			case 1:
			{
				_playerArms.richText = "Arms : 1/" + player.getMaxArmCount();
			}
			case 2:
			{
				_playerArms.richText = "Arms : 2/" + player.getMaxArmCount();
			}
		}
		
		switch _playerLegCount
		{
			case 0:
			{
				_playerLegs.richText = "Legs : 0/" + player.getMaxLegCount();
			}
			case 1:
			{
				_playerLegs.richText = "Legs : 1/" + player.getMaxLegCount();
			}
			case 2:
			{
				_playerLegs.richText = "Legs : 2/" + player.getMaxLegCount();
			}
		}
	}
	
	private var _playerArms:Text;
	private var _playerLegs:Text;
	
	private var _playerArmCount:Int = 0;
	private var _playerLegCount:Int = 0;
}