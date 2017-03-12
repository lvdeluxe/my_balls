/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game.platforms {
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.audio.SpatialSound;
import com.deluxe.myballs.game.GVerticalSteam;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

public class GVerticalSteamPlatform extends GPlatform {

    private var _spikes:Vector.<GVerticalSteam> = new Vector.<GVerticalSteam>();
    private var _sound:SpatialSound;
    private var _elapsed:Number = 0;
    private var _paused:Boolean = false;

    public function GVerticalSteamPlatform() {
        super();
    }

    override public function init():void{
        super.init();
        setSpikes();
        _sound = new SpatialSound(SoundManager.getSteamSound());
        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _paused = pPaused;
    }

    private function setSpikes():void {
        var numSpikes:uint = Math.ceil(Math.random() * 3);//Math.min(Math.floor((width / GameConstants.TILE_SIZE) / 3) - 1, 3);
        for (var i:int = 0; i < numSpikes ; i++) {
            var spike:GVerticalSteam = GNodeFactory.createNodeWithComponent(GVerticalSteam) as GVerticalSteam;
            _spikes.push(spike);
        }
    }


    override protected function update(dt:Number):void{
        super.update(dt);
        if(node.parent != null){
            if(!_paused){
                _elapsed += dt;
                if(_elapsed >= GameConstants.STEAM_EMIT_TIME){
                    for (var i:int = 0; i < _spikes.length; i++) {
                        var s:GVerticalSteam = _spikes[i];
                        s.steamParticles.emit = !s.steamParticles.emit;
                        s.body.space = s.steamParticles.emit ? _space : null;
                    }
                    _elapsed = 0;

                }
                _sound.updateSound(dt, node.transform.y, _spikes[0].steamParticles.emit);
            }
        }
    }

    override public function deactivate():void{
        super.deactivate();
        node.core.onUpdate.remove(update);
        for (var i:int = 0; i < _spikes.length; i++) {
            var s:GVerticalSteam = _spikes[i];
            s.deactivate();
        }
        _sound.cleanup();
    }

    override protected function setBonus():void {

    }

    override public function activate():void{
        super.activate();
        node.core.onUpdate.add(update);
        var steps:uint = Math.floor(width / (_spikes.length + 1));
        var startX:Number = x - (width / 2) + steps;
        for (var i:int = 0; i < _spikes.length; i++) {
            var s:GVerticalSteam = _spikes[i];
            s.x = startX;
            s.y = y - (GameConstants.TILE_SIZE / 2);
            s.activate();
            startX += steps;
        }
    }
}
}
