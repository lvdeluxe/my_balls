/**
 * Created by lvdeluxe on 15-02-15.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.GameSignals;
import com.genome2d.components.GTransform;
import com.genome2d.node.GNode;

import flash.utils.setTimeout;

public class UIManager {

    public static const OPTIONS_MAIN_MENU:String = "optionsMainMenu";
    public static const OPTIONS_IN_GAME:String = "optionsInGame";
    public static const OPTIONS_GAME_OVER:String = "optionsGameOver";

    private var _uiContainer:GNode;
    private var _optionsContainer:OptionsNode;
    private var _hudContainer:HUDNode;
    private var _mainMenuContainer:MainMenuNode;
    private var _tutorialContainer:TutorialNode;
//
    private var _isCredits:Boolean = false;
    private var _isTutorial:Boolean = false;

    public function UIManager(pNode:GNode) {
        _uiContainer = pNode;

        GameSignals.CLOSE_POPUP.add(onClosePopup);
        GameSignals.PAUSE.add(onPause);
        GameSignals.QUIT_GAME.add(onQuit);
        GameSignals.UI_OPTIONS.add(onOptions);
        GameSignals.GAME_START.add(onStartGame);
        GameSignals.PLAY_AGAIN.add(onPlayAgain);
        GameSignals.DISPLAY_CREDITS.add(onDisplayCredits);
        GameSignals.DISPLAY_TUTORIAL.add(onDisplayTutorial);
        GameSignals.TUTORIAL_COMPLETE.add(onTutorialComplete);
        setContainers();

        _optionsContainer.transform.visible = false;
        _hudContainer.transform.visible = false;
    }

    private function onTutorialComplete():void{
        _tutorialContainer = null;
    }

    private function onDisplayTutorial():void{
        _isTutorial = true;
    }

    private function onDisplayCredits():void{
        _isCredits = true;
    }

    private function onPlayAgain():void{
        _optionsContainer.transform.visible = false;
        _mainMenuContainer.transform.visible = true;
    }

    private function onStartGame():void{
        _mainMenuContainer.transform.visible = false;
        _hudContainer.transform.visible = true;
    }

    private function onOptions(mode:String):void{
        switch(mode){
            case OPTIONS_MAIN_MENU:
                _optionsContainer.transform.visible = true;
                _mainMenuContainer.transform.visible = false;
                _optionsContainer.setFromMainMenu();
                break;
            case OPTIONS_IN_GAME:
                break;
            case OPTIONS_GAME_OVER:
                break;
        }
    }

    public function displayTutorial(target:GTransform):void{
        setTimeout(function():void{
            _tutorialContainer = new TutorialNode(target, _hudContainer.getStarTransform());
            _uiContainer.addChild(_tutorialContainer);
        }, 1000);
    }

    private function setContainers():void {
        _mainMenuContainer = new MainMenuNode();
        _hudContainer = new HUDNode();
        _optionsContainer = new OptionsNode();

        _uiContainer.addChild(_mainMenuContainer);
        _uiContainer.addChild(_hudContainer);
        _uiContainer.addChild(_optionsContainer);
    }

    private function onPause(pPaused:Boolean):void{
        if(pPaused){
            _optionsContainer.transform.visible = true;
            _hudContainer.transform.visible = false;
            _optionsContainer.setFromInGame();
            if(_tutorialContainer != null)
                _tutorialContainer.setVisible(false);
        }else{
            _optionsContainer.transform.visible = false;
            _hudContainer.transform.visible = true;
            if(_tutorialContainer != null)
                _tutorialContainer.setVisible(true);
        }
    }

    private function onQuit(from:String):void{
        if(from == OPTIONS_GAME_OVER){
            _hudContainer.transform.visible = false;
            _optionsContainer.transform.visible = true;
            _optionsContainer.setFromGameOver();
        }else  if(from == OPTIONS_IN_GAME){
            _hudContainer.transform.visible = false;
            _optionsContainer.transform.visible = false;
            _mainMenuContainer.transform.visible = true;
        }
    }

    private function onClosePopup():void{
        if(_isCredits){
            _isCredits = false;
            _optionsContainer.removeCredits();
        }else if(_isTutorial){
            _isTutorial = false;
            _optionsContainer.removeTutorial();
        }else{
            _optionsContainer.transform.visible = false;
            _mainMenuContainer.transform.visible = true;
        }
    }

    public function updateScore(pScore:uint, pHighScore:int):void{
        _hudContainer.updateScore(pScore);
        _mainMenuContainer.updateHighScore(pHighScore);
    }

    public function updateOptionsScore(pScore:uint, isHighScore:Boolean):void{
        _optionsContainer.updateScore(pScore, isHighScore);
    }

    public function updateNumStars(pNumStars:uint):void{
        _hudContainer.updateNumStars(pNumStars);
    }
}
}
