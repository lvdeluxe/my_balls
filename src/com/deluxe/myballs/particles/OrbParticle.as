/**
 * Created by lvdeluxe on 15-02-11.
 */
package com.deluxe.myballs.particles {
import com.genome2d.particles.GParticle;
import com.genome2d.particles.GParticlePool;

public class OrbParticle extends GParticle{

    public var initAngle:Number;
    public var speed:Number;
    public var initRadius:Number;

    public function OrbParticle(pPool:GParticlePool) {
        super(pPool);
    }
}
}
