/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class BallParticles extends GSimpleParticleSystem{
    public function BallParticles() {
        blendMode = GBlendMode.ADD;
        texture = AssetsManager.getCollisonParticle();
        emission = 75;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 0.1;
        energyVariance = 0.2;
        dispersionAngle = -2.5;
        dispersionAngleVariance = 2;
        dispersionXVariance = 2;
        dispersionYVariance = 2;
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
        initialAngleVariance = 6.28;
        initialColor = 16777215;
        endColor = 65280;
        initialAlpha = 1;
        initialAlphaVariance = 0;
        endAlpha = 1;
        endAlphaVariance = 0;
        initialRed = 1;
        initialRedVariance = 0;
        endRed = 0;
        endRedVariance = 0;
        initialGreen = 1;
        initialGreenVariance = 0;
        endGreen = 1;
        endGreenVariance = 0;
        initialBlue = 1;
        initialBlueVariance = 0;
        endBlue = 0;
        endBlueVariance = 0;
        //emit = true;
        burst = true;
    }
}
}
