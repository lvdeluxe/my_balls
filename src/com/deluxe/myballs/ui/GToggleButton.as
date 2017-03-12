/**
 * Created by lvdeluxe on 15-02-08.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.*;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSlice3Sprite;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

import org.osflash.signals.Signal;

public class GToggleButton extends GButton{

    private var _toggle:GSprite;
    public var toggleSignal:Signal;
    private var _state:Boolean = true;

    public function GToggleButton() {
        super();
    }

    override public function init():void{
        super.init();
        setToggle();
    }



    private function setToggle():void{
        _toggle = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _toggle.texture = AssetsManager.getToggleOnTexture();
        _toggle.node.transform.setPosition((width) - (_toggle.texture.width / 2) - (10 * GameConstants.ASSETS_SCALE), height / 2);
        node.addChild(_toggle.node);
        node.onMouseClick.add(onClick);
    }

    private function onClick(sig:GNodeMouseSignal):void{
        _state = !_state;
        _toggle.texture = _state ? AssetsManager.getToggleOnTexture() : AssetsManager.getToggleOffTexture();
        toggleSignal.dispatch(_state);
    }

    public function set state(value:Boolean):void {
        _state = value;
        _toggle.texture = _state ? AssetsManager.getToggleOnTexture() : AssetsManager.getToggleOffTexture();
    }
}
}
