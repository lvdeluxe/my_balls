/**
 * Created by lvdeluxe on 15-02-15.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.*;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.geom.GCurve;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.GTexture;

import nape.geom.Vec2;

public class ParticlesFactory {

    public static function getElectricTextureByWidth(pWidth:uint):GTexture{
        return AssetsManager.getElectricParticlesBySize(pWidth / GameConstants.ASSETS_SCALE);
    }

    public static function triggerBallsBonusParticles(pPos:Vec2):GParticleSystem{
        return getBonusParticles(AssetsManager.getBonusBallsX3Texture(), pPos);
    }

    public static function triggerStarsBonusParticles(pPos:Vec2):GParticleSystem{
        return getBonusParticles(AssetsManager.getBonusStarsX2Texture(), pPos);
    }

    public static function triggerGravityBonusParticles(pPos:Vec2):GParticleSystem{
        return getBonusParticles(AssetsManager.getGravityStarsX2Texture(), pPos);
    }

    private static function getBonusParticles(pTexture:GTexture, pPos:Vec2):GParticleSystem{
        var particles:BonusParticles = GNodeFactory.createNodeWithComponent(BonusParticles) as BonusParticles;
        particles.texture = pTexture;
        particles.particlePool.g2d_particleClass = BonusParticle;
        particles.emission = new GCurve(1);
        particles.addAffector(new BonusAffector());
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(particles.node);
        particles.node.transform.setPosition(pPos.x, pPos.y - (GameConstants.TILE_SIZE / 2));
        return particles;
    }
}
}
