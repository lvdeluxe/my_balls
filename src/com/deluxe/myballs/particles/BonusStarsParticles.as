/**
 * Created by lvdeluxe on 15-02-15.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class BonusStarsParticles extends GSimpleParticleSystem{
    
    public function BonusStarsParticles() {
        blendMode = GBlendMode.ADD;
        texture = AssetsManager.getBonusStarParticle();
        emission = 10;
        emissionDelay = 0;
        emissionTime = 0.1;
        emissionVariance = 0;
        energy = 1;
        energyVariance = 0.2;
        dispersionAngle = 0;
        dispersionAngleVariance = 0;
        dispersionXVariance = 5;
        dispersionYVariance = 5;
        initialScale = 1;
        endScale = 1;
        initialScaleVariance = 0.5;
        endScaleVariance = 0.5;
        initialVelocity = 1;
        initialVelocityVariance = 0;
        initialAngularVelocity = 0;
        initialAngularVelocityVariance = 0;
        initialAcceleration = 0;
        initialAccelerationVariance = 0;
        initialAngle = 0;
        initialAngleVariance = 0;
        initialColor = 8421247;
        endColor = 8421247;
        initialAlpha = 0.1;
        initialAlphaVariance = 0;
        endAlpha = 0;
        endAlphaVariance = 0;
        initialRed = 0.5;
        initialRedVariance = 0;
        endRed = 0.5;
        endRedVariance = 0;
        initialGreen = 1;
        initialGreenVariance = 0;
        endGreen = 1;
        endGreenVariance = 0;
        initialBlue = 0.5;
        initialBlueVariance = 0;
        endBlue = 0.5;
        endBlueVariance = 0;
    }
}
}
