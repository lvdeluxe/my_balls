/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class ElectricParticles extends GSimpleParticleSystem{
    private var _paused:Boolean = false;
    public function ElectricParticles() {
        blendMode = GBlendMode.ADD;
        emission = 10;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 1 * GameConstants.ASSETS_SCALE;
        energyVariance = 0;
        dispersionAngle = 0;
        dispersionAngleVariance = 0;
        dispersionXVariance = 20 * GameConstants.ASSETS_SCALE;
        dispersionYVariance = 6 * GameConstants.ASSETS_SCALE;
        initialScale = 0.95;
        endScale = 0.95;
        initialScaleVariance = 0.1;
        endScaleVariance = 0.1;
        initialVelocity = 0;
        initialVelocityVariance = 0;
        initialAngularVelocity = 0;
        initialAngularVelocityVariance = 0;
        initialAcceleration = 0;
        initialAccelerationVariance = 0;
        initialAngle = -0.01;
        initialAngleVariance = 0.01;
        initialColor = 13183;
        endColor = 16744320;
        initialAlpha = 1;
        initialAlphaVariance = 0;
        endAlpha = 0;
        endAlphaVariance = 0;
        initialRed = 0;
        initialRedVariance = 0;
        endRed = 1;
        endRedVariance = 0;
        initialGreen = 0.2;
        initialGreenVariance = 0;
        endGreen = 0.5;
        endGreenVariance = 0;
        initialBlue = 0.5;
        initialBlueVariance = 0;
        endBlue = 0;
        endBlueVariance = 0;
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
