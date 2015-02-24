/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.platforms {
import com.deluxe.myballs.game.GArrow;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

public class GArrowPlatform extends GPlatform {

    private var _arrow:GArrow;

    public function GArrowPlatform() {
        super();
    }

    override public function init():void{
        super.init();
        setArrow();
    }

    private function setArrow():void {
        _arrow = GNodeFactory.createNodeWithComponent(GArrow) as GArrow;
    }

    override public function deactivate():void{
        super.deactivate();
        _arrow.deactivate();
    }

    override protected function setBonus():void {

    }

    override public function activate():void{
        super.activate();
        _arrow.activate();
        _arrow.y = y - (GameConstants.TILE_SIZE * 1.5);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_arrow.node);
    }
}
}
