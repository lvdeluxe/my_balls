/**
 * Created by lvdeluxe on 14-12-24.
 */
package com.deluxe.myballs {
import org.osflash.signals.Signal;

public class GameSignals {
	public static var ORIENTATION_UPDATE:Signal = new Signal();
	public static var START_GAME:Signal = new Signal();
	public static var QUIT_GAME:Signal = new Signal();
	public static var COLLECT_STAR:Signal = new Signal();
	public static var BALL_JUMP:Signal = new Signal();
	public static var DESTRUCT_PLATFORM:Signal = new Signal();
}
}
