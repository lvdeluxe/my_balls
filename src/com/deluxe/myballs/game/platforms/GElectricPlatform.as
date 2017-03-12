/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game.platforms {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.audio.SpatialSound;
import com.deluxe.myballs.particles.ElectricParticles;
import com.deluxe.myballs.particles.ParticlesFactory;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;

import nape.geom.Vec2;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.shape.Shape;

public class GElectricPlatform extends GPlatform {

    private var _particles:ElectricParticles;
    private var _leftPole:GNode;
    private var _rightPole:GNode;
    private var _collider:Body;
    private var _elapsed:Number = 0;
    private var _paused:Boolean = false;

    private var _sfx:SpatialSound;
//
    public function GElectricPlatform() {
        super();
    }

    override public function init():void{
        super.init();
        setParticles();
        setCollider();
        _sfx = new SpatialSound(SoundManager.getElectricSound());
        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _paused = pPaused;
    }

    private function setCollider():void {
        _collider = new Body(BodyType.KINEMATIC);
        var shape:Shape = new Polygon(Polygon.box(_width - (GameConstants.TILE_SIZE * 2),GameConstants.TILE_SIZE,true));
        shape.sensorEnabled = true;
        shape.cbTypes.add(NapeCollisionTypes.ELECTRIC_COLLISION);
        _collider.shapes.add(shape);
    }

    private function setParticles():void {
        _particles = GNodeFactory.createNodeWithComponent(ElectricParticles) as ElectricParticles;
        _particles.texture = ParticlesFactory.getElectricTextureByWidth(width);
        var leftPole:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        leftPole.texture = AssetsManager.getElectricPoleTexture();
        _leftPole = leftPole.node;
        var rightPole:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        rightPole.texture = AssetsManager.getElectricPoleTexture();
        rightPole.node.transform.scaleX = -1;
        _rightPole = rightPole.node;
    }

    override public function deactivate():void{
        super.deactivate();
        _particles.emit = false;
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).removeChild(_particles.node);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).removeChild(_leftPole);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).removeChild(_rightPole);
        _collider.space = null;
        node.core.onUpdate.remove(update);
        _sfx.cleanup();
    }

    override protected function update(dt:Number):void{
        super.update(dt);
        if(node.parent != null){
            if(!_paused){
                _elapsed += dt;
                if(_elapsed >= GameConstants.ELECTRIC_EMIT_TIME){
                    _particles.emit = !_particles.emit;
                    _elapsed = 0;
                    if(_particles.emit){
                        _collider.space = _space;
                    }else{
                        _collider.space = null;
                    }
                }
            }
            _sfx.updateSound(dt, node.transform.y, _particles.emit);
        }
    }

    override protected function setBonus():void {

    }

    override public function activate():void{
        super.activate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_particles.node);
        _particles.node.transform.x = x;
        _particles.node.transform.y = y - (GameConstants.TILE_SIZE);
        _particles.emit = true;
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_leftPole);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_rightPole);
        _leftPole.transform.setPosition(x - (width / 2) + (GameConstants.TILE_SIZE / 2), y - GameConstants.TILE_SIZE + 4);
        _rightPole.transform.setPosition(x + (width / 2) - (GameConstants.TILE_SIZE / 2), y - GameConstants.TILE_SIZE + 4);
        _collider.space = _space;
        _collider.position = Vec2.weak(x, y - GameConstants.TILE_SIZE);
        node.core.onUpdate.add(update);
    }
}
}
