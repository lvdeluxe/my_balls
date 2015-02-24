/**
 * Created by lvdeluxe on 15-02-10.
 */
package com.deluxe.myballs.particles {
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.GParticlePool;
import com.genome2d.particles.IGInitializer;

public class OrbInitializer implements IGInitializer{

    private var _radius:Number = 16;

    public function OrbInitializer() {

   }

    public function initialize(p_system:GParticleSystem,p_particle:GParticle):void{
        var p:OrbParticle = p_particle as OrbParticle;
        var angle:Number = Math.PI * 2 * Math.random();
        p.initAngle = angle;
        p.speed = 0.1 - (Math.random() * 0.2);
        var randRadius:Number = _radius + (Math.random() * 8);
        p.initRadius = randRadius;
        p_particle.green = 1;
        p_particle.blue = 0.1;
        p_particle.red = 0.1;
        p_particle.alpha = 1;
        var randomScale:Number = Math.random() * 0.5;
        p_particle.scaleX = randomScale;
        p_particle.scaleY = randomScale;
        p_particle.x = p_system.node.transform.x + (randRadius * (Math.cos(angle)));
        p_particle.y = p_system.node.transform.y + (randRadius * (Math.sin(angle)));
    }
}
}
