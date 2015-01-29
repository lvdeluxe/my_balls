/**
 * Created by lvdeluxe on 15-01-25.
 */
package com.deluxe.myballs.states.game.platforms {
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.states.game.platforms.PlatformFactory;

public class DestructibleGroup {

	private var _platforms:Vector.<DestructiblePlatform> = new Vector.<DestructiblePlatform>();
	private var _numPlatforms:uint;
	private var _yPosition:Number;
	private var _xRandomPosition:Number;

	public function DestructibleGroup(yPos:Number) {
		_yPosition = yPos;

		var minWidthUnits:uint = 5;
		var maxWidthUnits:Number = (GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 4)) / GameConstants.TILE_SIZE;
		_numPlatforms = minWidthUnits + Math.floor(Math.random() * (maxWidthUnits - minWidthUnits)) ;

		_xRandomPosition = PlatformFactory.getXPosition(_numPlatforms * GameConstants.TILE_SIZE);

		GameSignals.DESTRUCT_PLATFORM.add(onDestructPlatform);
	}

	private function onDestructPlatform(platformIndex:uint, pGroup:DestructibleGroup):void{
		if(pGroup == this){
			for(var i:int = 0; i < _platforms.length; i++) {
				_platforms[i].updateShadow(platformIndex);
			}
		}
	}

	public function getParams():Object{
		return {y:_yPosition, randomX:_xRandomPosition, totalWidth:_numPlatforms * GameConstants.TILE_SIZE, index:_platforms.length, platformGroup:this};
	}

	public function destroyPlatforms():void{

		for(var i:int = 0; i < _platforms.length; i++) {
			_platforms[i].platformGroup = null;
			_platforms[i].kill = true;
		}
		_platforms = null;
		GameSignals.DESTRUCT_PLATFORM.remove(onDestructPlatform);
	}

	public function addPlatform(p:DestructiblePlatform):void{
		_platforms.push(p);
		p.updateShadow();
	}

	public function get numPlatforms():uint {
		return _numPlatforms;
	}
}
}
