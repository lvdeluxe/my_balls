/**
 * Created by lvdeluxe on 15-02-22.
 */
package com.deluxe.myballs {
import flash.media.Sound;
import flash.media.SoundChannel;

public class SoundManager {

    [Embed(source='/assets/sfx/bounce.mp3')]
    public static const Bounce:Class;
    [Embed(source='/assets/sfx/click.mp3')]
    public static const Click:Class;
    [Embed(source='/assets/sfx/bonus.mp3')]
    public static const Bonus:Class;
    [Embed(source='/assets/sfx/collect.mp3')]
    public static const Collect:Class;
    [Embed(source='/assets/sfx/explosion.mp3')]
    public static const Explosion:Class;
    [Embed(source='/assets/sfx/star.mp3')]
    public static const Star:Class;

    private static var _bounceSfx:Sound;
    private static var _clickSfx:Sound;
    private static var _collectSfx:Sound;
    private static var _bonusSfx:Sound;
    private static var _explosionSfx:Sound;
    private static var _starSfx:Sound;

    private static var _channelSfx:SoundChannel;
    private static var _playSfx:Boolean = true;

    public static function init():void{
        _clickSfx = new Click();
        _bounceSfx = new Bounce();
        _collectSfx = new Collect();
        _bonusSfx = new Bonus();
        _explosionSfx = new Explosion();
        _starSfx = new Star();
    }

    public static function playBounceSfx():void{
        if(_playSfx)
            _channelSfx = _bounceSfx.play();
    }

    public static function playClickSfx():void{
        if(_playSfx)
            _channelSfx = _clickSfx.play();
    }

    public static function playBonusSfx():void{
        if(_playSfx)
            _channelSfx = _bonusSfx.play();
    }

    public static function playCollectSfx():void{
        if(_playSfx)
            _channelSfx = _collectSfx.play();
    }

    public static function playExplosionSfx():void{
        if(_playSfx)
            _channelSfx = _explosionSfx.play();
    }

    public static function playStarSfx():void{
        if(_playSfx)
            _channelSfx = _starSfx.play();
    }
}
}
