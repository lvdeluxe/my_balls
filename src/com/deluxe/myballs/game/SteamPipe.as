/**
 * Created by lvdeluxe on 15-03-28.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.components.renderables.GSprite;

import nape.shape.Polygon;
import nape.shape.Shape;

public class SteamPipe extends NapeComponent{

    private var _view:GSprite;

    public function SteamPipe() {
        super();
    }

    override public function init():void{
        super.init();
        _view = node.addComponent(GSprite) as GSprite;
    }

    private function get width():Number{
        return AssetsManager.getHorizontalSteamPipeTexture().width;
    }

    override public function activate():void{
        super.activate();
        if(_view.texture == null)
            _view.texture = AssetsManager.getHorizontalSteamPipeTexture();
    }

    override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(width,GameConstants.TILE_SIZE,true));
        shape.material = getMaterial();
        shape.cbTypes.add(NapeCollisionTypes.PLATFORM_COLLISION);
        return shape;
    }
}
}
