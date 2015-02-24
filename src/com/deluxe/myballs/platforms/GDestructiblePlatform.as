/**
 * Created by lvdeluxe on 15-02-05.
 */
package com.deluxe.myballs.platforms {

import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.SoundManager;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.particles.ExplodeParticles;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;

import nape.phys.Body;

import nape.shape.Polygon;
import nape.shape.Shape;

public class GDestructiblePlatform extends GPlatform{

	private var _view:GSprite;
    public var index:uint;
    public var totalWidth:Number;
    private var _collideWithBall:Boolean = false;
    private var _shakeTime:Number = 1000;
    private var _elapsed:Number = 0;
    private var _posX:Number;
    private var _posY:Number;
    private var _positionOffset:uint = 4;
    public var group:int = -1;
    private var _particles:ExplodeParticles;
    private var _exploded:Boolean = false;
    private var _gamePaused:Boolean = false;


	public function GDestructiblePlatform() {
        super();
        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _gamePaused = pPaused;
    }

	override public function init():void{
		super.init();
        _particles = GNodeFactory.createNodeWithComponent(ExplodeParticles) as ExplodeParticles;
	}

    override protected function setView():void{
        _view = node.addComponent(GSprite) as GSprite;
        _view.textureId = "atlas_platform_destructible.jpg";
    }

    override public function deactivate():void{
        super.deactivate();
        group = -1;
        _particles.setActive(false);
        _particles.emit = false;
        if(_particles.node.parent != null)
            _particles.node.parent.removeChild(_particles.node);
        cleanup();
    }

    private function cleanup():void{
        GameSignals.DESTRUCT_EXPLODE.remove(onExplode);
        GameSignals.DESTRUCT_COLLISION.remove(onCollision);
        node.core.onUpdate.remove(update);
    }

    override public function activate():void{
        super.activate();
        _particles.setActive(true);
        _elapsed = 0;
        node.core.onUpdate.add(update);
        var visible:Boolean = index == (totalWidth / GameConstants.TILE_SIZE) - 1;
        _shadow.getChildAt(0).setActive(visible);
        _shadow.getChildAt(0).transform.visible = visible;
        GameSignals.DESTRUCT_EXPLODE.add(onExplode);
        GameSignals.DESTRUCT_COLLISION.add(onCollision);
        _posX = x;
        _posY = y;
    }

    private function onExplode(pIndex:uint, pGroup:uint):void{
        if(pIndex != index){
            if(index == pIndex -1 && pGroup == group){
                _shadow.getChildAt(0).setActive(true);
                _shadow.getChildAt(0).transform.visible = true;
            }
        }
    }

    private function onCollision(pBody:Body):void{
        if(pBody == _body){
            GameSignals.DESTRUCT_COLLISION.remove(onCollision);
            _collideWithBall = true;
        }
    }

    override protected function update(dt:Number):void{
        if(!_gamePaused){
            node.transform.setPosition(_body.position.x, _body.position.y);
            if(_collideWithBall){
                if(_elapsed < _shakeTime){
                    _body.position.x = _posX + Math.floor(Math.random() * _positionOffset);
                    _body.position.y = _posY + Math.floor(Math.random() * _positionOffset);
                    _elapsed += dt;
                }else{
                    _exploded = true;
                    _collideWithBall = false;
                    GameSignals.DESTRUCT_EXPLODE.dispatch(index, group);
                    _particles.node.transform.setPosition(node.transform.x, node.transform.y);
                    Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(_particles.node);
                    SoundManager.playExplosionSfx();
                    _particles.emit = true;
                    if(node.parent)
                        node.parent.removeChild(node);
                    _body.space = null;
                }
            }
        }
    }

	override public function get width():Number{
		return GameConstants.TILE_SIZE;
	}

	override protected function getRandomWidth():Number{
		return GameConstants.TILE_SIZE;
	}

    override protected function setShadow():void{
        _shadow = GNodeFactory.createNode("shadow");

        var shadow1:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        shadow1.texture = AssetsManager.getShadowDestructTexture();

        var shadow2:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        shadow2.texture = AssetsManager.getShadowDestructEndTexture();
        shadow2.node.transform.x = GameConstants.TILE_SIZE / 2;
        _shadow.addChild(shadow2.node);

        _shadow.addChild(shadow1.node);

        _shadow.transform.setPosition(GameConstants.TILE_SIZE / 2,GameConstants.TILE_SIZE / 2);

        node.addChild(_shadow);
    }

	override protected function getShape():Shape{
		_width = getRandomWidth();
		var shape:Shape = new Polygon(Polygon.box(GameConstants.TILE_SIZE,GameConstants.TILE_SIZE,true));
		shape.material = getMaterial();
        shape.cbTypes.add(NapeCollisionTypes.DESTRUCTIBLE_COLLISION);
        shape.cbTypes.add(NapeCollisionTypes.PLATFORM_COLLISION);
		return shape;
	}
}
}
