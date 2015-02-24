/**
 * Created by lvdeluxe on 15-02-06.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.*;

import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.particles.BonusStarsParticles;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;
import com.greensock.TweenLite;
import com.greensock.easing.Quad;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.shape.Shape;

public class GStar extends NapeComponent{

	private var _view:GSprite;
    private var _bonusParticles:BonusStarsParticles;

    private static var _IS_BONUS:Boolean = false;

	public function GStar() {
		super();
	}

	private function onStarCollect(pBody:Body):void {
		if(pBody == _body){
            animate();
            SoundManager.playCollectSfx();
            _bonusParticles.emit = false;
		}
	}

    private function animate():void{
        _body.space = null;
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(node);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.UI_LAYER).getChildAt(1).addChild(node);
        var newY:Number = (node.transform.y - Genome2D.getInstance().root.getChildAt(GNodeLayers.UI_LAYER).transform.y);
        var newX:Number = (node.transform.x - Genome2D.getInstance().root.getChildAt(GNodeLayers.UI_LAYER).transform.x);
        node.transform.y = newY;
        node.transform.x = newX;
        TweenLite.to(node.transform, 0.5, {x: - (GameConstants.SCREEN_WIDTH / 2) + (GameConstants.TILE_SIZE * 2), y: - (GameConstants.SCREEN_HEIGHT / 2) + GameConstants.TILE_SIZE, ease:Quad.easeOut, onComplete:onAnimComplete});
    }

    private function onAnimComplete():void{
        GameSignals.UPDATE_NUM_STARS.dispatch();
        SoundManager.playStarSfx();
        deactivate();
    }

	override public function activate():void{
		super.activate();
        _bonusParticles.node.transform.setPosition(x,y - 2);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(_bonusParticles.node);
        _bonusParticles.emit = _IS_BONUS;
		GameSignals.COLLECT_STAR.add(onStarCollect);
		GameSignals.STAR_BONUS_START.add(onBonusStart);
		GameSignals.STAR_BONUS_END.add(onBonusEnd);
	}

    private function onBonusStart():void{
        _IS_BONUS = true;
        _bonusParticles.emit = true;
    }

    private function onBonusEnd():void{
        _IS_BONUS = false;
        _bonusParticles.emit = false;
    }

	override public function deactivate():void{
		super.deactivate();
		GameSignals.COLLECT_STAR.remove(onStarCollect);
        GameSignals.STAR_BONUS_START.remove(onBonusStart);
        GameSignals.STAR_BONUS_END.remove(onBonusEnd);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(_bonusParticles.node);
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
        _bonusParticles = GNodeFactory.createNodeWithComponent(BonusStarsParticles) as BonusStarsParticles;
	}
}
}
