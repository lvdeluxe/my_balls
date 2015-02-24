/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.components.renderables.GSprite;
import com.greensock.TweenLite;
import com.greensock.easing.Quad;

import flash.utils.setTimeout;

import nape.phys.Body;

import nape.shape.Polygon;

import nape.shape.Shape;

public class GArrow extends NapeComponent{

    private static const _LEFT:Number =  GameConstants.TILE_SIZE  * 1.5;
    private static const _RIGHT:int = GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 1.5);

    private var _direction:int;
    private var _view:GSprite;
    private var _rotationValue:Number = Math.PI * 6;
    private var _speed:Number = 0.3 + (Math.random() * 0.5);

    public function GArrow() {
        super();
    }

    override public function init():void{
        super.init();
        _view = node.addComponent(GSprite) as GSprite;
        _view.texture = AssetsManager.getArrowLeftTexture();
    }

    private function onCollision(pBody:Body):void{
        if(pBody == _body){
            trace("contact");
        }
    }

    override public function activate():void{
        super.activate();
        GameSignals.ARROW_COLLISION.add(onCollision);
        _direction = Math.random() < 0.5 ? 1 : -1;
        x = _direction > 0 ? _LEFT : _RIGHT;
        node.transform.scaleX = _direction > 0 ? 1 : -1;
        TweenLite.to(this,_speed,{x:_direction > 0 ? _RIGHT : _LEFT, rotation:_direction > 0 ? _rotationValue : -_rotationValue, delay: Math.random(), ease:Quad.easeIn, onComplete:onTweenComplete});
    }

    private function onTweenComplete():void{
        var obj:GArrow = this;
        setTimeout(function():void{
            x = _direction > 0 ? _LEFT : _RIGHT;
            rotation = 0;
            TweenLite.to(obj,_speed,{x:_direction > 0 ? _RIGHT : _LEFT, rotation:_direction > 0 ? _rotationValue : -_rotationValue, ease:Quad.easeIn, onComplete:onTweenComplete});
        }, 5000);

    }

    override public function deactivate():void{
        super.deactivate();
        TweenLite.killTweensOf(this);
        x = _direction > 0 ? _LEFT : _RIGHT;
        rotation = 0;
        GameSignals.ARROW_COLLISION.remove(onCollision);
    }

    override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(GameConstants.TILE_SIZE,GameConstants.TILE_SIZE,true));
        shape.material = getMaterial();
        shape.sensorEnabled = true;
        shape.cbTypes.add(NapeCollisionTypes.ARROW_COLLISION);
        return shape;
    }
}
}
