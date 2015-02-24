/**
 * Created by lvdeluxe on 15-02-07.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.components.renderables.GSprite;
import com.greensock.TweenLite;
import com.greensock.easing.Linear;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.shape.Shape;

public class GCritter extends NapeComponent{

    private var _view:GSprite;
    public var distance:Number;
    private var _direction:int;
    private var _speed:Number = 1 + Math.random();

    public function GCritter() {
        super();
    }

    override public function init():void{
        super.init();
        _view = node.addComponent(GSprite) as GSprite;
        _view.texture = AssetsManager.getCritterTexture();
    }

    private function onCollision(pBody:Body):void{
        if(pBody == _body){
            trace("contact");
        }
    }

    override public function activate():void{
        super.activate();
        _direction = Math.random() > 0.5 ? -1 : 1;
        x += (distance / 2) * _direction;
        node.transform.scaleX = _direction < 0 ? 1 : -1;
        GameSignals.CRITTER_COLLISION.add(onCollision);
        TweenLite.to(this,_speed,{x:x - (distance * _direction), ease:Linear.easeNone, onComplete:onTweenComplete});
    }

    private function onTweenComplete():void{
        _direction *= -1;
        node.transform.scaleX = _direction < 0 ? 1 : -1;
        TweenLite.to(this,_speed,{x:x - (distance * _direction), ease:Linear.easeNone, onComplete:onTweenComplete});
    }

    override public function deactivate():void{
        super.deactivate();
        TweenLite.killTweensOf(this);
        GameSignals.ARROW_COLLISION.remove(onCollision);
    }

    override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(GameConstants.TILE_SIZE,GameConstants.TILE_SIZE,true));
        shape.material = getMaterial();
        shape.sensorEnabled = true;
        shape.cbTypes.add(NapeCollisionTypes.CRITTER_COLLISION);
        return shape;
    }
}
}
