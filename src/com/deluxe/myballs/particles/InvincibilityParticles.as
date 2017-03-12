/**
 * Created by lvdeluxe on 15-03-23.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class InvincibilityParticles extends GSimpleParticleSystem{

    private var _paused:Boolean =false;

    public function InvincibilityParticles() {
        blendMode = GBlendMode.ADD;
        texture = AssetsManager.getPowerupParticleTexture();
        emission = 5;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 0.5 * GameConstants.ASSETS_SCALE;
        energyVariance = 0.2 * GameConstants.ASSETS_SCALE;
        dispersionAngle = 6.28;
        dispersionAngleVariance = 0;
        dispersionXVariance = 3 * GameConstants.ASSETS_SCALE;
        dispersionYVariance = 3 * GameConstants.ASSETS_SCALE;
        initialScale = 1.1;
        endScale = 1.25;
        initialScaleVariance = 0.1;
        endScaleVariance = 0.1;
        initialVelocity = 0;
        initialVelocityVariance = 0;
        initialAngularVelocity = 0;
        initialAngularVelocityVariance = 0.001;
        initialAcceleration = -0.001;
        initialAccelerationVariance = 0;
        initialAngle = 0;
        initialAngleVariance = 6.28;
        initialColor = 16777215;
        endColor = 16777215;
        initialAlpha = 0.5;
        initialAlphaVariance = 0.2;
        endAlpha = 0;
        endAlphaVariance = 0;
        initialRed = 0.97;
        initialRedVariance = 0.5;
        endRed = 0.95;
        endRedVariance = 0;
        initialGreen = 0.32;
        initialGreenVariance = 0.5;
        endGreen = 0.11;
        endGreenVariance = 0;
        initialBlue = 0.1;
        initialBlueVariance = 0.5;
        endBlue = 0.78;
        endBlueVariance = 0;
        emit = false;
        burst = false;

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
