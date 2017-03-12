/**
 * Created by lvdeluxe on 15-03-15.
 */
package com.deluxe.myballs.ui {
import com.deluxe.Localization;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.plugin.PluginsManager;
import com.deluxe.myballs.ui.UIManager;
import com.genome2d.components.renderables.GSlice9Sprite;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTiledSprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

public class OptionsNode extends GNode{

    public static const CREDITS_FROM_MAIN:String = "creditsFromMain";
    public static const CREDITS_FROM_GAME:String = "creditsFromGame";
    public static const CREDITS_FROM_ENDGAME:String = "creditsFromEndGame";

    private var _musicBtn:GToggleButton;
    private var _sfxBtn:GToggleButton;

    private var _howtoBtn:GButton;
//    private var _moreGamesBtn:GButton;
    private var _creditsBtn:GButton;
    private var _facebookBtn:GSocialButton;
    private var _twitterBtn:GSocialButton;
    private var _gameCenterBtn:GSocialButton;
    private var _mainMenuBtn:GButton;

    private var _closeBtn:GCloseButton;

    private var _resumeBtn:GPauseButton;
    private var _restartBtn:GRestartButton;

    private var _popupFrame:GSlice9Sprite;
    private var _logo:GSprite;

    private var _creditsContainer:OptionContentNode;
    private var _howToContainer:OptionContentNode;

    private var _creditsFrom:String = "";

    private var _offsetBtn:Number = 1.1;

    private var _scoreTf:GText;
    private var _highScoreTf:PowerUpLabel;

    public function OptionsNode() {
        super();
        setModal();
        setFrame();
        setLogo();
        setResumeButton();
        setCloseButton();
        setCreditsButton();
        setFacebookButton();
        setTwitterButton();
        setGameCenterButton();
        setMainMenuButton();
        setHowToButton();
        setSfxButton();
        setMusicButton();
        setRestartButton();
//        setMoreGamesButton();
        setScoreText();
        _creditsContainer = new OptionContentNode(_popupFrame.width, _popupFrame.height, _closeBtn.node.transform.y - (_closeBtn.texture.height / 2), "CREDITS_ID", "CREDITS_CONTENT_ID");
        addChild(_creditsContainer);
        _creditsContainer.transform.visible = false;
        _howToContainer = new OptionContentNode(_popupFrame.width, _popupFrame.height, _closeBtn.node.transform.y - (_closeBtn.texture.height / 2), "HOWTO_ID", "HOWTO_CONTENT_ID");
        addChild(_howToContainer);
        _howToContainer.transform.visible = false;
//        GameSignals.MORE_GAMES_FAILED.add(onMoreGamesFailed);
//        GameSignals.MORE_GAMES_READY.add(onMoreGamesSuccess);
        GameSignals.PLAY_AGAIN.add(onRestart);

    }

    private function onRestart():void{
        _scoreTf.node.transform.visible = false;
        if(_highScoreTf != null){
            _highScoreTf.stopAnimation(function():void{
                _highScoreTf = null;
            });
        }
    }

    private function setScoreText():void{
        _scoreTf = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "impactHUD";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.CENTER;
        renderer.width = _popupFrame.width;
        renderer.height = GameConstants.TILE_SIZE;
        _scoreTf.renderer = renderer;
        _scoreTf.text = "123456 pts";
        _scoreTf.node.transform.setPosition((int)(-_popupFrame.width / 2),(int)(_logo.node.transform.y + (_logo.texture.height * 0.9 / 2)));
        addChild(_scoreTf.node);
        _scoreTf.node.transform.visible = false;
    }


//    private function onMoreGamesSuccess():void{
//        if(_creditsFrom == CREDITS_FROM_ENDGAME)
//            _moreGamesBtn.node.transform.visible = true;
//    }
//
//    private function onMoreGamesFailed():void{
//        _moreGamesBtn.node.transform.visible = false;
//    }

    private function setModal():void{
        var modal:GTiledSprite = GNodeFactory.createNodeWithComponent(GTiledSprite) as GTiledSprite;
        modal.texture = AssetsManager.getModalTexture();
        modal.width = GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 2);
        modal.height = GameConstants.SCREEN_HEIGHT;
        modal.node.transform.setPosition(-GameConstants.SCREEN_WIDTH / 2  + (GameConstants.TILE_SIZE), -GameConstants.SCREEN_HEIGHT / 2);
        addChild(modal.node);
    }

    private function setFrame():void{
        _popupFrame = GNodeFactory.createNodeWithComponent(GSlice9Sprite) as GSlice9Sprite;
        _popupFrame.texture1 = AssetsManager.getPopupBgTopLeftTexture();
        _popupFrame.texture2 = AssetsManager.getPopupBgTopTexture();
        _popupFrame.texture3 = AssetsManager.getPopupBgTopRightTexture();
        _popupFrame.texture4 = AssetsManager.getPopupBgLeftTexture();
        _popupFrame.texture5 = AssetsManager.getPopupBgCenterTexture();
        _popupFrame.texture6 = AssetsManager.getPopupBgRightTexture();
        _popupFrame.texture7 = AssetsManager.getPopupBgBottomLeftTexture();
        _popupFrame.texture8 = AssetsManager.getPopupBgBottomTexture();
        _popupFrame.texture9 = AssetsManager.getPopupBgBottomRightTexture();

        var widthRatio:Number = GameConstants.SCREEN_WIDTH * 0.75;
        var diffWidth:Number = GameConstants.SCREEN_WIDTH - widthRatio;

        _popupFrame.width = widthRatio;
        _popupFrame.height = GameConstants.SCREEN_HEIGHT - (diffWidth);
        _popupFrame.node.transform.setPosition((int)(-_popupFrame.width / 2),(int)(-_popupFrame.height / 2));
        addChild(_popupFrame.node);
    }

    private var _offsetLogoY:Number;

    private function setLogo():void{
        _logo = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _logo.texture = AssetsManager.getLogoTexture();
        _logo.node.transform.setScale(0.75, 0.75);
        _logo.node.transform.y = -(_popupFrame.height / 2) + ((_logo.texture.height * 1.1) / 2);
        _offsetLogoY = ((_logo.texture.height * 1.1) - (_logo.texture.height * 0.75)) / 2;
        addChild(_logo.node);
    }

    private function setResumeButton():void{
        _resumeBtn = GNodeFactory.createNodeWithComponent(GPauseButton) as GPauseButton;
        _resumeBtn.isPause = false;
        _resumeBtn.node.transform.y = 200;
        addChild(_resumeBtn.node);
    }

    private function setCloseButton():void{
        _closeBtn = GNodeFactory.createNodeWithComponent(GCloseButton) as GCloseButton;
        var posY:Number = _logo.node.transform.y - (_logo.texture.height * 0.75 / 2) + (_closeBtn.texture.height / 2);
        var diffY:Number = Math.abs((_popupFrame.height / 2) + posY);
        _closeBtn.node.transform.setPosition((int)((_popupFrame.width / 2) - diffY), (int)(posY));
        addChild(_closeBtn.node);
    }

//    private function setMoreGamesButton():void{
//        _moreGamesBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
//        _moreGamesBtn.setText(Localization.getString("MORE_GAMES_ID"));
//        _moreGamesBtn.node.transform.setPosition((int)(-(_moreGamesBtn.width / 2)), 0);
//        _moreGamesBtn.addClickEvent(onClickMore);
//        addChild(_moreGamesBtn.node);
//        _moreGamesBtn.node.transform.visible = false;
//    }

    private function setCreditsButton():void{
        _creditsBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
        _creditsBtn.setText(Localization.getString("CREDITS_ID"));
        _creditsBtn.node.transform.setPosition((int)(-_creditsBtn.width / 2), 0);
        _creditsBtn.addClickEvent(onClickCredits);
        addChild(_creditsBtn.node);
    }

    private function setFacebookButton():void{
        _facebookBtn = GNodeFactory.createNodeWithComponent(GSocialButton) as GSocialButton;
        _facebookBtn.setLogo(GSocialButton.FACEBOOK);
        _facebookBtn.setText("FACEBOOK");
        _facebookBtn.node.transform.setPosition((int)(-_facebookBtn.width / 2), 0);
        _facebookBtn.addClickEvent(onClickFacebook);
        addChild(_facebookBtn.node);
    }

    private function setTwitterButton():void{
        _twitterBtn = GNodeFactory.createNodeWithComponent(GSocialButton) as GSocialButton;
        _twitterBtn.setLogo(GSocialButton.TWITTER);
        _twitterBtn.setText("TWITTER");
        _twitterBtn.node.transform.setPosition((int)(-_twitterBtn.width / 2), 0);
        _twitterBtn.addClickEvent(onClickTwitter);
        addChild(_twitterBtn.node);
    }

    private function setGameCenterButton():void{
        _gameCenterBtn = GNodeFactory.createNodeWithComponent(GSocialButton) as GSocialButton;
        _gameCenterBtn.setLogo(GSocialButton.GAME_CENTER);
        _gameCenterBtn.setText("GAME CENTER");
        _gameCenterBtn.node.transform.setPosition((int)(-_gameCenterBtn.width / 2), 0);
        _gameCenterBtn.addClickEvent(onClickGameCenter);
        addChild(_gameCenterBtn.node);
    }

    private function setMainMenuButton():void{
        _mainMenuBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
        _mainMenuBtn.setText(Localization.getString("MAIN_ID"));
        _mainMenuBtn.node.transform.setPosition((int)(-_mainMenuBtn.width / 2), 0);
        _mainMenuBtn.addClickEvent(onClickMainMenu);
        addChild(_mainMenuBtn.node);
    }

    private function setHowToButton():void{
        _howtoBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
        _howtoBtn.setText(Localization.getString("HOWTO_ID"));
        _howtoBtn.node.transform.setPosition((int)(-_howtoBtn.width / 2), 0);
        _howtoBtn.addClickEvent(onClickHowTo);
        addChild(_howtoBtn.node);
    }

    private function setSfxButton():void{
        _sfxBtn = GNodeFactory.createNodeWithComponent(GToggleButton) as GToggleButton;
        _sfxBtn.setText(Localization.getString("SFX_ID"));
        _sfxBtn.toggleSignal = GameSignals.TOGGLE_SFX;
        _sfxBtn.node.transform.setPosition((int)(-_sfxBtn.width / 2), 0);
        addChild(_sfxBtn.node);
        _sfxBtn.state = SoundManager.playSfx;
    }

    private function setRestartButton():void{
        _restartBtn = GNodeFactory.createNodeWithComponent(GRestartButton) as GRestartButton;
        _restartBtn.node.transform.setPosition(0, 0);
        addChild(_restartBtn.node);
    }

    private function setMusicButton():void{
        _musicBtn = GNodeFactory.createNodeWithComponent(GToggleButton) as GToggleButton;
        _musicBtn.setText(Localization.getString("MUSIC_ID"));
        _musicBtn.toggleSignal = GameSignals.TOGGLE_MUSIC;
        _musicBtn.node.transform.setPosition((int)(-_musicBtn.width / 2), 0);
        addChild(_musicBtn.node);
        _musicBtn.state = SoundManager.playMusic;
    }

    public function setFromMainMenu():void{
        _creditsFrom = CREDITS_FROM_MAIN;

        var startY_tmp:Number = (int)(_logo.node.transform.y + (_logo.texture.height / 2* 0.75) + _offsetLogoY);
        var endY:Number = (_popupFrame.height / 2) - _offsetLogoY;
        var totalOffset:Number = ((endY - Math.abs(startY_tmp)) / 2);
        var numBtns:uint = 7;
        var total:Number = _musicBtn.texture1.height * numBtns * _offsetBtn;
        var startY:Number = (-total / 2) + totalOffset;
        var offset:Number = (int)(_musicBtn.texture1.height * _offsetBtn);

        _musicBtn.node.transform.visible = true;
        _musicBtn.node.transform.y = startY;
        _sfxBtn.node.transform.visible = true;
        startY += offset;
        _sfxBtn.node.transform.y = startY;
        _howtoBtn.node.transform.visible = true;
        startY += offset;
        _howtoBtn.node.transform.y = startY;
        _creditsBtn.node.transform.visible = true;
        startY += offset;
        _creditsBtn.node.transform.y = startY;
        _gameCenterBtn.node.transform.visible = true;
        startY += offset;
        _gameCenterBtn.node.transform.y = startY;
        _twitterBtn.node.transform.visible = true;
        startY += offset;
        _twitterBtn.node.transform.y = startY;
        _facebookBtn.node.transform.visible = true;
        startY += offset;
        _facebookBtn.node.transform.y = startY;

        _closeBtn.node.transform.visible = true;

        _mainMenuBtn.node.transform.visible = false;
        _resumeBtn.node.transform.visible = false;
        _restartBtn.node.transform.visible = false;
//        _moreGamesBtn.node.transform.visible = false;
    }

    public function setFromInGame():void{
        _creditsFrom = CREDITS_FROM_GAME;

        var startY_tmp:Number = (int)(_logo.node.transform.y + (_logo.texture.height / 2* 0.75) + _offsetLogoY);
        var endY:Number = (_popupFrame.height / 2) - (_offsetLogoY * 2) - _resumeBtn.texture.height;
        var totalOffset:Number = ((endY - Math.abs(startY_tmp)) / 2);
        var numBtns:uint = 5;
        var total:Number = _musicBtn.texture1.height * numBtns * _offsetBtn;
        var startY:Number = (int)((-total / 2) + totalOffset);
        var offset:Number = (int)(_musicBtn.texture1.height * _offsetBtn);

        _musicBtn.node.transform.visible = true;
        _musicBtn.node.transform.y = startY;
        startY += offset;
        _sfxBtn.node.transform.y = startY;
        _sfxBtn.node.transform.visible = true;
        startY += offset;
        _howtoBtn.node.transform.y = startY;
        _howtoBtn.node.transform.visible = true;
        startY += offset;
        _creditsBtn.node.transform.y = startY;
        _creditsBtn.node.transform.visible = true;
        startY += offset;
        _mainMenuBtn.node.transform.y = startY;
        _mainMenuBtn.node.transform.visible = true;

        _resumeBtn.node.transform.visible = true;
        _resumeBtn.node.transform.y = (_popupFrame.height / 2) -  (_resumeBtn.texture.height / 2) - _offsetLogoY;

        _closeBtn.node.transform.visible = false;
        _facebookBtn.node.transform.visible = false;
        _twitterBtn.node.transform.visible = false;
        _gameCenterBtn.node.transform.visible = false;
        _restartBtn.node.transform.visible = false;
//        _moreGamesBtn.node.transform.visible = false;
    }

    public function setFromGameOver():void{
        _creditsFrom = CREDITS_FROM_ENDGAME;
        var startY_tmp:Number = (int)(_logo.node.transform.y + (_logo.texture.height / 2* 0.75) + _offsetLogoY);
        var endY:Number = (_popupFrame.height / 2) - (_offsetLogoY * 2) - _resumeBtn.texture.height;
        var totalOffset:Number = ((endY - Math.abs(startY_tmp)) / 2);
        var numBtns:uint = 4;
        var total:Number = _musicBtn.texture1.height * numBtns * _offsetBtn;
        var startY:Number = (int)((-total / 2) + totalOffset);
        var offset:Number = (int)(_musicBtn.texture1.height * _offsetBtn);

        _gameCenterBtn.node.transform.visible = true;
        _gameCenterBtn.node.transform.y = startY;
        startY += offset;
        _twitterBtn.node.transform.visible = true;
        _twitterBtn.node.transform.y = startY;
        startY += offset;
        _facebookBtn.node.transform.visible = true;
        _facebookBtn.node.transform.y = startY;
//        startY += offset;
//        _moreGamesBtn.node.transform.visible = PluginsManager.hasModeApps();
//        _moreGamesBtn.node.transform.y = startY;

        _restartBtn.node.transform.visible = true;
        _restartBtn.node.transform.y = (_popupFrame.height / 2) -  (_restartBtn.texture.height / 2) - _offsetLogoY;

        _resumeBtn.node.transform.visible = false;
        _creditsBtn.node.transform.visible = false;
        _howtoBtn.node.transform.visible = false;
        _sfxBtn.node.transform.visible = false;
        _musicBtn.node.transform.visible = false;
        _closeBtn.node.transform.visible = false;
        _mainMenuBtn.node.transform.visible = false;
    }

    private function onClickMainMenu():void{
        GameSignals.QUIT_GAME.dispatch(UIManager.OPTIONS_IN_GAME);
    }

    private function onClickMore():void{
        GameSignals.MORE_GAMES_DISPLAY.dispatch();
    }

    private function onClickGameCenter():void{
        GameSignals.DISPLAY_GAME_CENTER.dispatch();
    }

    private function onClickTwitter():void{
        GameSignals.DISPLAY_TWITTER.dispatch(_creditsFrom);
    }

    private function onClickFacebook():void{
        GameSignals.DISPLAY_FACEBOOK.dispatch(_creditsFrom);
    }

    private function onClickCredits():void{
        displayCredits();
        GameSignals.DISPLAY_CREDITS.dispatch();
    }

    private function onClickHowTo():void{
        displayTutorial();
        GameSignals.DISPLAY_TUTORIAL.dispatch();
    }

    public function removeTutorial():void{
        _howToContainer.transform.visible = false;
        _logo.node.transform.visible = true;
        switch(_creditsFrom){
            case CREDITS_FROM_MAIN:
                setFromMainMenu();
                break;
            case CREDITS_FROM_GAME:
                setFromInGame();
                break;
        }
    }

    public function removeCredits():void{
        _creditsContainer.transform.visible = false;
        _logo.node.transform.visible = true;
        switch(_creditsFrom){
            case CREDITS_FROM_MAIN:
                setFromMainMenu();
                break;
            case CREDITS_FROM_GAME:
                setFromInGame();
                break;
        }
    }

    private function displayTutorial():void{
        _howToContainer.transform.visible = true;
        _closeBtn.node.transform.visible = true;

        _logo.node.transform.visible = false;
        _musicBtn.node.transform.visible = false;
        _sfxBtn.node.transform.visible = false;
        _howtoBtn.node.transform.visible = false;
        _creditsBtn.node.transform.visible = false;
        _gameCenterBtn.node.transform.visible = false;
        _twitterBtn.node.transform.visible = false;
        _facebookBtn.node.transform.visible = false;
        _mainMenuBtn.node.transform.visible = false;
        _resumeBtn.node.transform.visible = false;
        _restartBtn.node.transform.visible = false;
    }

    private function displayCredits():void{
        _creditsContainer.transform.visible = true;
        _closeBtn.node.transform.visible = true;

        _logo.node.transform.visible = false;
        _musicBtn.node.transform.visible = false;
        _sfxBtn.node.transform.visible = false;
        _howtoBtn.node.transform.visible = false;
        _creditsBtn.node.transform.visible = false;
        _gameCenterBtn.node.transform.visible = false;
        _twitterBtn.node.transform.visible = false;
        _facebookBtn.node.transform.visible = false;
        _mainMenuBtn.node.transform.visible = false;
        _resumeBtn.node.transform.visible = false;
        _restartBtn.node.transform.visible = false;
    }

    public function updateScore(pScoreTmp:uint, isHighScore:Boolean):void {
        _scoreTf.node.transform.visible = true;
        _scoreTf.text = pScoreTmp.toString() + " pts";
        if(isHighScore && _highScoreTf == null){
            _highScoreTf = new PowerUpLabel(Localization.getString("HIGH_SCORE"));
            _highScoreTf.transform.setPosition((int)(-_popupFrame.width / 2),(int)(_scoreTf.node.transform.y + GameConstants.TILE_SIZE));
            addChild(_highScoreTf);
        }
    }
}
}
