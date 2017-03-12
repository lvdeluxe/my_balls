/**
 * Created by lvdeluxe on 15-04-06.
 */
package com.deluxe.myballs.ui {
import aze.motion.easing.Quadratic;
import aze.motion.eaze;

import com.deluxe.myballs.GameConstants;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.context.GContextCamera;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

public class PowerUpLabel extends GNode{

    private var _label:GText;
    private var _animate:Boolean = false;

    public function PowerUpLabel(pText:String) {
        transform.scaleX = 0;
        transform.scaleY = 0;
        _label = GNodeFactory.createNodeWithComponent(GText) as GText;
        var pRenderer:GTextureTextRenderer = new GTextureTextRenderer();
        pRenderer.textureAtlasId = "impactPowerUp";
        pRenderer.vAlign = GVAlignType.MIDDLE;
        pRenderer.hAlign = GHAlignType.CENTER;
        pRenderer.autoSize = true;
        _label.renderer = pRenderer;
        addChild(_label.node);
        _label.text = pText;
        _label.node.transform.x = -pRenderer.width / 2;
        eaze(transform).to(0.2,{scaleX:1, scaleY:1}).easing(Quadratic.easeIn).onComplete(function():void{
            _animate = true;
        });
    }

    override public function render(p_parentTransformUpdate:Boolean,p_parentColorUpdate:Boolean,p_camera:GContextCamera,p_renderAsMask:Boolean,p_useMatrix:Boolean):void{
        if(_animate){
            transform.x = -2 + (uint)(Math.random() * 4);
            _label.node.transform.y = -2 + (uint)(Math.random() * 4);
            transform.rotation = (-3 + (Math.random() * 6)) * GameConstants.RAD_TO_DEG;
        }
        super.render(p_parentTransformUpdate,p_parentColorUpdate,p_camera,p_renderAsMask,p_useMatrix);
    }

    public function stopAnimation(pComplete:Function):void{
        _animate = false;
        var p:GNode = parent;
        var clone:GNode = this;
        transform.x = 0;
        _label.node.transform.y = 0;
        transform.rotation = 0;
        eaze(transform).to(0.3,{scaleX:0, scaleY:0}).easing(Quadratic.easeOut).onComplete(function():void{
            p.removeChild(clone);
            pComplete();
        });
    }

    public function updatePosition(i:int):void {
        transform.setPosition(0,(int)(-(GameConstants.SCREEN_HEIGHT / 2)) + (i * _label.renderer.height));
    }
}
}
