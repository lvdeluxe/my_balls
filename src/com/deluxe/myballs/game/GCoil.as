/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game {
import aze.motion.EazeTween;
import aze.motion.easing.Quadratic;
import aze.motion.eaze;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.audio.SpatialSound;
import com.deluxe.myballs.particles.CoilParticles;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;

import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.shape.Shape;

public class GCoil extends NapeComponent{

    private var _view:GSprite;
    public var distance:Number;
    private var _direction:int;
    private var _startX:Number;
    private var _startY:Number;
    private var _target:Vec2 = Vec2.weak(0,0);
    private var _delay:Number = 0;
    private var _sfx:SpatialSound;

    private var _particles:CoilParticles;

    public function GCoil() {
        super();
    }

    override public function init():void{
        super.init();
        _view = node.addComponent(GSprite) as GSprite;
        _view.texture = AssetsManager.getCoilTexture();
        _sfx = new SpatialSound(SoundManager.getCoilSound(), false);
        _particles = GNodeFactory.createNodeWithComponent(CoilParticles) as CoilParticles;

    }

    override protected function update(dt:Number):void{
        super.update(dt);

        if(_particles != null)
        _particles.node.transform.setPosition(x,y);
        if(Math.abs(_body.position.x - _target.x) <= 10 && Math.abs(_body.position.y - _target.y) <= 10){
            _body.shapes.at(0).sensorEnabled = false;
            node.transform.visible = true;
            if(_particles != null)
                _particles.node.transform.visible = true;
        }else{
            _body.shapes.at(0).sensorEnabled = true;
            node.transform.visible = false;
            if(_particles != null)
                _particles.node.transform.visible = false;
        }
        if(dt > 0)
            _body.setVelocityFromTarget(Vec2.weak(_target.x, _target.y), 0, dt/1000);
        if(_sfx != null)
            _sfx.updateSound(dt, y, true);
    }

    override public function activate():void{
        super.activate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(_particles.node);
        _particles.emit = true;
        _particles.node.transform.visible = true;
        _direction = Math.random() > 0.5 ? -1 : 1;
        _delay = 0.5 + Math.random();
        _startX = _direction > 0 ? x - (distance / 2) : x + (distance / 2);
        x = _startX;
        _startY = y;
        _jumpDistance = 0;
        startTween();
        node.core.onUpdate.add(update);
    }

    private var _jumpDistance:Number = 0;
    private var _jumpOffset:Number = GameConstants.TILE_SIZE;

    private function startTween():void{
        _sfx.playOneShot();
        _particles.emit = false;
        if(_direction > 0){
            eaze(_target).to(0.4, {
                x:[this.x + (GameConstants.TILE_SIZE / 2) , this.x + GameConstants.TILE_SIZE],
                y:[_startY - (GameConstants.TILE_SIZE * 1.5), _startY]
            }).easing(Quadratic.easeOut).delay(1).onStart(function():void{
                _particles.emit = true;
            }).onComplete(startTween);
        }else{
            eaze(_target).to(0.4, {
                x:[this.x - (GameConstants.TILE_SIZE / 2) , this.x - GameConstants.TILE_SIZE],
                y:[_startY - (GameConstants.TILE_SIZE * 1.5), _startY]
            }).easing(Quadratic.easeOut).delay(1).onStart(function():void{
                _particles.emit = true;
            }).onComplete(startTween);
        }

        _jumpDistance += _jumpOffset;
        if(_jumpDistance == distance){
            _direction *= -1;
            _jumpDistance = 0;
        }
    }

    override public function deactivate():void{
        super.deactivate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(_particles.node);
        _particles.emit = false;
        _particles.node.transform.visible = false;
        EazeTween.killTweensOf(_target);
        node.core.onUpdate.remove(update);
        _sfx.cleanup();
    }

    override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(AssetsManager.getCoilTexture().width, AssetsManager.getCoilTexture().height), getMaterial());
        shape.cbTypes.add(NapeCollisionTypes.COIL_COLLISION);
        shape.sensorEnabled = true;
        return shape;
    }
}
}
