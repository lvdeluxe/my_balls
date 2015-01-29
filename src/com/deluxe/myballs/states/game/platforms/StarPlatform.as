/**
 * Created by lvdeluxe on 15-01-13.
 */
package com.deluxe.myballs.states.game.platforms {
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.states.game.bonus.NapeStar;

public class StarPlatform extends NapePlatform{

	private var _stars:Vector.<NapeStar> = new Vector.<NapeStar>();

	public function StarPlatform(name:String, params:Object) {
		super(name, params);
	}

	private function setStars():void {
		for(var i:uint = 0 ; i < (width / GameConstants.TILE_SIZE) - 2 ; i++){
			var star:NapeStar = new NapeStar("star");
			_stars.push(star);
		}
	}

	override public function setVisibility(pVisible:Boolean):void{
		super.setVisibility(pVisible);
		for(var i:uint = 0 ; i < _stars.length ; i++){
			if(!_stars[i].collected)_stars[i].visible = pVisible;
		}
	}

	override public function prepareForDispose():void{
		super.prepareForDispose();
		for(var i:uint = 0 ; i < _stars.length ; i++){
			_citrusState.remove(_stars[i]);
		}
	}

	override public function prepareForRecycle():void{
		super.prepareForRecycle();
		if(_stars.length == 0)
			setStars();
		var xPos:uint = x - (GameConstants.TILE_SIZE * (Math.floor(((width / GameConstants.TILE_SIZE) - 2) / 2)));
		if(width / GameConstants.TILE_SIZE % 2 == 0)
			xPos += (GameConstants.TILE_SIZE / 2);
		for(var i:uint = 0 ; i < _stars.length ; i++){
			_stars[i].activate();
			_stars[i].x = xPos;
			_stars[i].y = y - GameConstants.TILE_SIZE;
			xPos += GameConstants.TILE_SIZE;
			_citrusState.add(_stars[i]);
		}
	}
}
}
