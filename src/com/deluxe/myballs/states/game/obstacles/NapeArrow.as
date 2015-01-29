/**
 * Created by lvdeluxe on 14-12-29.
 */
package com.deluxe.myballs.states.game.obstacles {
import aze.motion.easing.Linear;
import aze.motion.eaze;

import citrus.objects.CitrusSprite;
import citrus.objects.NapePhysicsObject;
import citrus.physics.nape.NapeUtils;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.states.game.BallBody;
import com.deluxe.myballs.GameConstants;

import nape.callbacks.InteractionCallback;
import nape.dynamics.CollisionArbiter;
import nape.phys.BodyType;
import nape.shape.Edge;

import starling.display.BlendMode;
import starling.display.Image;
import starling.textures.TextureSmoothing;

public class NapeArrow extends NapePhysicsObject{

	private static var NUM_ARROWS:uint = 5;
	private static var INC_ARROWS:uint = 0;

	private var _tweenTime:Number = 0.5;
	private var _tweenDelay:Number = 2;

	private var _startX:Number;
	private var _endX:Number;

	private var _container:CitrusSprite;

	private var _destroyed:Boolean = false;

	public function NapeArrow(name:String, params:Object = null) {
		super(name, params);
		view = new Image(AssetsManager.getArrowLeftTexture());
		INC_ARROWS++;
		if(INC_ARROWS == NUM_ARROWS)
			INC_ARROWS = 0;
		beginContactCallEnabled = true;
		group = 3;
		view.touchable = false;
		view.smoothing = TextureSmoothing.NONE;
		_container = new ArrowContainer("arrowContainer");
	}

	private function setPositions():void{
		var rnd:Number = Math.random();
		if(rnd > 0.5){
			_startX = 32 - (width / 2);
			_container.view.pivotX = 0;
			//_container.view.scaleX = 1;
			_container.x = 32;
			_container.y = y - (_container.view.height / 2);
			_endX = GameConstants.SCREEN_WIDTH - 32 - (width / 2);
			view.pivotX = 0;
			//view.scaleX = 1;
			Image(view).texture = AssetsManager.getArrowLeftTexture();
			Image(container.view).texture = AssetsManager.getArrowContainerLeftTexture();
		}else{
			_startX = GameConstants.SCREEN_WIDTH - 32 + (width / 2);
			_endX = 32 + (width / 2);
			_container.view.pivotX = _container.view.width;
			//_container.view.scaleX = -1;
			_container.x = GameConstants.SCREEN_WIDTH - 32 - 13;
			_container.y = y - (_container.view.height / 2);
			view.pivotX = view.width;
			//view.scaleX = -1;
			Image(view).texture = AssetsManager.getArrowRightTexture();
			Image(container.view).texture = AssetsManager.getArrowContainerRightTexture();
		}
	}

	public function deactivate():void{
		eaze(this).killTweens();
	}
	public function activate(pX:uint, pY:uint):void{
		_destroyed = false;
		kill = false;
		_container.kill = false;
		x = pX;
		y = pY - 32;
		setPositions();
		if(body && body.space == null)
			body.space = _nape.space;
		visible = true;
		x = _startX;
		eaze(this).delay(INC_ARROWS * 0.5).to(_tweenTime,{x:_endX}).easing(Linear.easeNone).onComplete(onTweenComplete);
	}

	private function hurt():void{
		_destroyed = true;
		eaze(this).killTweens();
		visible = false;
		if(body)
			body.space = null;
	}

	override public function handleBeginContact(callback:InteractionCallback):void {
		var collider:NapePhysicsObject = NapeUtils.CollisionGetOther(this, callback);
		if (collider is BallBody && callback.arbiters.length > 0 && callback.arbiters.at(0).collisionArbiter) {
			var arbiter:CollisionArbiter = callback.arbiters.at(0).collisionArbiter;
			var refEdge:Edge = arbiter.referenceEdge1 != null ? arbiter.referenceEdge1 : arbiter.referenceEdge2;
			if (refEdge.localNormal.y != 0){
				trace("destroy arrow");
				hurt();
			}else{
				trace("destroy ball")

				deactivate();
				x = _startX;
				eaze(this).delay(INC_ARROWS * 0.5).to(_tweenTime,{x:_endX}).easing(Linear.easeNone).onComplete(onTweenComplete);
			}
		}
	}

	private function onTweenComplete():void{
		eaze(this).delay(_tweenDelay).apply({x:_startX}).to(_tweenTime,{x:_endX}).easing(Linear.easeNone).onComplete(onTweenComplete);
	}

	override protected function defineBody():void {
		_bodyType = BodyType.KINEMATIC;
	}

	public function get container():CitrusSprite {
		return _container;
	}

	public function get destroyed():Boolean {
		return _destroyed;
	}
}
}
