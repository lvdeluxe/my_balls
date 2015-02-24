/**
 * Created by lvdeluxe on 15-01-29.
 */
package com.deluxe.myballs.physics {
import com.genome2d.Genome2D;
import com.genome2d.components.GComponent;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;

public class NapeComponent extends GComponent{

	protected var _body:Body;
	protected var _space:Space;

	public function NapeComponent() {
		super();
		_body = new Body(getBodyType());
		_body.shapes.add(getShape());
		_space = (Genome2D.getInstance().root.getComponent(GNapePhysics) as GNapePhysics).space;
	}

	override public function init():void{
		super.init();
		if(_body.type == BodyType.DYNAMIC)
			node.core.onUpdate.add(update);
		else
			update(0);
	}

	protected function getMaterial():Material {
		return Material.rubber();
	}

	protected function update(dt:Number):void{
		node.transform.setPosition(_body.position.x, _body.position.y);
		node.transform.rotation = _body.rotation;
	}

	public function get x():Number{
		return _body.position.x;
	}

    public function get rotation():Number{
        return  _body.rotation;
    }
    public function set rotation(value:Number):void{
        _body.rotation = value;
        update(0);
    }

	public function set x(value:Number):void{
		_body.position.x = value;
		update(0);
	}

	public function activate():void{
		_body.space = _space;
        node.setActive(true);
	}

	public function deactivate():void{
		_body.space = null;
		if(node.parent)
			node.parent.removeChild(node);
		node.setActive(false);
	}

	public function get y():Number{
		return _body.position.y;
	}

	public function set y(value:Number):void{
		_body.position.y = value;
		update(0);
	}

	protected function getShape():Shape{
		var shape:Shape = new Polygon(Polygon.box(256,32,true));
		shape.material = getMaterial();
		return shape;
	}



	protected function getBodyType():BodyType{
		return BodyType.KINEMATIC;
	}
}
}
