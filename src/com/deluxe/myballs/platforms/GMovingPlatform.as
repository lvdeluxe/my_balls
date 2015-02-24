/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.platforms {
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.GameConstants;

public class GMovingPlatform extends GPlatform {

    private var _minX:Number;
    private var _maxX:Number;
    private var _direction:int;
    private var _speed:Number = Math.ceil(Math.random() * 3);
    private var _gamePaused:Boolean = false;


    public function GMovingPlatform() {
        super();
        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _gamePaused = pPaused;
    }

    override public function init():void{
        super.init();
    }

    override protected function update(dt:Number):void{
        super.update(dt);
        if(!_gamePaused){
            _body.position.x += _direction * _speed;
            if(_body.position.x <= _minX){
                _body.position.x = _minX;
                _direction *= -1;
            }else if(_body.position.x >= _maxX){
                _body.position.x = _maxX;
                _direction *= -1;
            }
        }
    }

    override protected function setBonus():void {

    }

    override public function deactivate():void{
        super.deactivate();
        node.core.onUpdate.remove(update);
    }

    override public function activate():void{
        super.activate();
        node.core.onUpdate.add(update);
        _direction = Math.random() < 0.5 ? -1 : 1;
        _minX = (GameConstants.SCREEN_WIDTH / 2) - ((GameConstants.SCREEN_WIDTH - _width - (GameConstants.TILE_SIZE * 2)) / 2);
        _maxX = (GameConstants.SCREEN_WIDTH / 2) + ((GameConstants.SCREEN_WIDTH - _width - (GameConstants.TILE_SIZE * 2)) / 2);
    }
}
}
