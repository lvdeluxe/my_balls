/**
 * Created by lvdeluxe on 15-02-14.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.components.renderables.GSprite;

import nape.geom.Vec2;

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

    private function onCollectBonus(pos:Vec2, pBonus:Body):void {
        if(pBonus == _body){
            deactivate();
        }
    }

    override protected function setCollisionGroup():void {
        _body.shapes.at(0).filter.collisionGroup = 2;
        _body.shapes.at(0).filter.sensorGroup = 2;
    }

    override public function deactivate():void{
        super.deactivate();
        GameSignals.COLLECTED_BONUS.remove(onCollectBonus);
    }

    override public function activate():void{
        super.activate();
        GameSignals.COLLECTED_BONUS.add(onCollectBonus);
    }


    private function setView():void{
        _view = node.addComponent(GSprite) as GSprite;
        _view.texture = AssetsManager.getBonusTexture();
    }

    override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(AssetsManager.getBonusTexture().width,AssetsManager.getBonusTexture().height,true));
        shape.material = getMaterial();
        shape.sensorEnabled = true;
        shape.cbTypes.add(NapeCollisionTypes.BONUS_COLLISION);
        return shape;
    }
}
}
