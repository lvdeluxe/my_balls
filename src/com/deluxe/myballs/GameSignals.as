/**
 * Created by lvdeluxe on 14-12-24.
 */
package com.deluxe.myballs {

import org.osflash.signals.Signal;

public class GameSignals {
    //LOGIC
	public static var ORIENTATION_UPDATE:Signal = new Signal();
	public static var QUIT_GAME:Signal = new Signal();
    public static var PAUSE:Signal = new Signal();
    public static var GAME_START:Signal = new Signal();
    public static var TOGGLE_SFX:Signal = new Signal();
    public static var TOGGLE_MUSIC:Signal = new Signal();
    public static var UPDATE_BALL_DAMAGE:Signal = new Signal();
    public static var PLAY_AGAIN:Signal = new Signal();
    public static var HIGH_SCORE:Signal = new Signal();
    public static var TUTORIAL_COMPLETE:Signal = new Signal();

    //UI
    public static var CLOSE_POPUP:Signal = new Signal();
    public static var DISPLAY_TWITTER:Signal = new Signal();
    public static var DISPLAY_CREDITS:Signal = new Signal();
    public static var DISPLAY_TUTORIAL:Signal = new Signal();
    public static var DISPLAY_FACEBOOK:Signal = new Signal();
    public static var DISPLAY_GAME_CENTER:Signal = new Signal();
    public static var UI_OPTIONS:Signal = new Signal();
    public static var MORE_GAMES_READY:Signal = new Signal();
    public static var MORE_GAMES_DISPLAY:Signal = new Signal();
    public static var MORE_GAMES_FAILED:Signal = new Signal();

    //BONUS
	public static var COLLECT_STAR:Signal = new Signal();
	public static var COLLECT_BONUS:Signal = new Signal();
	public static var COLLECTED_BONUS:Signal = new Signal();
    public static var STAR_BONUS_START:Signal = new Signal();
    public static var STAR_BONUS_END:Signal = new Signal();
    public static var GRAVITY_BONUS_START:Signal = new Signal();
    public static var GRAVITY_BONUS_END:Signal = new Signal();
    public static var UPDATE_NUM_STARS:Signal = new Signal();
    public static var INVINCIBILITY_BONUS_START:Signal = new Signal();
    public static var BALL_INVINCIBILITY_END:Signal = new Signal();
    public static var BALLS_BONUS_START:Signal = new Signal();
    public static var BALLS_BONUS_END:Signal = new Signal();

    //PHYSICS
	public static var PLATFORM_COLLISION:Signal = new Signal();
	public static var ELECTRIC_COLLISION:Signal = new Signal();
	public static var COIL_COLLISION:Signal = new Signal();
	public static var DESTRUCT_COLLISION:Signal = new Signal();
	public static var DESTRUCT_EXPLODE:Signal = new Signal();
	public static var STEAM_COLLISION:Signal = new Signal();
	public static var CRITTER_COLLISION:Signal = new Signal();
}
}
