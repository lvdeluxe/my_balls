/**
 * Created by lvdeluxe on 15-01-30.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.physics.NapeComponent;

import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Shape;

public class GWall extends NapeComponent{

	public function GWall() {
		super();
	}

	override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(GameConstants.TILE_SIZE,GameConstants.SCREEN_HEIGHT,true));
        shape.material = getMaterial();
		return shape
	}

    override protected function setCollisionGroup():void {
        _body.shapes.at(0).filter.collisionGroup = 4;
    }


    override public function init():void{
        super.init();
        _body.space = _space;
    }

    override protected function getMaterial():Material {
        return Material.steel();
    }

//	override protected function update(dt:Number):void{
//		node.transform.setPosition(_body.position.x,_body.position.y);
//	}

	override protected function getBodyType():BodyType{
		return BodyType.KINEMATIC;
	}
}
}
