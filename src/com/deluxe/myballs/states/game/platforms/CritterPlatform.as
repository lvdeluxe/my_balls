/**
 * Created by lvdeluxe on 14-12-23.
 */
package com.deluxe.myballs.states.game.platforms {
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.states.game.obstacles.NapeCritter;

public class CritterPlatform extends NapePlatform{

	private var _critter:NapeCritter;

	public function CritterPlatform(name:String, params:Object) {
		super(name, params);
		_critter = new NapeCritter("critter");
	}

	override public function prepareForDispose():void{
		super.prepareForDispose();
		_citrusState.remove(_critter);
	}

	override public function setVisibility(pVisible:Boolean):void{
		super.setVisibility(pVisible);
		if(!_critter.destroyed)_critter.visible = pVisible;
	}

	override public function prepareForRecycle():void{
		super.prepareForRecycle();
		_citrusState.add(_critter);
		_critter.activate();
		_critter.x = x;
		_critter.y = y - 40;
		_critter.rightBound = x + (width / 2) - GameConstants.TILE_SIZE;
		_critter.leftBound = x - (width / 2) + GameConstants.TILE_SIZE;
	}
}
}
