package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import Enemy;
import EnemyState;


/**
 * ...
 * @author Etienne
 */

class EnemySpawner extends Entity
{

	public function new(_x : Int, _y : Int, _respawnTimer : Float, _spawnNumber : Int)
	{
		super(_x, _y, Image.createRect(32, 64, 0xFF99FD));
		
		layer = 50;
		spawn = _spawnNumber;
		
		respawnTimer = _respawnTimer;
		effectiveTimer = 0;
	}
	
	public override function update()
	{
		if (spawn > 0)
		{
			if (effectiveTimer > 0)
			{
				effectiveTimer -= HXP.elapsed;
			}
			else
			{
				spawnMob();
				effectiveTimer = respawnTimer;
			}
		}
		
		super.update();
	}
	
	public function notifyEnemyDeath()
	{
		effectiveTimer = respawnTimer;
		spawn += 1;
	}
	
	private function spawnMob()
	{
		spawn -= 1;
		
		var random : Float = Math.random();
		if (random > 0.5)
			HXP.scene.add(new MeleeEnemy(this, x + 30 / 2, y + 50, 30, 50, 60, 50));
		else
			HXP.scene.add(new RangeEnemy(this, x + 30 / 2, y + 50, 30, 50, 75, 200));
		
	}
	
	private var respawnTimer : Float;
	private var effectiveTimer : Float;
	private var spawn : Int;
}