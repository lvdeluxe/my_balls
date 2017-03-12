/**
 * Created by lvdeluxe on 15-02-01.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.particles.BallImpactParticles;
import com.deluxe.myballs.particles.BallParticles;
import com.deluxe.myballs.particles.InvincibilityParticles;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;

import nape.callbacks.InteractionCallback;
import nape.geom.Geom;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Shape;

public class GBall extends NapeComponent{

    private var _particles:BallParticles;
    private var _collideWithPlatfom:Boolean = false;
    private var _invincibilityParticles:InvincibilityParticles;
    private var _isMainBall:Boolean = false;
    private var _view:GSprite;
    private var _collideWithElectric:Boolean = false;
    private var _collideWithSteam:Boolean = false;
    private var _jumpMultiplier:Number = 1;
    private var _steamCollisionTime:Number = 0;
    private var _electricCollisionTime:Number = 0;
    private var _paused:Boolean = false;
    private var _impactParticles:BallImpactParticles;

	public function GBall() {
		super();
	}

    private function onSteamCollision(pBody:Body, pStart:Boolean):void{
        if(pBody == _body){
            if(pStart){
                GameSignals.UPDATE_BALL_DAMAGE.dispatch(1);
                _collideWithSteam = true;
                _steamCollisionTime = 0;
            }else{
                _collideWithSteam = false;
            }
        }
    }

    private function onCoilCollision(cb:InteractionCallback):void{
        if(!_paused && !_invincibilityParticles.emit && _isMainBall){

                var impulseVector:Vec2 = cb.arbiters.at(0).collisionArbiter.normal.copy(false);
                impulseVector.x *= GameConstants.COIL_IMPULSE;
                impulseVector.y *= GameConstants.COIL_IMPULSE;
                _body.applyImpulse(impulseVector);
                SoundManager.playHitByCoilSfx();
                GameSignals.UPDATE_BALL_DAMAGE.dispatch(GameConstants.COIL_DAMAGE);
            if(cb.arbiters.length > 0) {
                var impactPos:Vec2 = cb.arbiters.at(0).collisionArbiter.contacts.at(0).position;
                _impactParticles.node.transform.setPosition(impactPos.x, impactPos.y);
                _impactParticles.emit = true;
            }
        }
    }

    private function onGearCollision(cb:InteractionCallback):void{
        if(!_paused && !_invincibilityParticles.emit && _isMainBall){

                var impulseVector:Vec2 = cb.arbiters.at(0).collisionArbiter.normal.copy(false);
                impulseVector.x *= GameConstants.CRITTER_IMPULSE;
                impulseVector.y *= GameConstants.CRITTER_IMPULSE;
                _body.applyImpulse(impulseVector);
                SoundManager.playHitByGearSfx();
                GameSignals.UPDATE_BALL_DAMAGE.dispatch(GameConstants.GEAR_DAMAGE);
            if(cb.arbiters.length > 0){
                var impactPos:Vec2 = cb.arbiters.at(0).collisionArbiter.contacts.at(0).position;
                _impactParticles.node.transform.setPosition(impactPos.x,impactPos.y);
                _impactParticles.emit = true;
            }
        }
    }

    private function onExplode(pBody:Body, pIndex:uint, pGroup:uint):void{
        if(!_paused && !_invincibilityParticles.emit && _isMainBall){
            var dist:Number = Geom.distanceBody(pBody, _body, Vec2.get(), Vec2.get());
            if(dist < GameConstants.EXPLOSION_RADIUS * GameConstants.ASSETS_SCALE){
                var impulseVector:Vec2 = Vec2.weak(_body.position.x - pBody.position.x, _body.position.y - pBody.position.y);
                impulseVector = impulseVector.normalise();
                var ratio:Number = (1 - (dist / GameConstants.EXPLOSION_RADIUS));
                impulseVector.x *= ratio * GameConstants.EXPLOSION_FORCE_X;
                impulseVector.y *= ratio * GameConstants.EXPLOSION_FORCE_Y;
                _body.applyImpulse(impulseVector);
                var damage:Number = int(ratio * GameConstants.EXPLOSION_DAMAGE);
                if(damage>0)
                    GameSignals.UPDATE_BALL_DAMAGE.dispatch(damage);
            }
        }
    }

    private function onElectricCollision(pBody:Body, pStart:Boolean):void{
        if(!_paused && !_invincibilityParticles.emit && _isMainBall){
            if(pStart){
                GameSignals.UPDATE_BALL_DAMAGE.dispatch(1);
                _collideWithElectric = true;
                _electricCollisionTime = 0;
            }else{
                _collideWithElectric = false;
            }
        }
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
        if(!_paused && !_invincibilityParticles.emit && _isMainBall){
            if(_collideWithElectric){
                _electricCollisionTime += dt;
                if(_electricCollisionTime >= GameConstants.ELECTRIC_DAMAGE_TIME){
                    GameSignals.UPDATE_BALL_DAMAGE.dispatch(1);
                    _electricCollisionTime = 0;
                }
            }else if(_collideWithSteam){
                _steamCollisionTime += dt;
                if(_steamCollisionTime >= GameConstants.STEAM_DAMAGE_TIME){
                    GameSignals.UPDATE_BALL_DAMAGE.dispatch(1);
                    _steamCollisionTime = 0;
                }
            }
        }
    }

    public function updateColor(prct:Number):void{
        if(_isMainBall){
            node.transform.green = prct;
            node.transform.blue = prct;
        }
    }

    override public function init():void{
        super.init();
        _view = node.addComponent(GSprite) as GSprite;
        _view.texture = AssetsManager.getBallTexture();
        _body.space = _space;
        _particles = GNodeFactory.createNodeWithComponent(BallParticles) as BallParticles;
        _invincibilityParticles = GNodeFactory.createNodeWithComponent(InvincibilityParticles) as InvincibilityParticles;
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(_particles.node);
        node.addChild(_invincibilityParticles.node);

     }

    private function onInvincibilityEnd():void{
        _invincibilityParticles.emit = false;
    }

    private function onInvincibilityStart():void{
        _invincibilityParticles.emit = true;
    }

    private function onPlatformStartCollision(cb:InteractionCallback, pStart:Boolean):void {
        if(pStart){
            if(_isMainBall && cb.int2.castShape.body == _body){
                SoundManager.playBounceSfx(Math.abs(_body.velocity.y));
                _collideWithPlatfom = true;
                var pos:Vec2 = cb.arbiters.at(0).collisionArbiter.contacts.at(0).position;
                if(_body.velocity.y < -20 && _particles.emit == false){
                    _particles.node.transform.setPosition(pos.x, pos.y);
                    _particles.emit = true;
                }
            }
        }else{
            if(_isMainBall && cb.int2.castShape.body == _body){
                _collideWithPlatfom = false;
            }
        }
    }

	public function get body():Body{
		return _body;
	}

    private function onGravityBonusStart():void{
        _jumpMultiplier = GameConstants.JUMP_MULTIPLIER;
        //_body.mass = GameConstants.MASS_BONUS;
    }
    private function onGravityBonusEnd():void{
        _jumpMultiplier = 1;
        //_body.mass = 1.2063715789784806;
    }

    private function onCollectBonus(pBonus:Body):void {
        if(_isMainBall){
            GameSignals.COLLECTED_BONUS.dispatch(_body.position, pBonus);
        }
    }

	override protected function getBodyType():BodyType{
		return BodyType.DYNAMIC;
	}

    private function onPause(pPaused:Boolean):void{
        _paused = pPaused;
    }

    public function prepareForKill():void{
        _body.space = null;
        GameSignals.ELECTRIC_COLLISION.remove(onElectricCollision);
        GameSignals.DESTRUCT_EXPLODE.remove(onExplode);
        GameSignals.STEAM_COLLISION.remove(onSteamCollision);
        GameSignals.PLATFORM_COLLISION.remove(onPlatformStartCollision);
        GameSignals.INVINCIBILITY_BONUS_START.remove(onInvincibilityStart);
        GameSignals.BALL_INVINCIBILITY_END.remove(onInvincibilityEnd);
        GameSignals.GRAVITY_BONUS_START.remove(onGravityBonusStart);
        GameSignals.GRAVITY_BONUS_END.remove(onGravityBonusEnd);
        GameSignals.CRITTER_COLLISION.remove(onGearCollision);
        GameSignals.COIL_COLLISION.remove(onCoilCollision);
        GameSignals.COLLECT_BONUS.remove(onCollectBonus);
        GameSignals.PAUSE.remove(onPause);
        _particles.dispose();
        _invincibilityParticles.dispose();
        _impactParticles.dispose();
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(_particles.node);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(_invincibilityParticles.node);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(_impactParticles.node);
        node.core.onUpdate.remove(update);
    }

    public function jump():void {
        if(_collideWithPlatfom){
            _body.applyImpulse(Vec2.weak(_body.velocity.x / GameConstants.JUMP_FACTOR * _jumpMultiplier, -GameConstants.JUMP_HEIGHT * _jumpMultiplier * GameConstants.ASSETS_SCALE));
        }
    }

    override protected function setCollisionGroup():void {
        _body.shapes.at(0).filter.collisionGroup = 4;
    }

    public function set isMainBall(value:Boolean):void {
        _isMainBall = value;
        if(value){
            GameSignals.ELECTRIC_COLLISION.add(onElectricCollision);
            GameSignals.DESTRUCT_EXPLODE.add(onExplode);
            GameSignals.STEAM_COLLISION.add(onSteamCollision);
            GameSignals.PLATFORM_COLLISION.add(onPlatformStartCollision);
            GameSignals.INVINCIBILITY_BONUS_START.add(onInvincibilityStart);
            GameSignals.BALL_INVINCIBILITY_END.add(onInvincibilityEnd);
            GameSignals.GRAVITY_BONUS_START.add(onGravityBonusStart);
            GameSignals.GRAVITY_BONUS_END.add(onGravityBonusEnd);
            GameSignals.CRITTER_COLLISION.add(onGearCollision);
            GameSignals.COIL_COLLISION.add(onCoilCollision);
            GameSignals.COLLECT_BONUS.add(onCollectBonus);
            GameSignals.PAUSE.add(onPause);
            _impactParticles = GNodeFactory.createNodeWithComponent(BallImpactParticles) as BallImpactParticles;
            Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(_impactParticles.node);
            _body.mass = 1.2063715789784806;
            _body.inertia = 0.001;
            _body.shapes.at(0).filter.collisionMask = ~0;
            _body.shapes.at(0).filter.sensorMask = ~0;
            node.transform.alpha = 1;
        }else{
            _body.mass = 0.001;
            _body.inertia = 0.001;
            _body.shapes.at(0).filter.collisionMask = ~2;
            _body.shapes.at(0).filter.sensorMask = ~2;
        }

    }
}
}
