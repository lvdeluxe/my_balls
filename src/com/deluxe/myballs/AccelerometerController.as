/**
 * Created by lvdeluxe on 14-10-23.
 */
package com.deluxe.myballs  {
import com.deluxe.myballs.utils.JoystickEvent;
import com.deluxe.myballs.utils.VirtualJoystick;

import flash.display.Stage;
import flash.events.AccelerometerEvent;
import flash.sensors.Accelerometer;

public class AccelerometerController {


	private var _accelerometer:Accelerometer;
	private var _joystick:VirtualJoystick;
	private var isAccelSupported:Boolean = false;
	private var _stage:Stage;

	public function AccelerometerController(pStage:Stage) {
		_stage = pStage;
		init();
	}

	public function destroy():void{
		if(_accelerometer != null){
			_accelerometer.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
		}
		if(_joystick != null){
			_joystick.removeEventListener(JoystickEvent.JOYSTICK_UPDATE, onJoystickUpdate);
			_joystick.parent.removeChild(_joystick);
		}
	}

	private function init():void {
		isAccelSupported = Accelerometer.isSupported;
		if(isAccelSupported) {
			_accelerometer = new Accelerometer();
			_accelerometer.setRequestedUpdateInterval(20);
			_accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
		}
		else {
			_joystick = new VirtualJoystick(_stage);
			_joystick.addEventListener(JoystickEvent.JOYSTICK_UPDATE, onJoystickUpdate);
		}
	}

	private function onJoystickUpdate(e:JoystickEvent):void {
		setOrientation(e.velX, e.velY);
	}

	private function setOrientation(accelX:Number, accelY:Number):void {
		GameSignals.ORIENTATION_UPDATE.dispatch(accelX, accelY);
	}

	private function onAccelerometer(e:AccelerometerEvent):void {
		setOrientation(-e.accelerationX * 1.5, e.accelerationY * 1.5);
	}
}
}
