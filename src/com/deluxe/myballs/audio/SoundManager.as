/**
 * Created by lvdeluxe on 15-02-22.
 */
package com.deluxe.myballs.audio {
import com.deluxe.myballs.*;

import aze.motion.easing.Quadratic;
import aze.motion.eaze;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

public class SoundManager {

    [Embed(source='/assets/music/Enter_the_Maze.mp3')]
    public static const GameplayMusic:Class;
    [Embed(source='/assets/music/Simplex.mp3')]
    public static const MainMenuMusic:Class;
    [Embed(source='/assets/music/Hit_the_Streets.mp3')]
    public static const GameOverMusic:Class;

    [Embed(source='/assets/sfx/bounce_reverb.mp3')]
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
    [Embed(source='/assets/sfx/glass.mp3')]
    public static const GlassShatter:Class;
    [Embed(source='/assets/sfx/steam_hiss.mp3')]
    public static const Steam:Class;
    [Embed(source='/assets/sfx/electric.mp3')]
    public static const Electric:Class;
    [Embed(source='/assets/sfx/woosh.mp3')]
    public static const Woosh:Class;
    [Embed(source='/assets/sfx/hammer.mp3')]
    public static const Hammer:Class;
    [Embed(source='/assets/sfx/pop_1.mp3')]
    public static const Pop1:Class;
    [Embed(source='/assets/sfx/pop_2.mp3')]
    public static const Pop2:Class;
    [Embed(source='/assets/sfx/gear.mp3')]
    public static const Gear:Class;
    [Embed(source='/assets/sfx/boing.mp3')]
    public static const Boing:Class;
    [Embed(source='/assets/sfx/hit_gear.mp3')]
    public static const HitByGear:Class;
    [Embed(source='/assets/sfx/hit_coil.mp3')]
    public static const HitByCoil:Class;
    [Embed(source='/assets/sfx/moving_platform.mp3')]
    public static const MovingPlatform:Class;

    private static var _bounceSfx:Sound;
    private static var _clickSfx:Sound;
    private static var _collectSfx:Sound;
    private static var _bonusSfx:Sound;
    private static var _explosionSfx:Sound;
    private static var _starSfx:Sound;
    private static var _glassSfx:Sound;
    private static var _steamSfx:Sound;
    private static var _electricSfx:Sound;
    private static var _wooshSfx:Sound;
    private static var _hammerSfx:Sound;
    private static var _pop1Sfx:Sound;
    private static var _pop2Sfx:Sound;
    private static var _gearSfx:Sound;
    private static var _boingSfx:Sound;
    private static var _hitByGearSfx:Sound;
    private static var _hitByCoilSfx:Sound;
    private static var _movingPlatformSfx:Sound;

    private static var _gameplayMusic:Sound;
    private static var _mainMenuMusic:Sound;
    private static var _gameOverMusic:Sound;

    private static var _channelMainMenuTransform:SoundTransform;
    private static var _channelMainMenuMusic:SoundChannel;
    private static var _channelGameOverTransform:SoundTransform;
    private static var _channelGameOverMusic:SoundChannel;
    private static var _channelGameplayTransform:SoundTransform;
    private static var _channelGameplayMusic:SoundChannel;

    private static var _channelSfx:SoundChannel;
    public static var playSfx:Boolean = true;
    public static var playMusic:Boolean = true;

    public static function init():void{
        _clickSfx = new Click();
        _bounceSfx = new Bounce();
        _collectSfx = new Collect();
        _bonusSfx = new Bonus();
        _explosionSfx = new Explosion();
        _starSfx = new Star();
        _glassSfx = new GlassShatter();
        _steamSfx = new Steam();
        _electricSfx = new Electric();
        _wooshSfx = new Woosh();
        _hammerSfx = new Hammer();
        _pop1Sfx = new Pop1();
        _pop2Sfx = new Pop2();
        _gearSfx = new Gear();
        _boingSfx = new Boing();
        _hitByGearSfx = new HitByGear();
        _hitByCoilSfx = new HitByCoil();
        _movingPlatformSfx = new MovingPlatform();

        _channelMainMenuTransform = new SoundTransform();
        _channelMainMenuTransform.volume = 1;
        _channelGameOverTransform = new SoundTransform();
        _channelGameOverTransform.volume = 1;
        _channelGameplayTransform = new SoundTransform();
        _channelGameplayTransform.volume = 1;

        _gameplayMusic = new GameplayMusic();
        _mainMenuMusic = new MainMenuMusic();
        _gameOverMusic = new GameOverMusic();

        GameSignals.TOGGLE_MUSIC.add(onToggleMusic);
        GameSignals.TOGGLE_SFX.add(onToggleSfx);
    }

    private static function onToggleSfx(sfxOn:Boolean):void{
        playSfx = sfxOn;
    }

    private static function onToggleMusic(musicOn:Boolean):void{
        playMusic = musicOn;
        if(musicOn){
            if(_channelMainMenuMusic == null)
                _channelMainMenuMusic = _mainMenuMusic.play(0, 9999, _channelMainMenuTransform);
        }else{
            if(_channelGameplayMusic != null){
                _channelGameplayMusic.stop();
                _channelGameplayMusic = null;
            }
            if(_channelGameOverMusic != null){
                _channelGameOverMusic.stop();
                _channelGameOverMusic = null;
            }
            if(_channelMainMenuMusic != null){
                _channelMainMenuMusic.stop();
                _channelMainMenuMusic = null;
            }
        }
    }

    public static function playMainMenuMusic():void{
        if(playMusic){
            if(_channelGameplayMusic != null){
                _channelGameplayMusic.stop();
                _channelGameplayMusic = null;
            }
            if(_channelGameOverMusic != null){
                eaze(_channelGameOverMusic).to(0.5, {
                    volume:0
                }).easing(Quadratic.easeOut).onComplete(function():void{
                    _channelGameOverMusic = null;
                });
            }
            if(_channelMainMenuMusic == null)
                _channelMainMenuMusic = _mainMenuMusic.play(0, 9999, _channelMainMenuTransform);
        }
    }

    public static function playGameplayMusic():void{
        if(playMusic){
            if(_channelMainMenuMusic != null){
                eaze(_channelMainMenuMusic).to(0.5, {
                    volume:0
                }).easing(Quadratic.easeOut).onComplete(function():void{
                    _channelMainMenuMusic = null;
                });
            }
            if(_channelGameOverMusic != null){
                eaze(_channelGameOverMusic).to(0.5, {
                    volume:0
                }).easing(Quadratic.easeOut).onComplete(function():void{
                    _channelGameOverMusic = null;
                });
            }
            if(_channelGameplayMusic == null)
                _channelGameplayMusic = _gameplayMusic.play(0, 9999, _channelGameplayTransform);
        }
    }

    public static function playGameOverMusic():void{
        if(playMusic){
            if(_channelMainMenuMusic != null){
                eaze(_channelMainMenuMusic).to(0.5, {
                    volume:0
                }).easing(Quadratic.easeOut).onComplete(function():void{
                    _channelMainMenuMusic = null;
                });
            }
            if(_channelGameplayMusic != null){
                eaze(_channelGameplayMusic).to(0.5, {
                    volume:0
                }).easing(Quadratic.easeOut).onComplete(function():void{
                    _channelGameplayMusic = null;
                });
            }
            if(_channelGameOverMusic == null)
                _channelGameOverMusic = _gameOverMusic.play(0, 9999, _channelGameOverTransform);
        }
    }

    public static function getMovingPlatformSound():Sound{
        return _movingPlatformSfx;
    }

    public static function getGearSound():Sound{
        return _gearSfx;
    }

    public static function getCoilSound():Sound{
        return _boingSfx;
    }

    public static function getElectricSound():Sound{
        return _electricSfx;
    }

    public static function getSteamSound():Sound{
        return _steamSfx;
    }

    public static function playHammerSfx():void{
        if(playSfx)
            _channelSfx = _hammerSfx.play();
    }

    public static function playHitByCoilSfx():void{
        if(playSfx)
            _channelSfx = _hitByCoilSfx.play();
    }

    public static function playHitByGearSfx():void{
        if(playSfx)
            _channelSfx = _hitByGearSfx.play();
    }

    public static function playPop2Sfx():void{
        if(playSfx)
            _channelSfx = _pop2Sfx.play();
    }

    public static function playPop1Sfx():void{
        if(playSfx)
            _channelSfx = _pop1Sfx.play();
    }

    public static function playWooshSfx():void{
        if(playSfx)
            _channelSfx = _wooshSfx.play();
    }

    private static var _bounceTransform:SoundTransform = new SoundTransform();

    public static function playBounceSfx(pVelocity:Number):void{
        if(playSfx){
            _bounceTransform.volume = Math.max(0, Math.min(1, pVelocity / 200));
            _channelSfx = _bounceSfx.play(0,0,_bounceTransform);
        }
    }

    public static function playShatterSfx():void{
        if(playSfx)
            _channelSfx = _glassSfx.play();
    }

    public static function playClickSfx():void{
        if(playSfx)
            _channelSfx = _clickSfx.play();
    }

    public static function playBonusSfx():void{
        if(playSfx)
            _channelSfx = _bonusSfx.play();
    }

    public static function playCollectSfx():void{
        if(playSfx)
            _channelSfx = _collectSfx.play();
    }

    public static function playExplosionSfx():void{
        if(playSfx)
            _channelSfx = _explosionSfx.play();
    }

    public static function playStarSfx():void{
        if(playSfx)
            _channelSfx = _starSfx.play();
    }
}
}
