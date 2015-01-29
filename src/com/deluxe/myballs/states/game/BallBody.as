/**
 * Created by lvdeluxe on 14-12-21.
 */
package com.deluxe.myballs.states.game {
import com.deluxe.myballs.*;

import citrus.objects.NapePhysicsObject;
import citrus.physics.nape.INapePhysicsObject;
import citrus.physics.nape.NapeUtils;

import nape.callbacks.InteractionCallback;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;

import com.deluxe.myballs.states.game.platforms.NapePlatform;

import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.textures.TextureSmoothing;

public class BallBody extends NapePhysicsObject{

	private var isCollidingPlatform:Boolean = false;

	public function BallBody(name:String, params:Object = null) {
		super(name, params);
		view = new Image(AssetsManager.getBallTexture());
		x = params.x;
		group = 5;
		view.touchable = false;
//		view.smoothing = TextureSmoothing.NONE;
	}

	override protected function createBody():void {
		_body = new Body(BodyType.DYNAMIC,Vec2.weak(50,50));
		_body.userData.myData = this;

		beginContactCallEnabled = true;
		endContactCallEnabled = true;
	}

	override public function handleEndContact(contact:InteractionCallback):void{
		var collider:INapePhysicsObject = NapeUtils.CollisionGetOther(this,contact);

		if(collider is NapePlatform)
		{
			isCollidingPlatform = false;
		}
	}


	override public function handleBeginContact(contact:InteractionCallback):void
	{
		var collider:INapePhysicsObject = NapeUtils.CollisionGetOther(this,contact);

		if(collider is NapePlatform)
		{
			isCollidingPlatform = true;
		}
	}

	override protected function createMaterial():void {
		_material = Material.rubber();
	}

	override protected function createShape():void {
		_body.shapes.add(new Circle(GameConstants.TILE_SIZE / 2,null, _material));
	}

	public function set impulse(pImp:Vec2):void{
		_body.applyImpulse(pImp);
	}

	public function jump():void {
		if(isCollidingPlatform){
			impulse = Vec2.weak(0,-200);
		}
	}
}
}
