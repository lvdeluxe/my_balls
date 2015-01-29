/**
 * Created by lvdeluxe on 14-12-23.
 */
package com.deluxe.myballs.states.game.platforms {
import citrus.core.CitrusEngine;
import citrus.core.starling.StarlingState;
import citrus.objects.platformer.nape.Platform;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.states.game.platforms.PlatformFactory;

import feathers.display.Scale3Image;
import feathers.textures.Scale3Textures;

import nape.phys.BodyType;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class NapePlatform extends Platform{

	protected var _citrusState:StarlingState = CitrusEngine.getInstance().state as StarlingState;
	protected var _shadow:DisplayObject;

	public function NapePlatform(name:String, params:Object) {
		var w:uint = getPlatformWidth();
		params.width = w;
		super(name, params);
		view = getView(w);
		group = 3;
		view.touchable = false;
	}

	protected function setShadow():void {
		var scaleTexture:Scale3Textures = new Scale3Textures(AssetsManager.getShadowTexture(), GameConstants.TILE_SIZE, GameConstants.TILE_SIZE);
		_shadow = new Scale3Image(scaleTexture);
		_shadow.width = width + (GameConstants.TILE_SIZE);
		_shadow.x -= width >> 1;
		_shadow.y -= height >> 1;
		view.parent.addChildAt(_shadow, 0);
		_shadow.touchable = false;
	}

	protected function getView(pW:uint):DisplayObject{
		return new PlatformView(pW);
	}

	public function setVisibility(pVisible:Boolean):void{
		visible = pVisible;
		if(_shadow)
			_shadow.visible = pVisible;
	}

	override protected function defineBody():void
	{
		super.defineBody();
		_bodyType = BodyType.KINEMATIC;
	}

	protected function getPlatformWidth():uint{
		var minWidthUnits:uint = 8;
		var maxWidthUnits:Number = ((GameConstants.SCREEN_WIDTH / 2) + (GameConstants.TILE_SIZE * 4)) / GameConstants.TILE_SIZE;
		var randomUnits:uint = minWidthUnits + Math.floor(Math.random() * (maxWidthUnits - minWidthUnits)) ;
		return randomUnits * GameConstants.TILE_SIZE;
	}

	public function prepareForDispose():void{
		if(_shadow && _shadow.parent)
			_shadow.parent.removeChild(_shadow);
	}

	protected function getXPosition():uint{
		return PlatformFactory.getXPosition(width);
	}

	public function prepareForRecycle():void{
		x = getXPosition();
		setShadow();
	}
}
}
