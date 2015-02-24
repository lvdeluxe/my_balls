/**
 * Created by lvdeluxe on 15-01-29.
 */
package com.deluxe.myballs.physics {
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.GComponent;

import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;
import nape.space.Space;

public class GNapePhysics extends GComponent{

	public var space:Space;
	private var _starToBallListener:InteractionListener;
	private var _arrowToBallListener:InteractionListener;
	private var _critterToBallListener:InteractionListener;
	private var _destructToBallListener:InteractionListener;
	private var _platformToBallStartListener:InteractionListener;
	private var _platformToBallEndListener:InteractionListener;
	private var _spikesToBallListener:InteractionListener;
	private var _bonusToBallListener:InteractionListener;
    private var _gamePaused:Boolean = false;

	public function GNapePhysics() {
		super();
		space = new Space(Vec2.weak(0,800));
        _starToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.STAR_COLLISION,NapeCollisionTypes.BALL_COLLISION,onStarToBallCollision);
		space.listeners.add(_starToBallListener);
        _arrowToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.ARROW_COLLISION,NapeCollisionTypes.BALL_COLLISION,onArrowToBallCollision);
        space.listeners.add(_arrowToBallListener);
        _critterToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.CRITTER_COLLISION,NapeCollisionTypes.BALL_COLLISION,onCritterToBallCollision);
        space.listeners.add(_critterToBallListener);
        _destructToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,NapeCollisionTypes.DESTRUCTIBLE_COLLISION,NapeCollisionTypes.BALL_COLLISION,onDestructToBallCollision);
        space.listeners.add(_destructToBallListener);
        _platformToBallStartListener=new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,NapeCollisionTypes.PLATFORM_COLLISION,NapeCollisionTypes.BALL_COLLISION,onPlatformToBallStartCollision);
        space.listeners.add(_platformToBallStartListener);
        _platformToBallEndListener=new InteractionListener(CbEvent.END,InteractionType.COLLISION,NapeCollisionTypes.PLATFORM_COLLISION,NapeCollisionTypes.BALL_COLLISION,onPlatformToBallEndCollision);
        space.listeners.add(_platformToBallEndListener);
        _spikesToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.SPIKES_COLLISION,NapeCollisionTypes.BALL_COLLISION,onSpikesToBallCollision);
        space.listeners.add(_spikesToBallListener);
        _bonusToBallListener=new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,NapeCollisionTypes.BONUS_COLLISION,NapeCollisionTypes.BALL_COLLISION,onBonusToBallCollision);
        space.listeners.add(_bonusToBallListener);

        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _gamePaused = pPaused;
    }

	private function onBonusToBallCollision(cb:InteractionCallback):void{
		GameSignals.COLLECT_BONUS.dispatch(cb.int1.castShape.body, cb.int2.castShape.body);
	}

	private function onSpikesToBallCollision(cb:InteractionCallback):void{
		GameSignals.SPIKES_COLLISION.dispatch(cb.int1.castShape.body);
	}

	private function onPlatformToBallEndCollision(cb:InteractionCallback):void{
		GameSignals.PLATFORM_END_COLLISION.dispatch(cb);
	}

	private function onPlatformToBallStartCollision(cb:InteractionCallback):void{
		GameSignals.PLATFORM_START_COLLISION.dispatch(cb);
	}

	private function onDestructToBallCollision(cb:InteractionCallback):void{
		GameSignals.DESTRUCT_COLLISION.dispatch(cb.int1.castShape.body);
	}

	private function onStarToBallCollision(cb:InteractionCallback):void{
		GameSignals.COLLECT_STAR.dispatch(cb.int1.castShape.body);
	}

	private function onArrowToBallCollision(cb:InteractionCallback):void{
		GameSignals.ARROW_COLLISION.dispatch(cb.int1.castShape.body);
	}

	private function onCritterToBallCollision(cb:InteractionCallback):void{
		GameSignals.CRITTER_COLLISION.dispatch(cb.int1.castShape.body);
	}

	override public function init():void{
		super.init();
		node.core.onUpdate.add(update);
	}

	public function update(dt:Number):void{
        if(!_gamePaused)
		    space.step(dt / 1000);
	}
}
}
