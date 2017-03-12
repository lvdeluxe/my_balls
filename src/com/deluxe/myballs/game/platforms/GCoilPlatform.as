/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game.platforms {
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.game.GCoil;
import com.deluxe.myballs.game.GCritter;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

public class GCoilPlatform extends GPlatform {

    private var _coil:GCoil;

    public function GCoilPlatform() {
        super();
    }

    override public function init():void{
        super.init();
        setCritter();
    }

    private function setCritter():void {
        _coil = GNodeFactory.createNodeWithComponent(GCoil) as GCoil;
    }

    override public function deactivate():void{
        super.deactivate();
        _coil.deactivate();
    }

    override protected function setBonus():void {

    }

    override public function activate():void{
        super.activate();
        _coil.distance = width - (GameConstants.TILE_SIZE) * 2;
        _coil.x = x;
        _coil.y = y - (GameConstants.TILE_SIZE);
        _coil.activate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_coil.node);
    }
}
}
