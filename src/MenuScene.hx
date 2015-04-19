package;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

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
		_cursor = Image.createRect(5, 5, 0xFF0000, 1);
		addGraphic(_cursor, 0, HXP.halfWidth - 60, 0);
		
		_addButton("Play");
		
		_currentButton = 1;
	}
	
	
	override public function update():Void
	{
		super.update();
		
		if (Input.pressed(Key.ENTER))
		{
			_action(_currentButton);
		}
		
		if (Input.pressed(Key.UP))
		{
			_upPressed = true;
		}
		else if (Input.released(Key.UP))
		{
			_upPressed = false;
		}
		
		if (Input.pressed(Key.DOWN))
		{
			_downPressed = true;
		}
		else if (Input.released(Key.DOWN))
		{
			_downPressed = false;
		}
		
		_updateCursor();
	}
	
	
	private function _action(index:Int):Void
	{
		trace("executing an action");
		
		switch index
		{
			case 1:
			{
				trace("Play request");
				GameController.clean();
				GameController.startGame();
			}
		}
	}
	
	
	private function _updateCursor():Void
	{
		if (_upPressed && _currentButton > 1)
		{
			trace("removing to current button");
			_currentButton--;
		}
		else if (_downPressed && _currentButton < _buttonCount)
		{
			trace("adding to current button");
			_currentButton++;
		}
		
		_upPressed 		= false;
		_downPressed 	= false;
		
		//trace(_currentButton);
		
		_cursor.y = 100 * _currentButton + 5;
	}
	
	
	private function _addButton(text:String):Void
	{
		++_buttonCount;
		addGraphic(new Text(text, HXP.screen.width / 2 - 50, _buttonCount * 100));
	}
	
	
	private var _cursor:Image;
	
	private var _upPressed:Bool 	= false;
	private var _downPressed:Bool 	= false;
	
	private var _buttonCount:Int = 0;
	private var _currentButton:Int = 0;
	
}