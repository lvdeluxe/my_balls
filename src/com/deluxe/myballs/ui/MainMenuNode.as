/**
 * Created by lvdeluxe on 15-03-16.
 */
package com.deluxe.myballs.ui {
import com.deluxe.Localization;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.plugin.PluginsManager;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

public class MainMenuNode extends GNode{

    private var _playBtn:GButton;
    private var _optBtn:GButton;
//    private var _moreBtn:GButton;
    private var _logo:GSprite;
    private var _scoreTf:GText;

    public function MainMenuNode() {
        super();
        setLogo();
        setOptionsButton();
        setStartGameButton();
//        setMoreGamesButton();
        setScoreText();
//        GameSignals.MORE_GAMES_FAILED.add(onMoreGamesFailed);
//        GameSignals.MORE_GAMES_READY.add(onMoreGamesSuccess);
    }

//    private function onMoreGamesSuccess():void{
//        _moreBtn.node.transform.visible = true;
//    }
//    private function onMoreGamesFailed():void{
//        _moreBtn.node.transform.visible = false;
//    }

    private function setScoreText():void {
        var ratio:Number = 48/60;
        _scoreTf = GNodeFactory.createNodeWithComponent(GText) as GText;
        var renderer:GTextureTextRenderer = new GTextureTextRenderer();
        renderer.textureAtlasId = "impactTitle";
        renderer.vAlign = GVAlignType.MIDDLE;
        renderer.hAlign = GHAlignType.CENTER;
        renderer.width = GameConstants.SCREEN_WIDTH;
        renderer.height = _playBtn.height;
        _scoreTf.renderer = renderer;
        _scoreTf.node.transform.setPosition(-(GameConstants.SCREEN_WIDTH / 2) * ratio, (_logo.node.transform.y + (_logo.texture.height / 2)) + (_scoreTf.height / 4));
        _scoreTf.node.transform.setScale(ratio, ratio);
        _scoreTf.text = "SCORE : 1000pts";
        addChild(_scoreTf.node);
    }

    private function setLogo():void{
        _logo = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _logo.texture = AssetsManager.getLogoTexture();
        addChild(_logo.node);
        var third:Number = uint (GameConstants.SCREEN_HEIGHT / 6);
        _logo.node.transform.y = -(GameConstants.SCREEN_HEIGHT / 2) + third;
    }

//    private function setMoreGamesButton():void{
//        _moreBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
//        _moreBtn.setText(Localization.getString("MORE_GAMES_ID"));
//        _moreBtn.node.transform.x = (int)(-(_moreBtn.width / 2));
//        _moreBtn.node.transform.y = (int)(_optBtn.node.transform.y + (Math.abs(_playBtn.node.transform.y - _optBtn.node.transform.y)));
//        _moreBtn.addClickEvent(onClickMore);
//        addChild(_moreBtn.node);
//        _moreBtn.node.transform.visible = PluginsManager.hasModeApps();
//    }

    private function setStartGameButton():void{
        _playBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
        _playBtn.setText(Localization.getString("PLAY_ID"));
        _playBtn.node.transform.x = (int)(-(_playBtn.width / 2));
        _playBtn.node.transform.y = (int)(-_playBtn.height / 1.5);
        _playBtn.addClickEvent(onClickStart);
        addChild(_playBtn.node);
    }

    private function setOptionsButton():void{
        _optBtn = GNodeFactory.createNodeWithComponent(GButton) as GButton;
        _optBtn.setText(Localization.getString("OPTIONS_ID"));
        _optBtn.node.transform.x = (int)(-(_optBtn.width / 2));
        _optBtn.node.transform.y = (int)(_optBtn.height / 1.5);
        _optBtn.addClickEvent(onClickOptions);
        addChild(_optBtn.node);
    }
//
//    private function onClickMore():void{
//        GameSignals.MORE_GAMES_DISPLAY.dispatch();
//    }

    private function onClickOptions():void{
        GameSignals.UI_OPTIONS.dispatch(UIManager.OPTIONS_MAIN_MENU);
    }

    private function onClickStart():void{
        GameSignals.GAME_START.dispatch();
    }

    public function updateHighScore(pHighScore:int):void {
        _scoreTf.text = "SCORE : " + pHighScore.toString() + "pts";
    }
}
}
