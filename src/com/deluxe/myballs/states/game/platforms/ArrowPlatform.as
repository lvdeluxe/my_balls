/**
 * Created by lvdeluxe on 14-12-23.
 */
package com.deluxe.myballs.states.game.platforms {
import com.deluxe.myballs.states.game.obstacles.NapeArrow;

public class ArrowPlatform extends NapePlatform{

	private var _arrow:NapeArrow;

	public function ArrowPlatform(name:String, params:Object) {
		super(name, params);
		_arrow = new NapeArrow("arrow");
	}

	override public function setVisibility(pVisible:Boolean):void{
		super.setVisibility(pVisible);
		if(!_arrow.destroyed)_arrow.visible = pVisible;
		_arrow.container.visible = pVisible;
	}

	override public function prepareForDispose():void{
		super.prepareForDispose();
		_citrusState.remove(_arrow);
		_citrusState.remove(_arrow.container);
	}
	override public function prepareForRecycle():void{
		super.prepareForRecycle();
		_citrusState.add(_arrow);
		_citrusState.add(_arrow.container);
		_arrow.activate(x,y);
	}
}
}
