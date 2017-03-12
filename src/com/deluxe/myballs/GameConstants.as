/**
 * Created by lvdeluxe on 14-12-10.
 */
package com.deluxe.myballs {
public class GameConstants {
    //DISPLAY
	public static var SCREEN_WIDTH:uint;
	public static var SCREEN_HEIGHT:uint;
	public static var ASSETS_SCALE:uint = 1;
	public static var TILE_SIZE:uint = 32;
    public static const PLATFORM_OFFSET:Number = 200;
    public static const BALL_DAMAGE_ALARM:uint = 20;

    //BONUS
    public static const START_STARS:uint = 25;
	public static var STARS_BONUS_TIME:uint = 10000;
	public static var GRAVITY_BONUS_TIME:uint = 10000;
	public static var INVINCIBILITY_TIME:uint = 10000;
    public static var ORIENTATION_MULTIPLIER:Number = 1.2;
    public static var JUMP_MULTIPLIER:Number = 1.1;
    public static var STAR_BONUS_MULTIPLIER:uint = 2;
    public static const BONUS_PROBABILITY:Number = 0.65;
    public static const NUM_STARS_PER_PLATFORM:int = 5;

    //OBSTACLES
    public static var STEAM_EMIT_TIME:Number = 2000;
    public static var ELECTRIC_EMIT_TIME:Number = 3000;
    public static var EXPLOSION_RADIUS:Number = 100;
    public static var EXPLOSION_FORCE_Y:Number = 800;
    public static var EXPLOSION_FORCE_X:Number = 600;
    public static var CRITTER_SPEED:Number = 1.5;
    public static var CRITTER_IMPULSE:Number = 250;
    public static var COIL_IMPULSE:Number = 300;
    public static var GEAR_ROTATION:Number = 0.1;
    public static const MOVING_PLATFORM_TIME:Number = 1000;

    //DAMAGE
    public static var ELECTRIC_DAMAGE_TIME:Number = 200;
    public static var STEAM_DAMAGE_TIME:Number = 250;
    public static var EXPLOSION_DAMAGE:Number = 10;
    public static var GEAR_DAMAGE:Number = 8;
    public static var COIL_DAMAGE:Number = 6;

    //PHYSICS
    public static var JUMP_FACTOR:Number = 10;
    public static var JUMP_HEIGHT:Number = 500;
    public static var SCORE_RATIO:Number = 0.1;

    //MISC
    public static const RAD_TO_DEG:Number = 0.0174532925;

}
}
