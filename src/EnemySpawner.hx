package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import Enemy;
import EnemyState;
import EnemyResistance;

/**
 * ...
 * @author Etienne
 */

class EnemySpawner extends Entity
{

	public function new(_x : Int, _y : Int, _respawnTimer : Float, _spawnNumber : Int, _enemyResistType : EnemyResistance, _enemyDamageType : DamageType)
	{
		super(_x, _y, Image.createRect(30, 60, 0xFF99FD));
		
		layer = 50;
		spawn = _spawnNumber;
		
		respawnTimer = _respawnTimer;
		effectiveTimer = 0;
		enemyResistType = _enemyResistType;
		enemyDamageType = _enemyDamageType;
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
		
		var enemyResist : EnemyResistance;
		if (enemyResistType == EnemyResistance.ARM)
		{
			enemyResist = EnemyResistance.ARM;
		}
		else if (enemyResistType == EnemyResistance.LEG)
		{
			enemyResist = EnemyResistance.LEG;
		}
		else
		{
			var randomResistance : Float = Math.random();
			
			if (randomResistance > 0.5)
				enemyResist = EnemyResistance.ARM;
			else
				enemyResist = EnemyResistance.LEG;
		}
		
		if (enemyDamageType == DamageType.BOTH)
		{
			var randomType : Float = Math.random();
			
			if (randomType > 0.5)
			{
				HXP.scene.add(new MeleeEnemy(this, x + 30 / 2, y + 50, 30, 50, 60, 150, enemyResist));
			}
			else
			{
				HXP.scene.add(new RangeEnemy(this, x + 30 / 2, y + 50, 30, 50, 75, 200, enemyResist));
			}
		}
		else if (enemyDamageType == DamageType.MELEE)
		{
			HXP.scene.add(new MeleeEnemy(this, x + 30 / 2, y + 50, 30, 50, 60, 150, enemyResist));
		}
		else if (enemyDamageType == DamageType.RANGE)
		{
			HXP.scene.add(new RangeEnemy(this, x + 30 / 2, y + 50, 30, 50, 75, 200, enemyResist));
		}
	}
	
	private var enemyDamageType : DamageType;
	private var enemyResistType : EnemyResistance;
	private var respawnTimer : Float;
	private var effectiveTimer : Float;
	private var spawn : Int;
}