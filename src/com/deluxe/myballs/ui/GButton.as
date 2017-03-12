/**
 * Created by lvdeluxe on 15-02-08.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.*;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.audio.SoundManager;
import com.genome2d.components.renderables.GSlice3Sprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.context.GBlendMode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

public class GButton extends GSlice3Sprite{

    protected var _label:GText;
    private var _clickListener:Function;

    public function GButton() {
        super();
    }

    override public function init():void{
        texture1 = AssetsManager.getButtonLeftTexture();
        texture2 = AssetsManager.getButtonCenterTexture();
        texture3 = AssetsManager.getButtonRightTexture();
        width = (int)(GameConstants.SCREEN_WIDTH * 0.6);
        height = texture1.height;

        _label = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "impactButton";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.CENTER;
        renderer.width = width;
        renderer.height = height;
        _label.renderer = renderer;

        node.addChild(_label.node);
        node.mouseEnabled = true;
        node.mouseChildren = true;
        node.onMouseDown.add(onMouseDown);
        node.onMouseUp.add(onMouseUp);
        node.onMouseOut.add(onMouseOut);
    }

    public function setText(str:String):void{
        _label.text = str;
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

    public function addClickEvent(listener:Function):void{
        _clickListener = listener;
        node.onMouseClick.add(onMouseClick);
    }

    public function removeClickEvent(listener:Function):void{
        _clickListener = null;
        node.onMouseClick.remove(onMouseClick);
    }

    private function onMouseClick(sig:GNodeMouseSignal):void{
        _clickListener();
    }

    protected function onMouseDown(sig:GNodeMouseSignal):void{
        texture1 = AssetsManager.getButtonOnLeftTexture();
        texture2 = AssetsManager.getButtonOnCenterTexture();
        texture3 = AssetsManager.getButtonOnRightTexture();
    }

    protected function onMouseOut(sig:GNodeMouseSignal):void{
        texture1 = AssetsManager.getButtonLeftTexture();
        texture2 = AssetsManager.getButtonCenterTexture();
        texture3 = AssetsManager.getButtonRightTexture();
    }

    protected function onMouseUp(sig:GNodeMouseSignal):void{
        SoundManager.playClickSfx();
        texture1 = AssetsManager.getButtonLeftTexture();
        texture2 = AssetsManager.getButtonCenterTexture();
        texture3 = AssetsManager.getButtonRightTexture();
    }
}
}
