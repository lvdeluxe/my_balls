/**
 * Created by lvdeluxe on 15-04-05.
 */
package com.deluxe.myballs.ui {
import com.deluxe.Localization;
import com.deluxe.myballs.AssetsManager;
import com.genome2d.components.renderables.GSlice3Sprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

public class OptionContentNode extends GNode{

    private var _text:GText;
    private var _title:GText;
    private var _titleBg:GSlice3Sprite;
    private var _width:Number;
    private var _height:Number;
    private var _startY:Number;
    private var _titleId:String;
    private var _textId:String;

    public function OptionContentNode(pW:Number, pH:Number, pY:Number, titleId:String, textId:String) {
        _width = pW;
        _height = pH;
        _startY = pY;
        _titleId = titleId;
        _textId = textId;
        setTitleBg();
        setCreditsText();
        setTitleText();
    }

    private  function setTitleBg():void{
        _titleBg = GNodeFactory.createNodeWithComponent(GSlice3Sprite) as GSlice3Sprite;
        _titleBg.texture1 = AssetsManager.GetTitleBgLeftTexture();
        _titleBg.texture2 = AssetsManager.GetTitleBgCenterTexture();
        _titleBg.texture3 = AssetsManager.GetTitleBgRightTexture();
        _titleBg.height = _titleBg.texture1.height;
        _titleBg.node.transform.setPosition(-_width / 2,_startY);
        addChild(_titleBg.node);
    }

    private  function setCreditsText():void{
        _text = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "impactText";
        renderer.vAlign = GVAlignType.TOP;
        renderer.hAlign = GHAlignType.CENTER;
        renderer.autoSize = true;
        _text.renderer = renderer;
        _text.text = Localization.getString(_textId);
        var posY:Number = (_titleBg.texture1.height + ((_height / 2) - Math.abs(_startY))) / 2;
        _text.node.transform.setPosition(-(renderer.width) / 2, posY - (renderer.height / 2));
        addChild(_text.node);
    }

    private  function setTitleText():void{
        _title = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "impactTitle";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.CENTER;
        renderer.autoSize = true;
        _title.renderer = renderer;
        _title.text = Localization.getString(_titleId);
        _title.node.transform.setPosition(-(renderer.width) / 2,_startY + ((_titleBg.height - renderer.height) / 2));
        addChild(_title.node);
        _titleBg.width = (int)(renderer.width * 1.2);
        _titleBg.node.transform.x = (int)(-(renderer.width * 1.2) / 2);
    }
}
}
