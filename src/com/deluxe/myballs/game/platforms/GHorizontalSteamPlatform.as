/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game.platforms {
import com.deluxe.myballs.audio.SpatialSound;
import com.deluxe.myballs.game.HorizontalSteam;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

public class GHorizontalSteamPlatform extends GPlatform {

    private var _arrow:HorizontalSteam;

    public function GHorizontalSteamPlatform() {
        super();
    }

    override public function init():void{
        super.init();
        setArrow();
    }

    private function setArrow():void {
        _arrow = GNodeFactory.createNodeWithComponent(HorizontalSteam) as HorizontalSteam;
    }

    override public function deactivate():void{
        super.deactivate();
        _arrow.deactivate();
    }

    override protected function getRandomWidth():Number{
        var minWidthUnits:uint = int(GameConstants.SCREEN_WIDTH * 0.65 / GameConstants.TILE_SIZE);
        var maxWidthUnits:Number = ((GameConstants.SCREEN_WIDTH) - (GameConstants.TILE_SIZE * 5)) / GameConstants.TILE_SIZE;
        var randomUnits:uint = minWidthUnits + Math.floor(Math.random() * (maxWidthUnits - minWidthUnits)) ;
        return randomUnits * GameConstants.TILE_SIZE;
    }

    override protected function setBonus():void {

    }

    override public function activate():void{
        super.activate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_arrow.node);
        _arrow.y = y - (GameConstants.TILE_SIZE * 1.5);
        _arrow.activate();
    }
}
}
