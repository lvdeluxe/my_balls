/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.AssetsManager;
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.context.GBlendMode;
import com.genome2d.geom.GCurve;

public class BonusParticles extends GParticleSystem{

    public function BonusParticles() {
        blendMode = GBlendMode.NORMAL;
        duration = 1;
        loop = false;
    }
}
}
