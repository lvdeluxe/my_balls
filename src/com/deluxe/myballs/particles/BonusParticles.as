/**
 * Created by lvdeluxe on 15-02-09.
 */
package com.deluxe.myballs.particles {
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.context.GBlendMode;

public class BonusParticles extends GParticleSystem{
    private var _paused:Boolean = false;

    public function BonusParticles() {
        blendMode = GBlendMode.NORMAL;
        duration = 1;
        loop = false;
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
}
}
