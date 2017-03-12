/**
 * Created by lvdeluxe on 15-01-29.
 */
package com.deluxe.myballs.physics {
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.GComponent;

import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

public class GNapePhysics extends GComponent{

	public var space:Space;
	private var _starToBallListener:InteractionListener;
	private var _steamToBallStartListener:InteractionListener;
	private var _steamToBallEndListener:InteractionListener;
	private var _critterToBallListener:InteractionListener;
	private var _destructToBallListener:InteractionListener;
	private var _platformToBallStartListener:InteractionListener;
	private var _platformToBallEndListener:InteractionListener;
	private var _bonusToBallListener:InteractionListener;
	private var _electricToBallStartListener:InteractionListener;
	private var _electricToBallEndListener:InteractionListener;
	private var _coilToBallEndListener:InteractionListener;
    private var _gamePaused:Boolean = false;

	public function GNapePhysics() {
		super();
		space = new Space(Vec2.weak(0,800 * GameConstants.ASSETS_SCALE));
        setListeners();
        GameSignals.PAUSE.add(onPause);
    }

    private function setListeners():void{
        _starToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.STAR_COLLISION,NapeCollisionTypes.BALL_COLLISION,onStarToBallCollision);
        space.listeners.add(_starToBallListener);
        _steamToBallStartListener=new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.STEAM_COLLISION,NapeCollisionTypes.BALL_COLLISION,onSteamToBallStartCollision);
        space.listeners.add(_steamToBallStartListener);
        _steamToBallEndListener=new InteractionListener(CbEvent.END,InteractionType.SENSOR,NapeCollisionTypes.STEAM_COLLISION,NapeCollisionTypes.BALL_COLLISION,onSteamToBallEndCollision);
        space.listeners.add(_steamToBallEndListener);
        _critterToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,NapeCollisionTypes.CRITTER_COLLISION,NapeCollisionTypes.BALL_COLLISION,onCritterToBallCollision);
        space.listeners.add(_critterToBallListener);
        _destructToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,NapeCollisionTypes.DESTRUCTIBLE_COLLISION,NapeCollisionTypes.BALL_COLLISION,onDestructToBallCollision);
        space.listeners.add(_destructToBallListener);
        _platformToBallStartListener=new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,NapeCollisionTypes.PLATFORM_COLLISION,NapeCollisionTypes.BALL_COLLISION,onPlatformToBallStartCollision);
        space.listeners.add(_platformToBallStartListener);
        _platformToBallEndListener=new InteractionListener(CbEvent.END,InteractionType.COLLISION,NapeCollisionTypes.PLATFORM_COLLISION,NapeCollisionTypes.BALL_COLLISION,onPlatformToBallEndCollision);
        space.listeners.add(_platformToBallEndListener);
        _bonusToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.BONUS_COLLISION,NapeCollisionTypes.BALL_COLLISION,onBonusToBallCollision);
        space.listeners.add(_bonusToBallListener);
        _electricToBallStartListener =new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.ELECTRIC_COLLISION,NapeCollisionTypes.BALL_COLLISION,onElectricToBallStartCollision);
        space.listeners.add(_electricToBallStartListener);
        _electricToBallEndListener =new InteractionListener(CbEvent.END,InteractionType.SENSOR,NapeCollisionTypes.ELECTRIC_COLLISION,NapeCollisionTypes.BALL_COLLISION,onElectricToBallEndCollision);
        space.listeners.add(_electricToBallEndListener);
        _coilToBallEndListener =new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,NapeCollisionTypes.COIL_COLLISION,NapeCollisionTypes.BALL_COLLISION,onCoilToBallStartCollision);
        space.listeners.add(_coilToBallEndListener);
    }

    private function onPause(pPaused:Boolean):void{
        _gamePaused = pPaused;
    }

	private function onCoilToBallStartCollision(cb:InteractionCallback):void{
        GameSignals.COIL_COLLISION.dispatch(cb);
    }

	private function onElectricToBallEndCollision(cb:InteractionCallback):void{
		GameSignals.ELECTRIC_COLLISION.dispatch(cb.int1.castShape.body, false);
	}

	private function onElectricToBallStartCollision(cb:InteractionCallback):void{
		GameSignals.ELECTRIC_COLLISION.dispatch(cb.int1.castShape.body, true);
	}

	private function onBonusToBallCollision(cb:InteractionCallback):void{
		GameSignals.COLLECT_BONUS.dispatch(cb.int1.castShape.body);
	}

	private function onPlatformToBallEndCollision(cb:InteractionCallback):void{
		GameSignals.PLATFORM_COLLISION.dispatch(cb, false);
	}

	private function onPlatformToBallStartCollision(cb:InteractionCallback):void{
		GameSignals.PLATFORM_COLLISION.dispatch(cb, true);
	}

	private function onDestructToBallCollision(cb:InteractionCallback):void{
		GameSignals.DESTRUCT_COLLISION.dispatch(cb.int1.castShape.body);
	}

	private function onStarToBallCollision(cb:InteractionCallback):void{
		GameSignals.COLLECT_STAR.dispatch(cb.int1.castShape.body);
	}

	private function onSteamToBallEndCollision(cb:InteractionCallback):void{
		GameSignals.STEAM_COLLISION.dispatch(cb.int2.castShape.body, false);
	}

	private function onSteamToBallStartCollision(cb:InteractionCallback):void{
		GameSignals.STEAM_COLLISION.dispatch(cb.int2.castShape.body, true);
	}

	private function onCritterToBallCollision(cb:InteractionCallback):void{
		GameSignals.CRITTER_COLLISION.dispatch(cb);
	}

	override public function init():void{
		super.init();
		node.core.onUpdate.add(update);
	}

	public function update(dt:Number):void{
        if(!_gamePaused)
		    space.step(dt / 1000);
	}

    private var _joints:Vector.<DistanceJoint> = new Vector.<DistanceJoint>();

    public function removeFirstJoint():void{
        _joints[0].body1 = null;
        _joints[0].body2 = null;
        _joints[0].space = null;
        _joints.shift();
    }
    public function removeJoints():void{
        for (var i:int = 0; i < _joints.length; i++) {
            _joints[i].body1 = null;
            _joints[i].body2 = null;
            _joints[i].space = null;
        }
        _joints = new Vector.<DistanceJoint>();
    }

    public function createJoint(pBodyHead:Body, pBodyTail:Body):void {
        var distanceJoint:DistanceJoint =new DistanceJoint(pBodyHead,pBodyTail,new Vec2(0,0),new Vec2(0,0),GameConstants.TILE_SIZE,GameConstants.TILE_SIZE * 1.2);
        //distanceJoint.ignore = false;
        distanceJoint.stiff = true;
        distanceJoint.space = space;
        _joints.push(distanceJoint);
    }
}
}
