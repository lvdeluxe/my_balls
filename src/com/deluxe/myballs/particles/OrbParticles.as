/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;

public class OrbParticles extends GParticleSystem{
    public function OrbParticles() {
        blendMode = GBlendMode.ADD;
        texture = AssetsManager.getOrbParticle();
    }
}
}
