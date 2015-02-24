/**
 * Created by lvdeluxe on 15-02-01.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.*;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.particles.BallParticles;
import com.deluxe.myballs.particles.OrbParticles;
import com.deluxe.myballs.particles.ParticlesFactory;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

import nape.callbacks.InteractionCallback;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Shape;

public class GBall extends NapeComponent{

    private var _particles:BallParticles;
    private var _collideWithPlatfom:Boolean = false;
    private var _inivicibilityParticles:OrbParticles;

	public function GBall() {
		super();
	}

    override protected function getMaterial():Material {
        var m:Material = new Material(0.5,1.0,1.4,1.5,0.01);
        return m;
    }

	override protected function getShape():Shape{
		var shape:Shape = new Circle(GameConstants.TILE_SIZE / 2);
		shape.cbTypes.add(NapeCollisionTypes.BALL_COLLISION);
        shape.material = getMaterial();
		return shape;
	}

    override protected function update(dt:Number):void{
        super.update(dt);
        if(_inivicibilityParticles != null){
            _inivicibilityParticles.node.transform.setPosition(x,y);
            _inivicibilityParticles.node.transform.rotation = rotation;
        }
    }

    override public function init():void{
        super.init();
        _body.space = _space;
        _particles = GNodeFactory.createNodeWithComponent(BallParticles) as BallParticles;
        _inivicibilityParticles = ParticlesFactory.triggerIndestructBonusParticles();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(_particles.node);
        GameSignals.PLATFORM_START_COLLISION.add(onPlatformStartCollision);
        GameSignals.PLATFORM_END_COLLISION.add(onPlatformEndCollision);
        GameSignals.BALL_INVINCIBILITY_START.add(onInvincibilityStart);
        GameSignals.BALL_INVINCIBILITY_END.add(onInvincibilityEnd);
     }

    private function onInvincibilityEnd():void{
        _inivicibilityParticles.emit = false;
    }

    private function onInvincibilityStart():void{
        _inivicibilityParticles.emit = true;
    }

    private function onPlatformEndCollision(cb:InteractionCallback):void {
        _collideWithPlatfom = false;
    }
    private function onPlatformStartCollision(cb:InteractionCallback):void {
        SoundManager.playBounceSfx();
        _collideWithPlatfom = true;
        var pos:Vec2 = cb.arbiters.at(0).collisionArbiter.contacts.at(0).position;
        if(_body.velocity.y < -20 && _particles.emit == false){
            _particles.node.transform.setPosition(pos.x, pos.y);
            _particles.emit = true;
        }
    }

	public function get body():Body{
		return _body;
	}

	override protected function getBodyType():BodyType{
		return BodyType.DYNAMIC;
	}

    public function prepareForKill():void{
        _body.space = null;
        node.core.onUpdate.remove(update);
    }

    public function jump():void {
        if(_collideWithPlatfom){
            _body.applyImpulse(Vec2.weak(_body.velocity.x / 10,-500));
        }
    }
}
}
