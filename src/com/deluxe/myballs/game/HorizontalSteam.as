/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.audio.SpatialSound;
import com.deluxe.myballs.particles.HorizontalSteamParticles;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

import nape.shape.Polygon;

import nape.shape.Shape;

public class HorizontalSteam extends NapeComponent{

    private static const _LEFT:Number =  GameConstants.TILE_SIZE + 10;
    private static const _RIGHT:int = GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE + 10);

    private var _direction:int;
    private var _pipe:SteamPipe;

//    private var _steamParticles:HorizontalSteamParticles;
    private var _steamParticles:HorizontalSteamParticles;
    private var _elapsed:Number = 0;
    private var _paused:Boolean = false;

    private var _sound:SpatialSound;

    public function HorizontalSteam() {
        super();

        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _paused = pPaused;
    }

    override public function init():void{
        super.init();
        _sound = new SpatialSound(SoundManager.getSteamSound());
        _pipe = GNodeFactory.createNodeWithComponent(SteamPipe) as SteamPipe;
        _steamParticles = node.addComponent(HorizontalSteamParticles) as HorizontalSteamParticles;
//        _steamParticles.texture = AssetsManager.getSteamParticle();
//        _steamParticles.emission = new GCurve(75);
//        _steamParticles.duration = GameConstants.STEAM_EMIT_TIME;
//        _steamParticles.addInitializer(new SteamInitializer());
//        _steamParticles.addAffector(new SteamAffector());
    }

    override protected function update(dt:Number):void{
        super.update(dt);
        if(node.parent != null){
            if(!_paused){
                _elapsed += dt;
                if(_elapsed >= GameConstants.STEAM_EMIT_TIME){
                    _steamParticles.emit = !_steamParticles.emit;
                    _elapsed = 0;
                    _body.space = _steamParticles.emit ? _space : null;
                }
                _sound.updateSound(dt, node.transform.y, _steamParticles.emit);
            }
        }
    }

    override public function activate():void{
        super.activate();
        _direction = Math.random() < 0.5 ? 1 : -1;
        x = _direction > 0 ? _LEFT : _RIGHT;
        node.core.onUpdate.add(update);
        _pipe.x = _direction > 0 ? x - 10 : x + 10;
        _pipe.y = node.transform.y;
        _pipe.node.transform.scaleX = _direction > 0 ? -1 : 1;
        _pipe.activate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.GAME_OVER_LAYER).addChild(_pipe.node);
        rotation = _direction > 0 ? Math.PI / 2 : -Math.PI / 2;
    }

    override public function deactivate():void{
        super.deactivate();
        _pipe.deactivate();
        node.core.onUpdate.remove(update);
        x = _direction > 0 ? _LEFT : _RIGHT;
        rotation = 0;
        _sound.cleanup();
    }

    override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(GameConstants.TILE_SIZE * 0.9,400 * GameConstants.ASSETS_SCALE,true));
        shape.material = getMaterial();
        shape.sensorEnabled = true;
        shape.cbTypes.add(NapeCollisionTypes.STEAM_COLLISION);
        return shape;
    }
}
}
