/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class BallParticles extends GSimpleParticleSystem{

    private var _paused:Boolean = false;

    public function BallParticles() {
        blendMode = GBlendMode.NORMAL;
        texture = AssetsManager.getCollisonParticle();
        emission = 20;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 0.1 * GameConstants.ASSETS_SCALE;
        energyVariance = 0.2 * GameConstants.ASSETS_SCALE;
        dispersionAngle = 3.5;
        dispersionAngleVariance = 2.5;
        dispersionXVariance = 0;
        dispersionYVariance = 0;
        initialScale = 0;
        endScale = 1;
        initialScaleVariance = 0.5;
        endScaleVariance = 0;
        initialVelocity = 20 * GameConstants.ASSETS_SCALE;
        initialVelocityVariance = 50 * GameConstants.ASSETS_SCALE;
        initialAngularVelocity = 0;
        initialAngularVelocityVariance = 0;
        initialAcceleration = 0.3;
        initialAccelerationVariance = 0.1;
        initialAngle = 0;
        initialAngleVariance = 6.28;
        initialColor = 16777215;
        endColor = 16777215;
        initialAlpha = 1;
        initialAlphaVariance = 0;
        endAlpha = 0;
        endAlphaVariance = 0;
        initialRed = 0.5647058823529412;
        initialRedVariance = 0;
        endRed = 0.9529411764705882;
        endRedVariance = 0;
        initialGreen = 0.3411764705882353;
        initialGreenVariance = 0;
        endGreen = 0.5686274509803922;
        endGreenVariance = 0;
        initialBlue = 0.196078431372549;
        initialBlueVariance = 0;
        endBlue = 0.3215686274509804;
        endBlueVariance = 0;
        //emit = true;
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
