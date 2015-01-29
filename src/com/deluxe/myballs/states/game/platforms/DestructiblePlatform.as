/**
 * Created by lvdeluxe on 14-12-23.
 */
package com.deluxe.myballs.states.game.platforms {
import aze.motion.eaze;

import citrus.objects.NapePhysicsObject;
import citrus.physics.nape.NapeUtils;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.states.game.BallBody;

import feathers.display.Scale3Image;
import feathers.textures.Scale3Textures;

import flash.geom.Rectangle;

import nape.callbacks.InteractionCallback;
import nape.phys.BodyType;

import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureSmoothing;

public class DestructiblePlatform extends NapePlatform{

	private var _destruct:Boolean = false;
	private var _destructed:Boolean = false;
	private var _positionOffset:uint = 4;
	private var _posX:Number;
	private var _posY:Number;
	private var _destructTime:Number = 1;
	private var _elapsed:Number = 0;

	public var index:uint;
	public var totalWidth:uint;
	public var randomX:Number;
	public var platformGroup:DestructibleGroup;

	public function DestructiblePlatform(name:String, params:Object) {
		super(name, params);
		beginContactCallEnabled = true;
		updateCallEnabled = true;
		group = 50;
	}

	override public function handleBeginContact(callback:InteractionCallback):void {
		var collider:NapePhysicsObject = NapeUtils.CollisionGetOther(this, callback);
		if (collider is BallBody){
			_destruct = true;
		}
	}

	override protected function getView(pW:uint):DisplayObject{
		var img:Image = new Image(AssetsManager.getDestructiblePlatformTexture());
//		img.blendMode = BlendMode.NONE;
		//img.smoothing = TextureSmoothing.NONE;
		return img;
	}

	override protected function defineBody():void {
		_bodyType = BodyType.KINEMATIC;
	}

	override public function update(timeDelta:Number):void{
		super.update(timeDelta);
		if(_destruct){
			if(_elapsed < _destructTime){
				x = _posX + Math.floor(Math.random() * _positionOffset);
				y = _posY + Math.floor(Math.random() * _positionOffset);
				_elapsed += timeDelta;
			}else{
				if(!_destructed){
					_destructed = true;
					body.space = null;
					x = _posX;
					y = _posY;
					GameSignals.DESTRUCT_PLATFORM.dispatch(index, platformGroup);
					eaze(view).to(0.5,{alpha:0, y:100});
					eaze(_shadow).to(0.5,{alpha:0, y:100});
				}
			}
		}
	}

	public function updateShadow(pIndex:int = -1):void{
		if(index == pIndex -1 || pIndex == index){
			var shadow2:Image = new Image(AssetsManager.getShadowDestructEndTexture());
			shadow2.x = GameConstants.TILE_SIZE;
			Sprite(_shadow).addChild(shadow2);
		}
	}

	override protected function setShadow():void {
		_shadow = new Sprite();
		Sprite(_shadow).addChild(new Image(AssetsManager.getShadowDestructTexture()));

		if(index == (totalWidth / GameConstants.TILE_SIZE) - 1){
			var shadow2:Image = new Image(AssetsManager.getShadowDestructEndTexture());
			shadow2.x = GameConstants.TILE_SIZE;
			Sprite(_shadow).addChild(shadow2);
		}

		_shadow.x -= width >> 1;
		_shadow.y -= height >> 1;
		view.parent.addChildAt(_shadow, 0);
		_shadow.touchable = false;

	}

	override public function prepareForRecycle():void{
		super.prepareForRecycle();
		body.space = _nape.space;
		eaze(this).killTweens();
		view.alpha = 1;
		view.visible = true;
		view.y = -(view.width / 2);
		_elapsed = 0;
		_destructed = false;
		_destruct = false;
		_posX = x;
		_posY = y;
	}

	override protected function getXPosition():uint{
		var xPos:uint = randomX - ((totalWidth / 2)) + GameConstants.TILE_SIZE / 2;
		return xPos + (GameConstants.TILE_SIZE * index);
	}

	override protected function getPlatformWidth():uint{
		return GameConstants.TILE_SIZE;
	}
}
}
