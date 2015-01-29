/**
 * Created by lvdeluxe on 14-12-31.
 */
package com.deluxe.myballs.states {
import com.deluxe.myballs.*;

import citrus.core.starling.StarlingState;

import feathers.controls.Button;

import flash.display.BitmapData;

import starling.events.Event;
import starling.textures.Texture;

public class MainMenuState extends StarlingState{

	private var _startBtn:Button;

	public function MainMenuState() {
		_startBtn = new Button();
		_startBtn.label = "Start!";
		_startBtn.validate();
		_startBtn.x = (GameConstants.SCREEN_WIDTH / 2) - (_startBtn.width / 2);
		_startBtn.y = (GameConstants.SCREEN_HEIGHT / 2) - (_startBtn.height / 2);
		_startBtn.addEventListener(Event.TRIGGERED, onClickStart);
		addChild(_startBtn);
	}

	override public function destroy():void{
		_startBtn.removeEventListener(Event.TRIGGERED, onClickStart);
		removeChild(_startBtn);
		super.destroy();
	}

	private function onClickStart(event:Event):void {
		GameSignals.START_GAME.dispatch();
	}
}
}
