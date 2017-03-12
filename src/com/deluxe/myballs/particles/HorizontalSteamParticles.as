/**
 * Created by lvdeluxe on 15-02-25.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;
import com.genome2d.context.GContextCamera;
import com.genome2d.particles.GSimpleParticle;

public class HorizontalSteamParticles extends GSimpleParticleSystem{

    private var _paused:Boolean = false;
    
    public function HorizontalSteamParticles() {
        blendMode = GBlendMode.ADD;
        useWorldSpace = false;
        texture = AssetsManager.getSteamParticle();
        emission = 75;
        emissionDelay = 0;
        emissionTime = 1;
        emissionVariance = 0;
        energy = 0.45;
        energyVariance = 0.1;
        dispersionAngle = -1.58;
        dispersionAngleVariance = 0;
        dispersionXVariance = 10 * GameConstants.ASSETS_SCALE;
        dispersionYVariance = 0;
        initialScale = 0.3;
        endScale = 1.2;
        initialScaleVariance = 0.5;
        endScaleVariance = 0;
        initialVelocity = 300 * GameConstants.ASSETS_SCALE;
        initialVelocityVariance = 100 * GameConstants.ASSETS_SCALE;
        initialAngularVelocity = 0.01;
        initialAngularVelocityVariance = -0.01;
        initialAcceleration = 0;
        initialAccelerationVariance = 0;
        initialAngle = 0;
        initialAngleVariance = 3.14;
        initialColor = 8388735;
        endColor = 16777215;
        initialAlpha = 0.1;
        initialAlphaVariance = 0.5;
        endAlpha = 0;
        endAlphaVariance = 0;
        initialRed = 0.5;
        initialRedVariance = 0;
        endRed = 1;
        endRedVariance = 0;
        initialGreen = 0.5;
        initialGreenVariance = 0;
        endGreen = 1;
        endGreenVariance = 0;
        initialBlue = 1;
        initialBlueVariance = 0;
        endBlue = 1;
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

    override public function render(p_camera:GContextCamera, p_useMatrix:Boolean):void{
        if (texture == null) return;

        var particle:GSimpleParticle = g2d_firstParticle;

        while (particle != null) {
            var next:GSimpleParticle = particle.g2d_next;

            var tx:Number;
            var ty:Number;
            if (useWorldSpace) {
                tx = particle.g2d_x;
                ty = particle.g2d_y;
            } else {
                tx = node.transform.g2d_worldX + particle.g2d_x;
                ty = node.transform.g2d_worldY + particle.g2d_y;
            }

            node.core.getContext().draw(particle.g2d_texture, tx, ty, particle.g2d_scaleX*node.transform.g2d_worldScaleX, particle.g2d_scaleY*node.transform.g2d_worldScaleY, particle.g2d_rotation, particle.g2d_red, particle.g2d_green, particle.g2d_blue, particle.g2d_alpha, blendMode);

            particle = next;
        }
    }
}
}
