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

public class GUpperWall extends NapeComponent{

	public function GUpperWall() {
		super();
	}

	override protected function getShape():Shape{
        var shape:Shape = new Polygon(Polygon.box(GameConstants.SCREEN_WIDTH,GameConstants.TILE_SIZE,true));
        shape.material = getMaterial();
		return shape
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
