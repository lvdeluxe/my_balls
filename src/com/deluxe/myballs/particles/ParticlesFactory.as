/**
 * Created by lvdeluxe on 15-02-15.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.*;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.particles.BonusAffector;
import com.deluxe.myballs.particles.BonusParticle;
import com.deluxe.myballs.particles.BonusParticles;
import com.deluxe.myballs.particles.OrbAffector;
import com.deluxe.myballs.particles.OrbInitializer;
import com.deluxe.myballs.particles.OrbParticle;
import com.deluxe.myballs.particles.OrbParticles;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.geom.GCurve;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.particles.GParticlePool;

import nape.geom.Vec2;

public class ParticlesFactory {

    public function ParticlesFactory() {

    }

    public static function triggerBallsBonusParticles(pPos:Vec2):GParticleSystem{
        var particles:BonusParticles = GNodeFactory.createNodeWithComponent(BonusParticles) as BonusParticles;
        particles.texture = AssetsManager.getBonusBallsX3Texture();
        particles.particlePool.g2d_particleClass = BonusParticle;
        particles.emission = new GCurve(1);
        particles.addAffector(new BonusAffector());
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(particles.node);
        particles.node.transform.setPosition(pPos.x, pPos.y - (GameConstants.TILE_SIZE / 2));
        return particles;
    }

    public static function triggerStarsBonusParticles(pPos:Vec2):GParticleSystem{
        var particles:BonusParticles = GNodeFactory.createNodeWithComponent(BonusParticles) as BonusParticles;
        particles.texture = AssetsManager.getBonusStarsX2Texture();
        particles.particlePool.g2d_particleClass = BonusParticle;
        particles.emission = new GCurve(1);
        particles.addAffector(new BonusAffector());
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(particles.node);
        particles.node.transform.setPosition(pPos.x, pPos.y - (GameConstants.TILE_SIZE / 2));
        return particles;
    }

    public static function triggerIndestructBonusParticles():OrbParticles{
        var particles:OrbParticles = GNodeFactory.createNodeWithComponent(OrbParticles) as OrbParticles;
        particles.particlePool = new GParticlePool(OrbParticle);
//        particles.particlePool.g2d_particleClass = OrbParticle;
        particles.emission = new GCurve(100);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(particles.node);
        particles.addInitializer(new OrbInitializer());
        particles.addAffector(new OrbAffector());
        particles.node.transform.setPosition(320,320);
        particles.emit = false;
        return particles;
    }
}
}
