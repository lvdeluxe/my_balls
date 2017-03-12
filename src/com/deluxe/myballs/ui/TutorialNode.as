/**
 * Created by lvdeluxe on 15-04-08.
 */
package com.deluxe.myballs.ui {
import aze.motion.EazeTween;
import aze.motion.easing.Quadratic;
import aze.motion.eaze;

import com.deluxe.Localization;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.genome2d.components.GTransform;
import com.genome2d.components.renderables.GSlice9Sprite;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

import flash.geom.Point;

public class TutorialNode extends GNode{


    private var _bg:GSlice9Sprite;
    private var _btn:GSprite;
    private var _text:GText;
    private var inc_strings:uint = 0;
    private var _positions:Array;
    private var _ballTransform:GTransform;
    private var _starTransform:GTransform;
    private var _rightArrow:GSprite;
    private var _leftArrow:GSprite;
    private var _hand:GSprite;
    private var _target:GSprite;

    public function TutorialNode(target:GTransform, starTransform:GTransform) {
        _ballTransform = target;
        _starTransform = starTransform;
        setBg();
        setButton();
        setText();
        transform.scaleX = transform.scaleY = 0;
        _positions  = [new Point(0,(-GameConstants.SCREEN_HEIGHT / 2) * 0.66), new Point(0,0), new Point(0,(GameConstants.SCREEN_HEIGHT / 2) * 0.33), new Point(0,0)];
        this.onAddedToStage.add(addToStageCallback);
    }

    private function addToStageCallback():void{
        displayTutorial();
        this.onAddedToStage.remove(addToStageCallback);
    }

    private function setPositions():void {
        _bg.width = (int)(_text.renderer.width * 1.1);
        _bg.height = (int)((_text.renderer.height + _btn.texture.height) * 1.3);
        _bg.node.transform.setPosition((int)(-_bg.width / 2), (int)((-_bg.height / 2)));
        _text.node.transform.setPosition(-_text.renderer.width / 2, (-_bg.height / 2 *.8));
        _btn.node.transform.setPosition(0, (_bg.height / 2 *.8) - (_btn.texture.height / 2));
    }

    private function setText():void {
        _text = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "impactText";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.CENTER;
        renderer.autoSize = true;
        _text.renderer = renderer;
        _text.renderer.text = Localization.getString("TUTO_STEP_1");
        addChild(_text.node);
    }

    private function setButton():void {
        _btn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _btn.texture = AssetsManager.getOKButtonOffTexture();

        _btn.node.mouseEnabled = true;
        _btn.node.mouseChildren = true;
        _btn.node.onMouseDown.add(onOKDown);
        _btn.node.onMouseUp.add(onOKUp);
        _btn.node.onMouseOut.add(onOKOut);
        _btn.node.onMouseClick.add(onOKClick);

        addChild(_btn.node);
    }

    private function displayTutorial():void{
        displayTutorialVisual();
        eaze(transform).to(0.3, {scaleX:0, scaleY:0}).easing(Quadratic.easeIn).onComplete(function():void{
            transform.setPosition(_positions[inc_strings].x, _positions[inc_strings].y);
            inc_strings++;
            _text.renderer.text = Localization.getString("TUTO_STEP_" + inc_strings.toString());
            setPositions();
            eaze(transform).to(0.3, {scaleX:1, scaleY:1}).easing(Quadratic.easeOut);

        });
    }

    private function displayTutorialVisual():void {
        switch (inc_strings){
            case 0:
                _rightArrow = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
                _rightArrow.texture = AssetsManager.getTutorialArrowTexture();
                _rightArrow.node.transform.setPosition(GameConstants.TILE_SIZE + (_rightArrow.texture.width / 2), _ballTransform.y - Main.mainCamera.node.transform.y);
                parent.addChild(_rightArrow.node);
                _leftArrow = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
                _leftArrow.texture = AssetsManager.getTutorialArrowTexture();
                _leftArrow.node.transform.scaleX = -1;
                _leftArrow.node.transform.setPosition(-(GameConstants.TILE_SIZE + (_leftArrow.texture.width / 2)), _ballTransform.y - Main.mainCamera.node.transform.y);
                parent.addChild(_leftArrow.node);
                animateArrows();
                break;
            case 1:
                EazeTween.killTweensOf(_leftArrow.node.transform);
                EazeTween.killTweensOf(_rightArrow.node.transform);
                parent.removeChild(_leftArrow.node);
                parent.removeChild(_rightArrow.node);
                _target = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
                _target.texture = AssetsManager.getTutorialTargetTexture();
                parent.addChild(_target.node);
                _hand = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
                _hand.texture = AssetsManager.getTutorialHandTexture();
                parent.addChild(_hand.node);
                _hand.node.transform.setPosition(GameConstants.SCREEN_WIDTH / 4, -GameConstants.SCREEN_HEIGHT / 4);
                _target.node.transform.setPosition(_hand.node.transform.x, _hand.node.transform.y -_hand.texture.height / 2 * 0.85);
                animateHandAndTarget();
                break;
            case 2:
                EazeTween.killTweensOf(_target.node.transform);
                EazeTween.killTweensOf(_hand.node.transform);
                parent.removeChild(_target.node);
                parent.removeChild(_hand.node);
                animateStar();
                break;
            case 3:
                EazeTween.killTweensOf(_starTransform.node.transform);
                _starTransform.node.transform.blue = 1;
                _starTransform.node.transform.red = 1;
                break;
        }
    }

    private function animateStar():void{
        eaze(_starTransform).to(0.4, {blue:0.1,red:1.2}).easing(Quadratic.easeOut).onComplete(function():void{
            eaze(_starTransform).to(0.4, {blue:1,red:1}).easing(Quadratic.easeIn).onComplete(animateStar);
        });
    }

    private function animateHandAndTarget():void{
        _target.node.transform.alpha = 0;
        _target.node.transform.scaleX = _target.node.transform.scaleY = 0.5;
        eaze(_hand.node.transform).to(0.5, {scaleY:0.85}).easing(Quadratic.easeIn).onComplete(function():void{
            eaze(_target.node.transform).to(0.2, {alpha:1, scaleX:1,scaleY:1}).easing(Quadratic.easeIn).onComplete(function():void{
                eaze(_target.node.transform).delay(0.25).to(0.1, {alpha:0}).easing(Quadratic.easeOut);
            });
            eaze(_hand.node.transform).delay(0.3).to(0.4, {scaleY:1}).easing(Quadratic.easeOut).onComplete(function():void{
                animateHandAndTarget();
            });
        })
    }

    private function animateArrows():void{
        _leftArrow.node.transform.alpha = 1;
        _rightArrow.node.transform.alpha = 0;
        var startXLeft:Number = _leftArrow.node.transform.x;
        var startXRight:Number = _rightArrow.node.transform.x;
        eaze(_leftArrow.node.transform).to(0.5, {alpha:0, x:startXLeft - GameConstants.TILE_SIZE}).easing(Quadratic.easeIn).onComplete(function():void{
            _leftArrow.node.transform.x = startXLeft;
            _rightArrow.node.transform.alpha = 1;
            eaze(_rightArrow.node.transform).to(0.5, {alpha:0, x:startXRight + GameConstants.TILE_SIZE}).easing(Quadratic.easeIn).onComplete(function():void{
                _rightArrow.node.transform.x = startXRight;
                animateArrows();
            });
        })
    }

    public function setVisible(v:Boolean):void{
        transform.visible = v;
        if(_leftArrow != null)
            _leftArrow.node.transform.visible = v;
        if(_rightArrow != null)
            _rightArrow.node.transform.visible = v;
        if(_target != null)
            _target.node.transform.visible = v;
        if(_hand != null)
            _hand.node.transform.visible = v;

    }

    protected function onOKClick(sig:GNodeMouseSignal):void{

        if(inc_strings != _positions.length)
            displayTutorial();
        else
            cleanup();
    }

    private function cleanup():void{
        _btn.node.onMouseDown.remove(onOKDown);
        _btn.node.onMouseUp.remove(onOKUp);
        _btn.node.onMouseOut.remove(onOKOut);
        _btn.node.onMouseClick.remove(onOKClick);
        GameSignals.TUTORIAL_COMPLETE.dispatch();
        parent.removeChild(this);
    }

    protected function onOKDown(sig:GNodeMouseSignal):void{
        _btn.texture = AssetsManager.getOKButtonOnTexture();
    }

    protected function onOKOut(sig:GNodeMouseSignal):void{
        _btn.texture = AssetsManager.getOKButtonOffTexture();
    }

    protected function onOKUp(sig:GNodeMouseSignal):void{
        SoundManager.playClickSfx();
        _btn.texture = AssetsManager.getOKButtonOffTexture();
    }

    private function setBg():void {
        _bg = GNodeFactory.createNodeWithComponent(GSlice9Sprite) as GSlice9Sprite;
        _bg.texture1 = AssetsManager.getTutoPopupBgTopLeftTexture();
        _bg.texture2 = AssetsManager.getTutoPopupBgTopTexture();
        _bg.texture3 = AssetsManager.getTutoPopupBgTopRightTexture();
        _bg.texture4 = AssetsManager.getTutoPopupBgLeftTexture();
        _bg.texture5 = AssetsManager.getTutoPopupBgCenterTexture();
        _bg.texture6 = AssetsManager.getTutoPopupBgRightTexture();
        _bg.texture7 = AssetsManager.getTutoPopupBgBottomLeftTexture();
        _bg.texture8 = AssetsManager.getTutoPopupBgBottomTexture();
        _bg.texture9 = AssetsManager.getTutoPopupBgBottomRightTexture();
        addChild(_bg.node);
    }
}
}
