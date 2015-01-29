/**
 * Created by lvdeluxe on 14-12-26.
 */
package com.deluxe.myballs.states.game.obstacles {
import aze.motion.EazeTween;
import aze.motion.eaze;

import citrus.objects.NapePhysicsObject;
import citrus.objects.platformer.nape.Enemy;
import citrus.objects.platformer.nape.Platform;
import citrus.physics.nape.NapeUtils;
import citrus.view.starlingview.StarlingArt;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.states.game.BallBody;

import nape.dynamics.CollisionArbiter;
import nape.shape.Edge;

import starling.display.BlendMode;
import starling.display.MovieClip;

import nape.callbacks.InteractionCallback;

import starling.textures.TextureSmoothing;

public class NapeCritter extends Enemy{

	private var _destroyed:Boolean = false;

	public function NapeCritter(name:String, params:Object=null) {
		super(name, params);
		enemyClass = BallBody;
		_view = AssetsManager.getCritterMovieClip();
		view.smoothing = TextureSmoothing.NONE;
		group = 3;
		view.touchable = false
	}

	override public function handleBeginContact(callback:InteractionCallback):void {
		var eClass:Class = enemyClass;
		var collider:NapePhysicsObject = NapeUtils.CollisionGetOther(this, callback);
		if (collider is eClass){
			var arbiter:CollisionArbiter = callback.arbiters.at(0).collisionArbiter;
			var refEdge:Edge = arbiter.referenceEdge1 != null ? arbiter.referenceEdge1 : arbiter.referenceEdge2;
			if (callback.arbiters.length > 0 && arbiter != null && refEdge != null) {
				if (collider is eClass && refEdge.localNormal.y < 0){
					hurt();
				}else {
					turnAround();
				}
			}
		}
	}

	public function activate():void{
		if(body)
			body.space = _nape.space;
		view.visible = true;
		view.scaleY = 1;
		if(_destroyed) {
			view.pivotY = 0;
			view.y -= view.height;
		}
		_destroyed = false;
		kill = false;
		speed = 39;
		MovieClip(view).play();
	}

	override public function hurt():void {
		_destroyed = true;
		if(body)
			body.space = null;
		view.pivotY = view.height;
		view.y += view.height;
		MovieClip(view).stop();
		eaze(view).to(0.25,{scaleY:0}).onComplete(function():void{
			view.visible = false;
		});
	}

	public function get destroyed():Boolean {
		return _destroyed;
	}
}
}
