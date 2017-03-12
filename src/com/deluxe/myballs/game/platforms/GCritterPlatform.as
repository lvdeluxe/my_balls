/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game.platforms {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.game.GCritter;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSlice3Sprite;
import com.genome2d.components.renderables.GSlice9Sprite;
import com.genome2d.node.factory.GNodeFactory;

public class GCritterPlatform extends GPlatform {

    private var _critter:GCritter;
    private var _wire:GSlice3Sprite;
    private var _wireOffset:Number;

    public function GCritterPlatform() {
        super();
    }

    override public function init():void{
        super.init();
        setWire();
        setCritter();
    }

    private function setWire():void {
        _wire = GNodeFactory.createNodeWithComponent(GSlice3Sprite) as GSlice3Sprite;
    }

    private function setCritter():void {
        _critter = GNodeFactory.createNodeWithComponent(GCritter) as GCritter;
    }

    override public function deactivate():void{
        super.deactivate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.BG_LAYER).removeChild(_wire.node);
        _critter.deactivate();
    }

    override protected function setBonus():void {

    }

    override public function activate():void{
        super.activate();
        if(_wire.texture1 == null){
            _wire.texture1 = AssetsManager.getGearWireLeftTexture();
            _wire.texture2 = AssetsManager.getGearWireCenterTexture();
            _wire.texture3 = AssetsManager.getGearWireRightTexture();
            _wireOffset = (_wire.texture1.height - GameConstants.TILE_SIZE) / 2;
        }

        _critter.distance = width + (_wireOffset * 2);
        _critter.x = x;
        _critter.y = y - (GameConstants.TILE_SIZE / 2) - _wireOffset;
        _critter.setOffset(_wireOffset);
        _critter.activate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.BG_LAYER).addChild(_wire.node);
        _wire.height = _wire.texture1.height;
        _wire.width = width + (_wireOffset * 2);

        _wire.node.transform.setPosition(x - (width / 2) - _wireOffset, y - (GameConstants.TILE_SIZE / 2) - _wireOffset);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_critter.node);
    }
}
}
