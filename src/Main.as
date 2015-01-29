/**
 * Created by lvdeluxe on 14-12-20.
 */
package {
import citrus.core.starling.StarlingCitrusEngine;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.states.MainMenuState;
import com.deluxe.myballs.states.GameState;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;

[SWF(width='640', height='960', backgroundColor='#000000', frameRate='60')]
public class Main extends StarlingCitrusEngine{


	public function Main() {
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
	}

	override public function initialize():void {
		setUpStarling(true,0);
	}

	override public function handleStarlingReady():void {
		GameSignals.START_GAME.add(onGameStart);
		GameSignals.QUIT_GAME.add(onGameQuit);
		GameConstants.SCREEN_HEIGHT = stage.fullScreenHeight;
		GameConstants.SCREEN_WIDTH = stage.fullScreenWidth;
		AssetsManager.init();
		state = new MainMenuState();
	}

	private function onGameQuit():void {
		state = new MainMenuState();
	}
	private function onGameStart():void {
		state = new GameState();
	}
}
}
