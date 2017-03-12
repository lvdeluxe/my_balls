/**
 * Created by lvdeluxe on 15-02-06.
 */
package com.deluxe.myballs.game {
import aze.motion.easing.Quadratic;
import aze.motion.eaze;

import com.deluxe.myballs.*;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.shape.Shape;

public class GStar extends NapeComponent{

	private var _view:GSprite;
	public var angle:Number = 0;

	private var _radius:Number = 5;
	private var _speed:Number = 0.05;
	private var _doOscillate:Boolean = true;

    public static var IS_BONUS:Boolean = false;

	public function GStar() {
		super();
		_radius = 5 * GameConstants.ASSETS_SCALE;
	}

	private function onStarCollect(pBody:Body):void {
		if(pBody == _body){
            animate();
            SoundManager.playCollectSfx();
		}
	}

	public function oscillate(pY:Number):void{
		if(_doOscillate) {
			y = (pY) - GameConstants.TILE_SIZE + Math.cos(angle) * _radius;
			angle += _speed;
		}
	}

    private function animate():void{
		_doOscillate = false;
        _body.space = null;
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(node);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.UI_LAYER).getChildAt(1).addChild(node);
        var newY:Number = (node.transform.y - Genome2D.getInstance().root.getChildAt(GNodeLayers.UI_LAYER).transform.y);
        var newX:Number = (node.transform.x - Genome2D.getInstance().root.getChildAt(GNodeLayers.UI_LAYER).transform.x);
        node.transform.y = newY;
        node.transform.x = newX;
        var posX:Number = -(GameConstants.SCREEN_WIDTH / 2) + (AssetsManager.getStarTexture().width / 2) + (uint(GameConstants.TILE_SIZE / 5) * 2) + GameConstants.TILE_SIZE
        eaze(node.transform).to(0.5, {x: posX, y: - (GameConstants.SCREEN_HEIGHT / 2) + GameConstants.TILE_SIZE}).easing(Quadratic.easeOut).onComplete(onAnimComplete);
    }

    private function onAnimComplete():void{
        GameSignals.UPDATE_NUM_STARS.dispatch();
        SoundManager.playStarSfx();
        deactivate();
    }

	override public function activate():void{
		super.activate();
		_doOscillate = true;
		GameSignals.COLLECT_STAR.add(onStarCollect);
		GameSignals.STAR_BONUS_START.add(onBonusStart);
		GameSignals.STAR_BONUS_END.add(onBonusEnd);
	}

    private function onBonusStart():void{
        IS_BONUS = true;
    }

    private function onBonusEnd():void{
        IS_BONUS = false;
    }

	override public function deactivate():void{
		super.deactivate();
		GameSignals.COLLECT_STAR.remove(onStarCollect);
        GameSignals.STAR_BONUS_START.remove(onBonusStart);
        GameSignals.STAR_BONUS_END.remove(onBonusEnd);
		_doOscillate = false;
	}

	override protected function getShape():Shape{
		var shape:Shape = new Polygon(Polygon.box(GameConstants.TILE_SIZE,GameConstants.TILE_SIZE,true));
		shape.material = getMaterial();
		shape.sensorEnabled = true;
		shape.cbTypes.add(NapeCollisionTypes.STAR_COLLISION);
		return shape;
	}

	override public function init():void{
		super.init();
		_view = node.addComponent(GSprite) as GSprite;
		_view.texture = AssetsManager.getStarTexture();
		deactivate();
	}
}
}
