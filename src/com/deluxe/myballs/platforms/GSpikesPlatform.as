/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.platforms {
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.game.GSpike;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

public class GSpikesPlatform extends GPlatform {

    private var _spikes:Vector.<GSpike> = new Vector.<GSpike>();

    public function GSpikesPlatform() {
        super();
    }

    override public function init():void{
        super.init();
        setSpikes();
    }

    private function setSpikes():void {
        var numSpikes:uint = Math.floor((width / GameConstants.TILE_SIZE) / 3) - 1;
        for (var i:int = 0; i < numSpikes ; i++) {
            var spike:GSpike = GNodeFactory.createNodeWithComponent(GSpike) as GSpike;
            _spikes.push(spike);
        }
    }

    override protected function update(dt:Number):void{
        super.update(dt);

    }

    override public function deactivate():void{
        super.deactivate();
        for (var i:int = 0; i < _spikes.length; i++) {
            var s:GSpike = _spikes[i];
            Genome2D.getInstance().root.removeChild(s.node);
            s.deactivate();
        }
    }

    override protected function setBonus():void {

    }

    override public function activate():void{
        super.activate();
        var steps:uint = Math.floor(width / (_spikes.length + 1));
        var startX:Number = x - (width / 2) + steps;
        for (var i:int = 0; i < _spikes.length; i++) {
            var s:GSpike = _spikes[i];
            s.x = startX;
            s.y = y - s.height;
            Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(s.node);
            s.activate();
            startX += steps;
        }
    }
}
}
