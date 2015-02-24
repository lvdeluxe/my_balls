/**
 * Created by lvdeluxe on 15-02-10.
 */
package com.deluxe.myballs.particles {
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.IGAffector;

public class OrbAffector implements IGAffector{

    public function OrbAffector() {
    }

    public function update(p_system:GParticleSystem,p_particle:GParticle,p_deltaTime:Number):void{
        p_particle.accumulatedTime += p_deltaTime;
        var p:OrbParticle = p_particle as OrbParticle;
        p.initAngle += p.speed;
        p.x = p_system.node.transform.x + (p.initRadius * (Math.cos(p.initAngle + p_system.node.transform.rotation)));
        p.y = p_system.node.transform.y + (p.initRadius * (Math.sin(p.initAngle + p_system.node.transform.rotation)));

        if(p_particle.accumulatedTime > 2000){
            p_particle.die = true;
        }
    }
}
}
