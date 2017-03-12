/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class BallExplodeParticles extends GSimpleParticleSystem{

    private var _paused:Boolean = false;

    public function BallExplodeParticles() {
        blendMode = GBlendMode.ADD;
        texture = AssetsManager.getBallExplodeParticle();
        emission = 30;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 0.25 * GameConstants.ASSETS_SCALE;
        energyVariance = 0;
        dispersionAngle = 6.28;
        dispersionAngleVariance = 6.28;
        dispersionXVariance = 0;
        dispersionYVariance = 0;
        initialScale = 1;
        endScale = 0.5;
        initialScaleVariance = 0;
        endScaleVariance = 0;
        initialVelocity = 150 * GameConstants.ASSETS_SCALE;
        initialVelocityVariance = 200 * GameConstants.ASSETS_SCALE;
        initialAngularVelocity = 0;
        initialAngularVelocityVariance = 0;
        initialAcceleration = -0.75;
        initialAccelerationVariance = 0.75;
        initialAngle = 1;
        initialAngleVariance = 0;
        initialColor = 16777215;
        endColor = 16777215;
        initialAlpha = 1;
        initialAlphaVariance = 0;
        endAlpha = 0;
        endAlphaVariance = 0;
        initialRed = 0.25;
        initialRedVariance = 0.05;
        endRed = 0.75;
        endRedVariance = 0.05;
        initialGreen = 0.27;
        initialGreenVariance = 0.05;
        endGreen = 0.34;
        endGreenVariance = 0.05;
        initialBlue = 0.79;
        initialBlueVariance = 0.05;
        endBlue = 0.85;
        endBlueVariance = 0.05;
        burst = true;

        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _paused = pPaused;
    }

    override public function update(dt:Number):void{
        if(!_paused){
            super.update(dt);
        }
    }
}
}
