/**
 * Created by lvdeluxe on 15-03-22.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class CoilParticles extends GSimpleParticleSystem{
    public function CoilParticles() {
        blendMode = GBlendMode.ADD;
        texture = AssetsManager.getTeslaTexture();
        emission = 20;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 0.1 * GameConstants.ASSETS_SCALE;
        energyVariance = 0.05 * GameConstants.ASSETS_SCALE;
        dispersionAngle = 6.28;
        dispersionAngleVariance = 6.28;
        dispersionXVariance = 16 * GameConstants.ASSETS_SCALE;
        dispersionYVariance = 16 * GameConstants.ASSETS_SCALE;
        initialScale = 1;
        endScale = 1;
        initialScaleVariance = 0;
        endScaleVariance = 0;
        initialVelocity = 0;
        initialVelocityVariance = 0;
        initialAngularVelocity = 0;
        initialAngularVelocityVariance = 0;
        initialAcceleration = 0.01;
        initialAccelerationVariance = -0.01;
        initialAngle = 0;
        initialAngleVariance = 6.28;
        initialColor = 16776960;
        endColor = 1736626;
        initialAlpha = 1;
        initialAlphaVariance = 0;
        endAlpha = 1;
        endAlphaVariance = 0;
        initialRed = 1;
        initialRedVariance = 0;
        endRed = 0.1;
        endRedVariance = 0;
        initialGreen = 1;
        initialGreenVariance = 0;
        endGreen = 1;
        endGreenVariance = 0;
        initialBlue = 0;
        initialBlueVariance = 0;
        endBlue = 0.7;
        endBlueVariance = 0;
        emit = true;
    }
}
}
