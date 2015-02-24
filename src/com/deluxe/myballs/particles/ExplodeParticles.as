/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class ExplodeParticles extends GSimpleParticleSystem{
    public function ExplodeParticles() {
        blendMode = GBlendMode.ADD;
        texture = AssetsManager.getExplodeParticle();
        emission = 75;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 0.1;
        energyVariance = 0.2;
        dispersionAngle = 6.28;
        dispersionAngleVariance = 6.28;
        dispersionXVariance = 0;
        dispersionYVariance = 0;
        initialScale = 0;
        endScale = 1;
        initialScaleVariance = 0.5;
        endScaleVariance = 0;
        initialVelocity = 75;
        initialVelocityVariance = 200;
        initialAngularVelocity = 0;
        initialAngularVelocityVariance = 0;
        initialAcceleration = 0;
        initialAccelerationVariance = 0;
        initialAngle = 0;
        initialAngleVariance = 3.14;
        initialColor = 16776960;
        endColor = 8388735;
        initialAlpha = 1;
        initialAlphaVariance = 0;
        endAlpha = 0;
        endAlphaVariance = 0;
        initialRed = 1;
        initialRedVariance = 0;
        endRed = 0.5;
        endRedVariance = 0;
        initialGreen = 1;
        initialGreenVariance = 0;
        endGreen = 0.5;
        endGreenVariance = 0;
        initialBlue = 0;
        initialBlueVariance = 0;
        endBlue = 1;
        endBlueVariance = 0;
        burst = true;
    }
}
}
