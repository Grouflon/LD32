package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.utils.Data;
import com.haxepunk.utils.Draw;
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
		super(_x, _y);
		
		_sprite = new Spritemap("graphics/door_spritesheet.png", 60, 90);
		_sprite.add("idle", [0]);
		_sprite.add("ready", [1]);
		_sprite.add("opened", [2]);
		_sprite.play("idle");
		addGraphic(_sprite);
		
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
				if (effectiveTimer < 3)
					{
						_sprite.play("ready");
					}
			}
			else
			{
				_sprite.play("opened");
				addTween(new Alarm(1.0, function(e:Dynamic = null):Void { _sprite.play("idle"); },  TweenType.OneShot), true);
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
				HXP.scene.add(new MeleeEnemy(this, x + 30 / 2, y + 50, GB.meleeSpeed, GB.meleeVisionRange, 1, enemyResist));
			}
			else
			{
				HXP.scene.add(new RangeEnemy(this, x + 30 / 2, y + 50, GB.rangeSpeed, GB.rangeVisionRange, 1, enemyResist));
			}
		}
		else if (enemyDamageType == DamageType.MELEE)
		{
			HXP.scene.add(new MeleeEnemy(this, x + 30 / 2, y + 50, GB.meleeSpeed, GB.meleeVisionRange, 1, enemyResist));
		}
		else if (enemyDamageType == DamageType.RANGE)
		{
			HXP.scene.add(new RangeEnemy(this, x + 30 / 2, y + 50, GB.rangeSpeed, GB.rangeVisionRange, 1, enemyResist));
		}
	}
	
	private var _sprite:Spritemap;
	private var enemyDamageType : DamageType;
	private var enemyResistType : EnemyResistance;
	private var respawnTimer : Float;
	private var effectiveTimer : Float;
	private var spawn : Int;
}