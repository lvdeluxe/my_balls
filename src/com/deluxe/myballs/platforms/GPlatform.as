/**
 * Created by lvdeluxe on 15-02-05.
 */
package com.deluxe.myballs.platforms {
import com.deluxe.myballs.game.GBonus;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSlice3Sprite;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;

import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Shape;

public class GPlatform extends NapeComponent{

	private var _view:GSlice3Sprite;
	protected var _width:Number;
    protected var _shadow:GNode;
    protected var _bonus:GBonus;

    private var _hasBonus:Boolean = false;

	public function GPlatform() {

	}

	override public function init():void{
		super.init();
        setView();
        setShadow();
	}

    protected function setView():void{
        _view = node.addComponent(GSlice3Sprite) as GSlice3Sprite;
        _view.texture1 = AssetsManager.getPlatformLeftTexture();
        _view.texture2 = AssetsManager.getPlatformCenterTexture();
        _view.texture3 = AssetsManager.getPlatformRightTexture();
        _view.height = GameConstants.TILE_SIZE;
        _view.width = _width;
        setBonus();
    }

    protected function setBonus():void {
        _bonus = GNodeFactory.createNodeWithComponent(GBonus) as GBonus;
    }

	override protected function update(dt:Number):void{
		node.transform.setPosition(_body.position.x - (_body.bounds.width / 2),_body.position.y - (_body.bounds.height / 2));
	}

	public function get width():Number{
		return _width;
	}

	protected function getRandomWidth():Number{
		var minWidthUnits:uint = 8;
		var maxWidthUnits:Number = ((GameConstants.SCREEN_WIDTH / 2) + (GameConstants.TILE_SIZE * 4)) / GameConstants.TILE_SIZE;
		var randomUnits:uint = minWidthUnits + Math.floor(Math.random() * (maxWidthUnits - minWidthUnits)) ;
		return randomUnits * GameConstants.TILE_SIZE;
	}

    protected function setShadow():void{
        var shadow:GSlice3Sprite = GNodeFactory.createNodeWithComponent(GSlice3Sprite) as GSlice3Sprite;
        shadow.texture1 = AssetsManager.getShadowLeftTexture();
        shadow.texture2 = AssetsManager.getShadowCenterTexture();
        shadow.texture3 = AssetsManager.getShadowRightTexture();
        shadow.width = _width + (GameConstants.TILE_SIZE);
        shadow.height = GameConstants.TILE_SIZE * 2;
        _shadow = shadow.node;
        node.addChild(_shadow);
    }

    override public function activate():void{
        _hasBonus = false;
        super.activate();
        _shadow.setActive(true);
        _shadow.transform.visible = true;
    }

    public function activateBonus():void{
        _hasBonus = true;
        _bonus.activate();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_bonus.node);
        _bonus.x = x;
        _bonus.y = y - GameConstants.TILE_SIZE;
    }

    override public function deactivate():void{
        super.deactivate();
        _shadow.setActive(false);
        _shadow.transform.visible = false;
        if(_bonus!= null && _hasBonus){
            Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).removeChild(_bonus.node);
            _bonus.deactivate();
        }
    }

	override protected function getMaterial():Material {
		return Material.glass();
	}

	override protected function getShape():Shape{
		_width = getRandomWidth();
		var shape:Shape = new Polygon(Polygon.box(_width,GameConstants.TILE_SIZE,true));
		shape.material = getMaterial();
        shape.cbTypes.add(NapeCollisionTypes.PLATFORM_COLLISION);
		return shape;
	}
}
}
