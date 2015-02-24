/**
 * Created by lvdeluxe on 15-02-08.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.*;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

public class GButton extends GSprite{

    private var _label:GText;
    private var _clickListener:Function;

    public function GButton() {
        super();
    }

    override public function init():void{
        textureId = "atlas_btn_off.png";
        _label = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "futura";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.CENTER;
        renderer.width = texture.width;
        renderer.height = texture.height;
        _label.renderer = renderer;
        _label.node.transform.setPosition(-texture.width / 2, -texture.height / 2);
        node.addChild(_label.node);
        node.mouseEnabled = true;
        node.mouseChildren = true;
        node.onMouseDown.add(onMouseDown);
        node.onMouseUp.add(onMouseUp);
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

    private function onMouseDown(sig:GNodeMouseSignal):void{
        textureId = "atlas_btn_on.png";
    }

    private function onMouseUp(sig:GNodeMouseSignal):void{
        SoundManager.playClickSfx();
        textureId = "atlas_btn_off.png";
    }
}
}
