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
	public static var COLLECT_BONUS:Signal = new Signal();
	public static var PLATFORM_START_COLLISION:Signal = new Signal();
	public static var PLATFORM_END_COLLISION:Signal = new Signal();
	public static var DESTRUCT_COLLISION:Signal = new Signal();
	public static var DESTRUCT_EXPLODE:Signal = new Signal();
	public static var ARROW_COLLISION:Signal = new Signal();
	public static var CRITTER_COLLISION:Signal = new Signal();
	public static var SPIKES_COLLISION:Signal = new Signal();
	public static var BALL_JUMP:Signal = new Signal();
	public static var DESTRUCT_PLATFORM:Signal = new Signal();
	public static var STAR_BONUS_START:Signal = new Signal();
	public static var STAR_BONUS_END:Signal = new Signal();
	public static var PAUSE:Signal = new Signal();
	public static var CLOSE_POPUP:Signal = new Signal();
	public static var UPDATE_NUM_STARS:Signal = new Signal();
	public static var BALL_INVINCIBILITY_START:Signal = new Signal();
	public static var BALL_INVINCIBILITY_END:Signal = new Signal();
	public static var GAME_START:Signal = new Signal();
}
}
