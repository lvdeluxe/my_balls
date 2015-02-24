/**
 * Created by lvdeluxe on 15-02-11.
 */
package com.deluxe.myballs.particles {
import com.genome2d.particles.GParticle;
import com.genome2d.particles.GParticlePool;

public class BonusParticle extends GParticle{

    public var xVariation:Number = 5;
    public var xOffset:Number = 0;
    public var yOffset:Number = 50;
    public var lifeTime:Number = 1000;

    public function BonusParticle(pPool:GParticlePool) {
        super(pPool);
    }
}
}
