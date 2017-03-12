/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game {
import aze.motion.EazeTween;
import aze.motion.easing.Linear;
import aze.motion.eaze;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.audio.SpatialSound;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.components.renderables.GSprite;

import nape.geom.Vec2;
import nape.shape.Circle;
import nape.shape.Shape;

public class GCritter extends NapeComponent{

    private var _view:GSprite;
    public var distance:Number;
    private var _direction:int;
    private var _speed:Number = GameConstants.CRITTER_SPEED + Math.random();
    private var _startX:Number;
    private var _startY:Number;
    private var _halfSpeed:Number;
    private var _sideSpeed:Number;
    private var _rotation:Number = GameConstants.GEAR_ROTATION;
    private var _target:Vec2 = Vec2.weak(0,0);
    private var _targetRotation:Number = 0;
    private var _rotating:Boolean = false;
    private var _sfx:SpatialSound;
    private var _offset:Number;


    public function GCritter() {
        super();
    }

    override public function init():void{
        super.init();
        _view = node.addComponent(GSprite) as GSprite;
        _view.texture = AssetsManager.getCritterTexture();
        _sfx = new SpatialSound(SoundManager.getGearSound());
    }

    public function setOffset(offset:Number):void{
        _offset = offset;
    }

    override protected function update(dt:Number):void{
        super.update(dt);
        if(Math.abs(_body.position.x - _target.x) <= 10 * GameConstants.ASSETS_SCALE && Math.abs(_body.position.y - _target.y) <= 10 * GameConstants.ASSETS_SCALE){
            _body.shapes.at(0).sensorEnabled = false;
            node.transform.visible = true;
        }else{
            _body.shapes.at(0).sensorEnabled = true;
            node.transform.visible = false;
        }

        if(dt > 0){
            if(_rotating)
                _targetRotation += _rotation;
            _body.setVelocityFromTarget(Vec2.weak(_target.x, _target.y), _targetRotation, dt/1000);
        }
        if(_sfx != null)
            _sfx.updateSound(dt,y, _rotating);
    }

    override public function activate():void{
        super.activate();
        _direction = Math.random() > 0.5 ? -1 : 1;
        _rotation = _direction > 0 ? -GameConstants.GEAR_ROTATION : GameConstants.GEAR_ROTATION;
        _halfSpeed = _speed / 2;
        _sideSpeed = ((GameConstants.TILE_SIZE + (_offset * 2)) / distance) * _speed;
        _startX = x;
        _startY = y;
        node.transform.scaleX = _direction > 0 ? 1 : -1;
        startTween();
        _target.x = x;
        _target.y = y;
        node.core.onUpdate.add(update);
    }

    private function startTweenParams():void{
        _rotating = true
    }

    private function startTween():void{
        _rotating = false;
        if(_direction > 0){
            eaze(_target).delay(1).to(_halfSpeed, {x:_startX - (distance / 2), y:_startY}).easing(Linear.easeNone).onStart(startTweenParams).onComplete(function():void{
                eaze(_target).to(_sideSpeed, {x:_startX - (distance / 2), y:_startY + GameConstants.TILE_SIZE + (_offset * 2)}).easing(Linear.easeNone).onComplete(function():void{
                    eaze(_target).to(_speed, {x:_startX + (distance / 2), y:_startY + GameConstants.TILE_SIZE+ (_offset * 2)}).easing(Linear.easeNone).onComplete(function():void{
                        eaze(_target).to(_sideSpeed, {x:_startX + (distance / 2), y:_startY}).easing(Linear.easeNone).onComplete(function():void{
                            eaze(_target).to(_halfSpeed, {x:_startX, y:_startY}).easing(Linear.easeNone).onComplete(startTween);
                        });
                    });
                });
            });
        }else{
            eaze(_target).delay(1).to(_halfSpeed, {x:_startX + (distance / 2), y:_startY}).easing(Linear.easeNone).onStart(startTweenParams).onComplete(function():void{
                eaze(_target).to(_sideSpeed, {x:_startX + (distance / 2), y:_startY + GameConstants.TILE_SIZE + (_offset * 2)}).easing(Linear.easeNone).onComplete(function():void{
                    eaze(_target).to(_speed, {x:_startX - (distance / 2), y:_startY + GameConstants.TILE_SIZE + (_offset * 2)}).easing(Linear.easeNone).onComplete(function():void{
                        eaze(_target).to(_sideSpeed, {x:_startX - (distance / 2), y:_startY}).easing(Linear.easeNone).onComplete(function():void{
                            eaze(_target).to(_halfSpeed, {x:_startX, y:_startY}).easing(Linear.easeNone).onComplete(startTween);
                        });
                    });
                });
            });
        }
    }

    override public function deactivate():void{
        super.deactivate();
        EazeTween.killTweensOf(_target);
        node.core.onUpdate.remove(update);
        _sfx.cleanup();
    }

    override protected function getShape():Shape{
        var shape:Shape = new Circle(AssetsManager.getCritterTexture().width / 2 * 0.8, null, getMaterial());
        shape.cbTypes.add(NapeCollisionTypes.CRITTER_COLLISION);
        shape.sensorEnabled = true;
        return shape;
    }
}
}
