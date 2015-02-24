/**
 * Created by lvdeluxe on 15-02-15.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.*;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.signals.GNodeMouseSignal;

public class GCloseButton extends GSprite{

    public function GCloseButton() {

    }

    override public function init():void{
        texture = AssetsManager.getCloseBtnOffTexture();
        node.mouseEnabled = true;
        node.onMouseDown.add(onMouseDown);
        node.onMouseUp.add(onMouseUp);
        node.onMouseClick.add(onMouseClick);
    }

    public function set verticalRatio(value:Number):void{
        var pos:Number = (GameConstants.SCREEN_HEIGHT / 2) - (texture.height / 2);
        pos *= value;

        node.transform.y = pos;
    }

    public function set horizontalRatio(value:Number):void{
        var pos:Number = (GameConstants.SCREEN_WIDTH / 2) - (texture.width / 2);
        pos *= value;

        node.transform.x = pos;
    }

    private function onMouseClick(sig:GNodeMouseSignal):void{
       GameSignals.CLOSE_POPUP.dispatch();
    }

    private function onMouseDown(sig:GNodeMouseSignal):void{
        texture = AssetsManager.getCloseBtnOnTexture();
    }

    private function onMouseUp(sig:GNodeMouseSignal):void{
        SoundManager.playClickSfx();
        texture = AssetsManager.getCloseBtnOffTexture();
    }
}
}