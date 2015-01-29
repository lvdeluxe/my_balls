/**
 * Created by lvdeluxe on 14-12-23.
 */
package com.deluxe.myballs.states.game {
import com.deluxe.myballs.*;

import citrus.objects.NapePhysicsObject;

import nape.phys.BodyType;

import starling.display.BlendMode;
import starling.display.Image;
import starling.extensions.krecha.ScrollImage;
import starling.extensions.krecha.ScrollTile;
import starling.textures.TextureSmoothing;

public class NapeWall extends NapePhysicsObject{

	private var _scrollImage:ScrollImage;

	public function NapeWall(name:String, params:Object) {
		super(name, params);
		_scrollImage = new ScrollImage(GameConstants.TILE_SIZE, GameConstants.SCREEN_HEIGHT);
		_scrollImage.blendMode = BlendMode.NONE;
		_scrollImage.smoothing = TextureSmoothing.NONE;
		_scrollImage.mipMapping = false;
		_scrollImage.pivotX = GameConstants.TILE_SIZE >> 1;
		_scrollImage.pivotY = GameConstants.SCREEN_HEIGHT >> 1;
		_scrollImage.addLayer(new ScrollTile(AssetsManager.getWallTexture()));
		view = _scrollImage;
		group = 6;
		view.touchable = false;
	}

	public function offset(pOffsetValue:Number):void{
		y += pOffsetValue;
		_scrollImage.tilesOffsetY -= pOffsetValue;
	}

	override protected function defineBody():void {
		_bodyType = BodyType.KINEMATIC;
	}
}
}
