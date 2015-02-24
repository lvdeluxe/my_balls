/**
 * Created by lvdeluxe on 15-02-15.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.*;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.GTransform;
import com.genome2d.components.renderables.GSlice3Sprite;
import com.genome2d.components.renderables.GSlice9Sprite;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTiledSprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

public class UIManager {

    private var _uiContainer:GNode;


    private var _barContainer:GNode;
    private var _optionsContainer:GNode;
    private var _hudContainer:GNode;
    private var _mainMenuContainer:GNode;

    private var _pauseBtn:GPauseButton;
    private var _resumeBtn:GPauseButton;
    private var _starsLabel:GText;
    private var _logo:GSprite;
    private var _playBtn:GButton;
    private var _optBtn:GButton;
    private var _closeBtn:GCloseButton;

    public function UIManager(pNode:GNode) {
        _uiContainer = pNode;

        GameSignals.CLOSE_POPUP.add(onClosePopup);
        GameSignals.PAUSE.add(onPause);

        setContainers();
        setMainMenu();
        setHUD();
        setOptionsMenu();

        _optionsContainer.transform.visible = false;
        _hudContainer.transform.visible = false;
    }

    private function setContainers():void {
        _mainMenuContainer = GNodeFactory.createNode("mainMenuContainer");
        _hudContainer = GNodeFactory.createNode("hudContainer");
        _optionsContainer = GNodeFactory.createNode("optionsContainer");
        _uiContainer.addChild(_mainMenuContainer);
        _uiContainer.addChild(_hudContainer);
        _uiContainer.addChild(_optionsContainer);
    }

    private function onPause(pPaused:Boolean):void{
        if(pPaused){
            showOptionsMenu(true);
        }else{
            _optionsContainer.transform.visible = false;
            _pauseBtn.node.transform.visible = true;
        }
    }

    private function onClosePopup():void{
        _optionsContainer.transform.visible = false;
        _mainMenuContainer.transform.visible = true;
    }

    private function setHUD():void{
        setPauseButton();
        setPowerupMeter();
    }

    private function setOptionsMenu():void {

        var modal:GTiledSprite = GNodeFactory.createNodeWithComponent(GTiledSprite) as GTiledSprite;
        modal.texture = AssetsManager.getModalTexture();
        modal.width = GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 2);
        modal.height = GameConstants.SCREEN_HEIGHT;
        modal.node.transform.setPosition(-GameConstants.SCREEN_WIDTH / 2  + (GameConstants.TILE_SIZE), -GameConstants.SCREEN_HEIGHT / 2);
        _optionsContainer.addChild(modal.node);

        var bg:GSlice9Sprite = GNodeFactory.createNodeWithComponent(GSlice9Sprite) as GSlice9Sprite;
        bg.texture1 = AssetsManager.getPopupBgTopLeftTexture();
        bg.texture2 = AssetsManager.getPopupBgTopTexture();
        bg.texture3 = AssetsManager.getPopupBgTopRightTexture();
        bg.texture4 = AssetsManager.getPopupBgLeftTexture();
        bg.texture5 = AssetsManager.getPopupBgCenterTexture();
        bg.texture6 = AssetsManager.getPopupBgRightTexture();
        bg.texture7 = AssetsManager.getPopupBgBottomLeftTexture();
        bg.texture8 = AssetsManager.getPopupBgBottomTexture();
        bg.texture9 = AssetsManager.getPopupBgBottomRightTexture();
        bg.width = 520;
        bg.height = 330;
        bg.node.transform.setPosition(-260,-200);
        _optionsContainer.addChild(bg.node);

        _closeBtn = GNodeFactory.createNodeWithComponent(GCloseButton) as GCloseButton;
        _optionsContainer.addChild(_closeBtn.node);
        _closeBtn.node.transform.setPosition((bg.width / 2) - _closeBtn.texture.width, bg.node.transform.y + (_closeBtn.texture.height * 3 / 4));

        _resumeBtn = GNodeFactory.createNodeWithComponent(GPauseButton) as GPauseButton;
        _resumeBtn.isPause = false;
        _optionsContainer.addChild(_resumeBtn.node);
    }

    private function setMainMenu():void{
        _logo = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _logo.texture = AssetsManager.getLogoTexture();
        _mainMenuContainer.addChild(_logo.node);
        _logo.node.transform.y = -(GameConstants.SCREEN_HEIGHT / 2) + (_logo.texture.height / 2);

        _playBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
        _playBtn.setText("play");
        _mainMenuContainer.addChild(_playBtn.node);
        _playBtn.node.transform.y = 0;
        _playBtn.addClickEvent(onClickStart);

        _optBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
        _optBtn.setText("options");
        _mainMenuContainer.addChild(_optBtn.node);
        _optBtn.node.transform.y = 75;
        _optBtn.addClickEvent(onClickOptions);
    }

    private function onClickOptions():void{
        showOptionsMenu(false);
    }

    private function showOptionsMenu(isPause:Boolean):void {
        _optionsContainer.transform.visible = true;
        _mainMenuContainer.transform.visible = false;
        _closeBtn.node.transform.visible = !isPause;
        _resumeBtn.node.transform.visible = isPause;
        _pauseBtn.node.transform.visible = !isPause;
    }

    private function onClickStart():void{
        GameSignals.GAME_START.dispatch();
        _mainMenuContainer.transform.visible = false;
        setGameUI();
    }

    private function setGameUI():void{
        _hudContainer.transform.visible = true;
    }

    private function setPowerupMeter():void {

        var meterContainer:GNode = GNodeFactory.createNode("meterContainer");
        meterContainer.transform.setPosition((-GameConstants.SCREEN_WIDTH / 2) + 38, (-GameConstants.SCREEN_HEIGHT / 2) + 8);
        _hudContainer.addChild(meterContainer);
//
        var meterBox:GSlice3Sprite = GNodeFactory.createNodeWithComponent(GSlice3Sprite) as GSlice3Sprite;
        meterBox.texture1 = AssetsManager.getMeterBoxLeftTexture();
        meterBox.texture2 = AssetsManager.getMeterBoxCenterTexture();
        meterBox.texture3 = AssetsManager.getMeterBoxRightTexture();
        meterBox.width = 240;
        meterBox.height = 41;
        meterContainer.addChild(meterBox.node);
//
        _barContainer = GNodeFactory.createNode("barContainer");
        meterContainer.addChild(_barContainer);
        _barContainer.transform.setPosition(5,5);
        _barContainer.transform.scaleX = 0;
//
        var bar:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        bar.texture = AssetsManager.getMeterBarTexture();
        _barContainer.addChild(bar.node);
        bar.node.transform.setPosition((bar.texture.width / 2), (bar.texture.height / 2));

        var star:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        star.texture = AssetsManager.getStarTexture();
        meterContainer.addChild(star.node);
        star.node.transform.setPosition((star.texture.width / 2) + 5, (star.texture.height / 2) + 5);
//
        _starsLabel = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "futura";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.LEFT;
        renderer.width = 240;
        renderer.height = 32;
        _starsLabel.renderer = renderer;
        _starsLabel.text = "X0";
        _starsLabel.node.transform.setPosition(star.texture.width + 5, 2);
        meterContainer.addChild(_starsLabel.node);


    }

    public function updateNumStars(pNumStars:uint):void{
        _starsLabel.text = "X" + pNumStars.toString();
        _barContainer.transform.scaleX = pNumStars / GameConstants.STARS_FOR_INVINCIBILITY;
    }

    private function setPauseButton():void {
        _pauseBtn = GNodeFactory.createNodeWithComponent(GPauseButton) as GPauseButton;
        _pauseBtn.isPause = true;
        _pauseBtn.verticalRatio = 0.95;
        _pauseBtn.horizontalRatio = 0.95;
        _hudContainer.addChild(_pauseBtn.node);
    }
}
}
