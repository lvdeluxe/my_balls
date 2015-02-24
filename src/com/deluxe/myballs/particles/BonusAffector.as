/**
 * Created by lvdeluxe on 15-02-10.
 */
package com.deluxe.myballs.particles {
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.IGAffector;

public class BonusAffector implements IGAffector{

    public function BonusAffector() {
    }

    public function update(p_system:GParticleSystem,p_particle:GParticle,p_deltaTime:Number):void{
        p_particle.accumulatedTime += p_deltaTime;
        var p:BonusParticle = p_particle as BonusParticle;

        p.y = p_system.node.transform.y - (p.yOffset * (p_particle.accumulatedTime / p.lifeTime));
        p.alpha = (1 - (p_particle.accumulatedTime / p.lifeTime));

        p.x = p_system.node.transform.x + (Math.sin(p.xOffset) *  p.xVariation);
        p.xOffset += p_deltaTime / 100;

        if(p.accumulatedTime >= p.lifeTime){
            p.die = true;
        }
    }
}
}
