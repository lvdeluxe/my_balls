/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.platforms {
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.game.GCritter;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

public class GCritterPlatform extends GPlatform {

    private var _critter:GCritter;

    public function GCritterPlatform() {
        super();
    }

    override public function init():void{
        super.init();
        setCritter();
    }

    private function setCritter():void {
        _critter = GNodeFactory.createNodeWithComponent(GCritter) as GCritter;
    }

    override public function deactivate():void{
        super.deactivate();
        _critter.deactivate();
    }

    override protected function setBonus():void {

    }

    override public function activate():void{
        super.activate();
        _critter.distance = width - (GameConstants.TILE_SIZE * 2);
        _critter.x = x;
        _critter.y = y - (GameConstants.TILE_SIZE);
        _critter.activate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_critter.node);
    }
}
}
