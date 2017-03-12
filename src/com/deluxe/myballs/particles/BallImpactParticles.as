/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class BallImpactParticles extends GSimpleParticleSystem{

    private var _paused:Boolean = false;

    public function BallImpactParticles() {
        blendMode = GBlendMode.ADD;
        texture = AssetsManager.getTeslaTexture();
        emission = 30;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 0.3 * GameConstants.ASSETS_SCALE;
        energyVariance = 0.1 * GameConstants.ASSETS_SCALE;
        dispersionAngle = 6.28;
        dispersionAngleVariance = 6.28;
        dispersionXVariance = 25 * GameConstants.ASSETS_SCALE;
        dispersionYVariance = 25 * GameConstants.ASSETS_SCALE;
        initialScale = 0.5;
        endScale = 0.8;
        initialScaleVariance = 0.2;
        endScaleVariance = 0.2;
        initialVelocity = 10;
        initialVelocityVariance = 10;
        initialAngularVelocity = 0;
        initialAngularVelocityVariance = 0;
        initialAcceleration = 0.1;
        initialAccelerationVariance = 0.02;
        initialAngle = 6.28;
        initialAngleVariance = 6.28;
        initialColor = 33456000;
        endColor = 32895;
        initialAlpha = 1;
        initialAlphaVariance = 0;
        endAlpha = 1;
        endAlphaVariance = 0;
        initialRed = 2;
        initialRedVariance = 0;
        endRed = 0;
        endRedVariance = 0;
        initialGreen = 0.5;
        initialGreenVariance = 0;
        endGreen = 0.5;
        endGreenVariance = 0;
        initialBlue = 0;
        initialBlueVariance = 0;
        endBlue = 1;
        endBlueVariance = 1;
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
