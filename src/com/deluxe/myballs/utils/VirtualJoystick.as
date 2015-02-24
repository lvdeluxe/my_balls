/**
 * Created by lvdeluxe on 14-08-03.
 */
package com.deluxe.myballs.utils {
import com.deluxe.myballs.GameConstants;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class VirtualJoystick extends Sprite{

	[Embed(source="/assets/joystick.png")]
	private var JoystickTexture:Class;
	[Embed(source="/assets/joystickTarget.png")]
	private var JoystickTargetTexture:Class;

	private var _joystickRadius:Number = 64;
	private var _joystickTargetSprite:Sprite;

	public function VirtualJoystick(pStage:Stage) {
		var joystickBitmap:Bitmap = new JoystickTexture();
		joystickBitmap.x = -joystickBitmap.width / 2;
		joystickBitmap.y = -joystickBitmap.height / 2;
		addChild(joystickBitmap);

		_joystickTargetSprite = new Sprite();
		var img:Bitmap = new JoystickTargetTexture();
		img.x =  - (img.width / 2);
		img.y =  - (img.height / 2);
		_joystickTargetSprite.addChild(img);
		_joystickTargetSprite.mouseEnabled = true;

		addChild(_joystickTargetSprite);

		x = GameConstants.SCREEN_WIDTH - _joystickRadius - 20;
		y = _joystickRadius + 20;
		pStage.addChild(this);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function onMouseDown(event:MouseEvent):void {
		_joystickTargetSprite.x = event.localX;
		_joystickTargetSprite.y	= event.localY;
		addEventListener(Event.ENTER_FRAME, onFrame);
	}

	private function onMouseUp(event:MouseEvent):void {
		removeEventListener(Event.ENTER_FRAME, onFrame);
		var e:JoystickEvent = new JoystickEvent(JoystickEvent.JOYSTICK_UPDATE);
		e.velX = 0;
		e.velY = 0;
		dispatchEvent(e);
		_joystickTargetSprite.x = 0;
		_joystickTargetSprite.y = 0;
	}

	private function onFrame(event:Event):void {
		var angle:Number = Math.atan2(stage.mouseY - y,stage.mouseX - x);
		var distance:Number = Math.sqrt(Math.pow(stage.mouseX - x, 2) + Math.pow(stage.mouseY - y, 2));
		if (Math.ceil(distance) >= _joystickRadius) {
			_joystickTargetSprite.x = (Math.cos(angle) * _joystickRadius);
			_joystickTargetSprite.y = (Math.sin(angle) * _joystickRadius);
		} else {
			_joystickTargetSprite.x = stage.mouseX - x;
			_joystickTargetSprite.y = stage.mouseY - y;
		}
		var e:JoystickEvent = new JoystickEvent(JoystickEvent.JOYSTICK_UPDATE);
		e.velX = _joystickTargetSprite.x / _joystickRadius;
		e.velY = _joystickTargetSprite.y / _joystickRadius;
		dispatchEvent(e);
	}
}
}
