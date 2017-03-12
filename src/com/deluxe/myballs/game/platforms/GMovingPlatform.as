/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game.platforms {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.audio.SpatialSound;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;

import nape.geom.Vec2;

public class GMovingPlatform extends GPlatform {

    private var _minX:Number;
    private var _maxX:Number;
    private var _direction:int;
    private var _speed:Number = 1 + Math.ceil(Math.random());
    private var _gamePaused:Boolean = false;
    private var _sfx:SpatialSound;
    private var _moving:Boolean = true;
    private var _elapsed:Number = 0;
    private var _wire:GSprite;


    public function GMovingPlatform() {
        super();
        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _gamePaused = pPaused;
    }

    override public function init():void{
        super.init();
        _sfx = new SpatialSound(SoundManager.getMovingPlatformSound());
        _wire = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _wire.texture = AssetsManager.getPlatformWireTexture();
        _wire.node.transform.scaleX = GameConstants.SCREEN_WIDTH / _wire.texture.width;
        _wire.texture.uvScaleX = GameConstants.SCREEN_WIDTH / _wire.texture.width;
    }

    private var _tweenTarget:Vec2 = new Vec2(0,0);

    override protected function update(dt:Number):void{
        super.update(dt);
        if(!_gamePaused){
            if(_moving){
                _tweenTarget.x += _direction * _speed;
                if(_wire != null)
                    _wire.texture.uvX += _direction * 0.01 * _speed;
                if(_tweenTarget.x <= _minX){
                    _tweenTarget.x = _minX;
                    _direction *= -1;
                    _moving = false;
                }else if(_tweenTarget.x >= _maxX){
                    _tweenTarget.x = _maxX;
                    _direction *= -1;
                    _moving = false;
                }
            }else{
                _elapsed += dt;
                if(_elapsed >= GameConstants.MOVING_PLATFORM_TIME){
                    _elapsed = 0;
                    _moving = true;
                }
            }
            if(_sfx != null)
                _sfx.updateSound(dt,y,_moving);
            _body.setVelocityFromTarget(_tweenTarget, 0,dt / 1000);
        }
    }

    override public function deactivate():void{
        super.deactivate();
        node.core.onUpdate.remove(update);
        _sfx.cleanup();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.BALL_LAYER).removeChild(_wire.node);
    }

    override public function activate():void{
        super.activate();
        _tweenTarget.x = x;
        _tweenTarget.y = y;
        node.core.onUpdate.add(update);
        _direction = Math.random() < 0.5 ? -1 : 1;
        _minX = (GameConstants.SCREEN_WIDTH / 2) - ((GameConstants.SCREEN_WIDTH - _width - (GameConstants.TILE_SIZE * 2)) / 2);
        _maxX = (GameConstants.SCREEN_WIDTH / 2) + ((GameConstants.SCREEN_WIDTH - _width - (GameConstants.TILE_SIZE * 2)) / 2);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.BALL_LAYER).addChild(_wire.node);
        _wire.node.transform.setPosition(GameConstants.SCREEN_WIDTH / 2,y);
    }
}
}
