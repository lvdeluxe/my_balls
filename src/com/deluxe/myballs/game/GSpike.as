/**
 * Created by lvdeluxe on 15-02-06.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.textures.GTexture;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.shape.Shape;

public class GSpike extends NapeComponent{

	private var _view:GSprite;
    private var _texture:GTexture;

	public function GSpike() {
        _texture = AssetsManager.getSpikesParticles();
        super();
	}

	private function onCollision(pBody:Body):void {
		if(pBody == _body){
			trace("spike collision");
		}
	}

	override public function activate():void{
		super.activate();
		GameSignals.SPIKES_COLLISION.add(onCollision);
	}

	override public function deactivate():void{
		super.deactivate();
        GameSignals.SPIKES_COLLISION.remove(onCollision);
	}

	override protected function getShape():Shape{
		var shape:Shape = new Polygon(Polygon.box(GameConstants.TILE_SIZE,height,true));
		shape.material = getMaterial();
		shape.sensorEnabled = true;
		shape.cbTypes.add(NapeCollisionTypes.SPIKES_COLLISION);
		return shape;
	}

    public function get height():Number{
        return _texture.height;
    }

	override public function init():void{
		super.init();
		_view = node.addComponent(GSprite) as GSprite;
		_view.texture = _texture;
	}
}
}
