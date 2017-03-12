/**
 * Created by lvdeluxe on 15-03-09.
 */
package com.deluxe.myballs.audio {
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.Genome2D;
import com.genome2d.components.GCameraController;
import com.genome2d.components.GTransform;

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

public class SpatialSound {

    private var _soundTransform:SoundTransform;
    private var _oneShotTransform:SoundTransform;
    private var _soundChannel:SoundChannel;
    private var _sound:Sound;
    private var _camera:GTransform;
    private var _halfScreenHeight:Number;
    private var _fadeTime:Number = 500;
    private var _elapsed:Number = 0;
    private var _volumeWhenFade:Number;
    private var _fadeStarted:Boolean = false;
    private var _looping:Boolean = true;
    private var _volumeWhenPause:Number = 0;
    private var _paused:Boolean = false

    public function SpatialSound(pSound:Sound, pLooping:Boolean = true) {
        _sound = pSound;
        _looping = pLooping;
        _soundTransform = new SoundTransform();
        _oneShotTransform = new SoundTransform();
        _halfScreenHeight = GameConstants.SCREEN_HEIGHT / 2;
        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        if(pPaused){
            _paused = true;
            _volumeWhenPause = _soundTransform.volume;
            _soundTransform.volume = 0;
            if(_soundChannel != null)
                _soundChannel.soundTransform = _soundTransform;
        }else{
            _paused = false;
            _soundTransform.volume = _volumeWhenPause;
            if(SoundManager.playSfx){
                if(_soundChannel != null)
                    _soundChannel.soundTransform = _soundTransform;
            }
        }
    }

    public function cleanup():void{
        _elapsed = 0;
        _fadeStarted = false;
        if(_soundChannel != null)
            _soundChannel.stop();
        _soundChannel = null;
    }

    public function playOneShot():void{
        if(SoundManager.playSfx){
            if(_soundTransform.volume > 0){
                _oneShotTransform.volume = 1;
                _soundChannel = _sound.play(0,1,_soundTransform);
            }
        }
    }

    public function updateSound(dt:Number, pY:Number, playSound:Boolean):void{
        if(SoundManager.playSfx){
            if(_camera == null){
                var camera:GCameraController = Main.mainCamera;
                if(camera == null){
                    return;
                }
                _camera = camera.node.transform;
            }
            if(!_paused){
                var diffY:Number = Math.abs(_camera.y - pY);
                var volume:Number;
                if(diffY <= _halfScreenHeight){
                    if(playSound){
                        volume = ((_halfScreenHeight - diffY) / _halfScreenHeight);
                        volume = Math.max(0, Math.min(1, volume));
                        _soundTransform.volume = volume;
                        if(_soundChannel == null){
                            if(_looping)
                                _soundChannel = _sound.play(80,9999,_soundTransform);
                        }
                        if(_soundChannel != null)
                            _soundChannel.soundTransform = _soundTransform;

                    }else{
                        if(_soundChannel != null){
                            if(!_fadeStarted){
                                _fadeStarted = true;
                                _volumeWhenFade = _soundTransform.volume;
                            }
                            _elapsed += dt;
                            _soundTransform.volume = _volumeWhenFade * (1 - (_elapsed / _fadeTime));
                            _soundChannel.soundTransform = _soundTransform;
                            if(_elapsed >= _fadeTime){
                                _elapsed = 0;
                                _fadeStarted = false;
                                _soundChannel.stop();
                                _soundChannel = null;
                            }
                        }
                    }
                }else{
                    if(_soundChannel != null){
                        _elapsed = 0;
                        _fadeStarted = false;
                        _soundChannel.stop();
                        _soundChannel = null;
                    }
                }
            }
        }
    }
}
}
