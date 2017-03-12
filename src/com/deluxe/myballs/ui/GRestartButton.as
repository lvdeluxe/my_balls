/**
 * Created by lvdeluxe on 15-03-17.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.signals.GNodeMouseSignal;

public class GRestartButton extends GSprite{

    public function GRestartButton() {
        super();
    }

    override public function init():void{
        texture = AssetsManager.getRestartButtonOffTexture();
        node.mouseEnabled = true;
        node.onMouseDown.add(onMouseDown);
        node.onMouseUp.add(onMouseUp);
        node.onMouseOut.add(onMouseOut);
        node.onMouseClick.add(onMouseClick);
    }

    protected function onMouseClick(sig:GNodeMouseSignal):void{
        GameSignals.PLAY_AGAIN.dispatch();
    }

    protected function onMouseDown(sig:GNodeMouseSignal):void{
        texture = AssetsManager.getRestartButtonOnTexture();
    }

    protected function onMouseOut(sig:GNodeMouseSignal):void{
        texture = AssetsManager.getRestartButtonOffTexture();
    }

    protected function onMouseUp(sig:GNodeMouseSignal):void{
        SoundManager.playClickSfx();
        texture = AssetsManager.getRestartButtonOffTexture();
    }
}
}
