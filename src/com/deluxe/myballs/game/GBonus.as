/**
 * Created by lvdeluxe on 15-02-14.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.components.renderables.GSprite;

import nape.phys.Body;

import nape.shape.Polygon;

import nape.shape.Shape;

public class GBonus extends NapeComponent{

    private var _view:GSprite;

    public function GBonus() {
        super();
    }

    override public function init():void{
        super.init();
        setView();
        activate();
    }

    private function onCollectBonus(pBonus:Body, pBall:Body):void {
        if(pBonus == _body){
            deactivate();
        }
    }

    override public function deactivate():void{
        super.deactivate();
        GameSignals.COLLECT_BONUS.remove(onCollectBonus);
    }

    override public function activate():void{
        super.activate();
        GameSignals.COLLECT_BONUS.add(onCollectBonus);
    }


    private function setView():void{
        _view = node.addComponent(GSprite) as GSprite;
        _view.texture = AssetsManager.getBonusTexture();
    }

    override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(32,32,true));
        shape.material = getMaterial();
        shape.sensorEnabled = true;
        shape.cbTypes.add(NapeCollisionTypes.BONUS_COLLISION);
        return shape;
    }
}
}
