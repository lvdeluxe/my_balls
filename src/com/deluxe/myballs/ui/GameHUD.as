/**
 * Created by lvdeluxe on 15-01-14.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;

import feathers.controls.Button;

import starling.display.Sprite;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.text.TextField;

public class GameHUD extends Sprite{

	private var _starsCounter:TextField;
	private var _jumpButton:Button;


	public function GameHUD() {
		addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		_starsCounter = new TextField(GameConstants.SCREEN_WIDTH,32,"STARS", "Futura32",BitmapFont.NATIVE_SIZE);
		_starsCounter.color = 0xffffff;
		addChild(_starsCounter);
		setJumpButton();
		updateStarsCounter(0);
	}

	private function onRemove(event:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
	}

	private function setJumpButton():void {
		_jumpButton = new Button();
		addChild(_jumpButton);
		_jumpButton.addEventListener(Event.TRIGGERED, onClickJump);
		_jumpButton.validate();
		_jumpButton.x = GameConstants.SCREEN_WIDTH - _jumpButton.width;
		_jumpButton.y = GameConstants.SCREEN_HEIGHT - _jumpButton.height;
	}

	public function updateStarsCounter(numStars:uint):void{
		_starsCounter.text = "STARS X" + numStars.toString();
	}

	public function updateText(txt:String):void{
		_starsCounter.text = txt;
	}

	private function onClickJump(event:Event):void {
		GameSignals.BALL_JUMP.dispatch();
	}
}
}
