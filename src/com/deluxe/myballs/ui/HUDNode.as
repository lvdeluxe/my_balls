/**
 * Created by lvdeluxe on 15-03-16.
 */
package com.deluxe.myballs.ui {
import com.deluxe.Localization;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.GTransform;
import com.genome2d.components.renderables.GSlice3Sprite;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

import flash.globalization.NumberFormatter;
import flash.system.Capabilities;

public class HUDNode extends GNode{

    private var _pauseBtn:GPauseButton;

    private var _starsBox:GSlice3Sprite;
    private var _scoreBox:GSlice3Sprite;

    private var _starsLabel:GText;
    private var _scoreLabel:GText;

    private var _scoreFormatter:NumberFormatter;

    private var _offset:Number;

    private var powerupLabels:Vector.<PowerUpLabel> = new Vector.<PowerUpLabel>();
    private var _starBonusLabel:PowerUpLabel;
    private var _gravityBonusLabel:PowerUpLabel;
    private var _ballBonusLabel:PowerUpLabel;
    private var _invincibilityBonusLabel:PowerUpLabel;
    private var _star:GSprite;

    public function HUDNode() {
        super();
        GameSignals.STAR_BONUS_START.add(onStarsBonusStart);
        GameSignals.STAR_BONUS_END.add(onStarBonusEnd);
        GameSignals.GRAVITY_BONUS_START.add(onGravityBonusStart);
        GameSignals.GRAVITY_BONUS_END.add(onGravityBonusEnd);
        GameSignals.INVINCIBILITY_BONUS_START.add(onInvincibilityStart);
        GameSignals.BALL_INVINCIBILITY_END.add(onInvicibilityBonusEnd);
        GameSignals.BALLS_BONUS_START.add(onBallBonusStart);
        GameSignals.BALLS_BONUS_END.add(onBallBonusEnd);

        _scoreFormatter = new NumberFormatter(Capabilities.language);
        _scoreFormatter.groupingSeparator = " ";
//        if(Capabilities.language == "fr"){
//            _scoreFormatter.groupingSeparator = " ";
//        }
        _scoreFormatter.trailingZeros = false;

        _offset = uint(GameConstants.TILE_SIZE / 5);

        setStarsLabel();
        setScoreLabel();
        setPauseBtn();
    }

    private function onGravityBonusEnd():void{
        if(_gravityBonusLabel != null){
            removePowerupLabel(_gravityBonusLabel);
            _gravityBonusLabel = null;
        }
    }

    private function onBallBonusEnd():void{
        if(_ballBonusLabel != null){
            removePowerupLabel(_ballBonusLabel);
            _ballBonusLabel = null;
        }
    }

    private function onStarBonusEnd():void{
        if(_starBonusLabel != null){
            removePowerupLabel(_starBonusLabel);
            _starBonusLabel = null;
        }
    }
    private function onInvicibilityBonusEnd():void{
        if(_invincibilityBonusLabel != null){
            removePowerupLabel(_invincibilityBonusLabel);
            _invincibilityBonusLabel = null;
        }
    }

    private function onGravityBonusStart():void{
        if(_gravityBonusLabel == null)
            _gravityBonusLabel = addPowerupLabel(Localization.getString("POWERUP_GRAVITY_ID"));
        setPowerUpsPositions();
    }
    private function onBallBonusStart():void{
        if(_ballBonusLabel == null)
            _ballBonusLabel = addPowerupLabel(Localization.getString("POWERUP_BALL_ID"));
        setPowerUpsPositions();
    }
    private function onStarsBonusStart():void{
        if(_starBonusLabel == null)
            _starBonusLabel  = addPowerupLabel(Localization.getString("POWERUP_STARS_ID"));
        setPowerUpsPositions();
    }
    private function onInvincibilityStart():void{
        if(_invincibilityBonusLabel == null)
            _invincibilityBonusLabel = addPowerupLabel(Localization.getString("INDESTRUCTIBLE_ID"));
        setPowerUpsPositions();
    }

    private function setPowerUpsPositions():void{
        for (var i:int = 0; i < powerupLabels.length; i++) {
            powerupLabels[i].updatePosition(i);
        }
    }

    private function removePowerupLabel(label:PowerUpLabel):void{
        var index:int = powerupLabels.indexOf(label);
        var destroy:Function = function():void{
            powerupLabels.splice(index,1);
            label = null;
            setPowerUpsPositions();
        };
        label.stopAnimation(destroy);

    }

    private function addPowerupLabel(txt:String):PowerUpLabel{
        var powerupLabel:PowerUpLabel = new PowerUpLabel(txt);
        addChild(powerupLabel);
        powerupLabels.push(powerupLabel);
        return powerupLabel;
    }

    private function setScoreLabel():void{
        _scoreBox = GNodeFactory.createNodeWithComponent(GSlice3Sprite) as GSlice3Sprite;
        _scoreBox.texture1 = AssetsManager.getHUDBoxLeftTexture();
        _scoreBox.texture2 = AssetsManager.getHUDBoxCenterTexture();
        _scoreBox.texture3 = AssetsManager.getHUDBoxRightTexture();
        _scoreBox.height = _starsBox.texture1.height;
        _scoreBox.width = 200;
        _scoreBox.node.transform.setPosition((int)((GameConstants.SCREEN_WIDTH / 2) - (_offset / 2) - GameConstants.TILE_SIZE - _scoreBox.width), (int)(-(GameConstants.SCREEN_HEIGHT / 2) + (_offset / 2)));
        addChild(_scoreBox.node);

        _scoreLabel = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "impactHUD";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.RIGHT;
        renderer.autoSize = true;
        _scoreLabel.renderer = renderer;
        _scoreLabel.text = "12345pts";
        _scoreLabel.node.transform.setPosition(0,(int)(_starsBox.node.transform.y + ((_starsBox.height - _starsLabel.renderer.height) / 2)) + (int)(_offset / 2));
        addChild(_scoreLabel.node);
    }

    public function getStarTransform():GTransform{
        if(_starsBox != null)
            return _starsBox.node.transform;
        else return null;
    }

    private function setStarsLabel():void{
        _starsBox = GNodeFactory.createNodeWithComponent(GSlice3Sprite) as GSlice3Sprite;
        _starsBox.texture1 = AssetsManager.getHUDBoxLeftTexture();
        _starsBox.texture2 = AssetsManager.getHUDBoxCenterTexture();
        _starsBox.texture3 = AssetsManager.getHUDBoxRightTexture();
        _starsBox.height = _starsBox.texture1.height;
        _starsBox.width = 200;
        _starsBox.node.transform.setPosition((int)(-(GameConstants.SCREEN_WIDTH / 2) + (_offset / 2)) + (GameConstants.TILE_SIZE), -(GameConstants.SCREEN_HEIGHT / 2) + (_offset / 2));
        addChild(_starsBox.node);

        _star = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _star.texture = AssetsManager.getStarTexture();
        addChild(_star.node);
        _star.node.transform.setPosition(-(GameConstants.SCREEN_WIDTH / 2) + (_star.texture.width / 2) + (_offset * 2) + GameConstants.TILE_SIZE,_starsBox.node.transform.y + (_starsBox.texture1.height / 2));

        _starsLabel = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "impactHUD";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.LEFT;
        renderer.autoSize = true;
        _starsLabel.renderer = renderer;
        _starsLabel.text = GameConstants.START_STARS.toString();
        _starsLabel.node.transform.setPosition((int)(_star.node.transform.x + (_star.texture.width / 2)),(int)(_starsBox.node.transform.y + ((_starsBox.height - _starsLabel.renderer.height) / 2)) + (int)(_offset / 2));
        addChild(_starsLabel.node);
    }

    private function setPauseBtn():void {
        _pauseBtn = GNodeFactory.createNodeWithComponent(GPauseButton) as GPauseButton;
        _pauseBtn.isPause = true;
        _pauseBtn.verticalRatio = 0.95;
        _pauseBtn.horizontalRatio = 0.95;
        addChild(_pauseBtn.node);
    }

    public function updateNumStars(pNumStars:uint):void{
        _starsLabel.text = pNumStars.toString();
        _starsBox.width = uint((_starsLabel.renderer.width + _star.texture.width) * 1.4);
    }

    public function updateScore(pScore:uint):void {
        if(pScore < 10)
            _scoreLabel.text = " " + _scoreFormatter.formatInt(pScore) + "pts";
        else
            _scoreLabel.text = _scoreFormatter.formatInt(pScore) + "pts";
        _scoreBox.width = (Math.ceil((_scoreLabel.renderer.width * 1.2) / (40 * (GameConstants.ASSETS_SCALE * 1.5)))) * (40 * (GameConstants.ASSETS_SCALE * 1.5));
        _scoreBox.node.transform.x = uint((GameConstants.SCREEN_WIDTH / 2) - (_offset / 2) - GameConstants.TILE_SIZE - _scoreBox.width);
        _scoreLabel.node.transform.x = _scoreBox.node.transform.x + ((_scoreBox.width - _scoreLabel.renderer.width) / 2);
    }
}
}
