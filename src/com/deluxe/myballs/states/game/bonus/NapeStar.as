/**
 * Created by lvdeluxe on 15-01-13.
 */
package com.deluxe.myballs.states.game.bonus {
import citrus.objects.platformer.nape.Coin;
import citrus.physics.nape.NapeUtils;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.states.game.BallBody;

import nape.callbacks.InteractionCallback;
import nape.phys.BodyType;

import starling.display.BlendMode;
import starling.display.Image;
import starling.textures.TextureSmoothing;

public class NapeStar extends Coin{

	private var _collected:Boolean = false;

	public function NapeStar(name:String, params:Object = null) {
		super(name, params);
		collectorClass = BallBody;
		view = new Image(AssetsManager.getStarTexture());
		group = 5;
		beginContactCallEnabled = true;
		view.touchable = false;
		view.smoothing = TextureSmoothing.NONE;
	}

	override protected function defineBody():void {
		_bodyType = BodyType.KINEMATIC;
	}

	private function collect():void{
		_collected = true;
		visible = false;
		if(body)
			body.space = null;
	}

	override public function handleBeginContact(interactionCallback:InteractionCallback):void {
		if (_collectorClass && NapeUtils.CollisionGetOther(this, interactionCallback) is _collectorClass){
			collect();
			GameSignals.COLLECT_STAR.dispatch(1);
		}
	}

	public function activate():void{
		visible = true;
		_collected = false;
		kill = false;
		if(body)
			body.space = _nape.space;
	}

	public function get collected():Boolean {
		return _collected;
	}
}
}
