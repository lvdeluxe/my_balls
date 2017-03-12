/**
* Created by lvdeluxe on 15-03-15.
*/
package com.deluxe.myballs.plugin {
import com.adobe.ane.gameCenter.GameCenterAuthenticationEvent;
import com.adobe.ane.gameCenter.GameCenterController;
import com.adobe.ane.gameCenter.GameCenterLeaderboardEvent;
import com.adobe.ane.gameCenter.GameCenterLeaderboardPlayerScope;
import com.adobe.ane.gameCenter.GameCenterLeaderboardTimeScope;
import com.adobe.ane.gameCenter.GameCenterScore;
import com.adobe.ane.social.SocialServiceType;
import com.adobe.ane.social.SocialUI;
import com.chartboost.plugin.air.CBLoadError;
import com.chartboost.plugin.air.CBLocation;
import com.chartboost.plugin.air.Chartboost;
import com.chartboost.plugin.air.ChartboostEvent;
import com.deluxe.Localization;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.ui.OptionsNode;

import flash.media.SoundMixer;
import flash.media.SoundTransform;

import flash.utils.setTimeout;

public class PluginsManager {

    public static var IS_SOCIAL_SUPPORTED:Boolean = false;
    public static var IS_GAMECENTER_SUPPORTED:Boolean = false;

    CONFIG::release {
        private var _chartboost:Chartboost;
        private var _gameCenter:GameCenterController;
        private var _adLoaded:Boolean = false;

        private var _leaderboardName:String = "beFall2";
        private var _gameCenterCallback:Function;
    }

    private var _highScore:int = 0;

    private static var _instance:PluginsManager;


    public function PluginsManager(callback:Function) {
        _instance = this;
        CONFIG::release {
            _gameCenterCallback = callback;
            setAdFramework();
            setGameCenterFramework();
            if(SocialUI.isSupported){
                IS_SOCIAL_SUPPORTED = true;
                GameSignals.DISPLAY_FACEBOOK.add(onFacebook);
                GameSignals.DISPLAY_TWITTER.add(onTwitter);
                GameSignals.DISPLAY_GAME_CENTER.add(onGameCenter);
                GameSignals.HIGH_SCORE.add(onHighScore);
            }
            GameSignals.QUIT_GAME.add(onQuitGame);
        }
        CONFIG::debug{
            setTimeout(callback, 500);
        }
    }

    public function showInterstitial():void{
        CONFIG::release {
            if(_adLoaded)
                _chartboost.showRewardedVideo(CBLocation.GAME_OVER);
            //_chartboost.cacheMoreApps(CBLocation.MAIN_MENU);
        }
    }

    public function loadInterstitial():void{
        CONFIG::release {
            trace("loadInterstitial");
            _adLoaded = false;
            _chartboost.cacheRewardedVideo(CBLocation.DEFAULT);
        }
    }

//    public static function hasModeApps():Boolean{
////        if(_instance._chartboost.hasMoreApps(CBLocation.HOME_SCREEN)){
////            return true;
////        }
//        CONFIG::release {
//            return _instance._chartboost.hasMoreApps(CBLocation.HOME_SCREEN)
//        }
//        CONFIG::debug {
//            return false;
//        }
//    }

    CONFIG::release {

        private function onQuitGame(from:String):void{
//            _chartboost.cacheMoreApps(CBLocation.GAME_OVER);
        }

        private function onInterstitialLoaded(location:String):void{
            _adLoaded = true;
            trace("onInterstitialLoaded");
        }

//        private function onMoreAppsLoaded(location:String):void{
//
//            GameSignals.MORE_GAMES_READY.dispatch();
//
//            trace("onMoreAppsLoaded");
//        }



//        private function onDisplayMoreApps():void{
//            if(_chartboost.hasMoreApps(CBLocation.HOME_SCREEN)){
//                _chartboost.showMoreApps(CBLocation.HOME_SCREEN);
//            }else if(_chartboost.hasMoreApps(CBLocation.GAME_OVER)){
//                _chartboost.showMoreApps(CBLocation.GAME_OVER);
//            }
//        }

        private function onInterstitialFailed(location:String, error:CBLoadError):void{
            trace(error.Text);
        }

//        private function onMoreAppsFailed(location:String, error:CBLoadError):void{
//            trace("onMoreAppsFailed", error.Text);
//            GameSignals.MORE_GAMES_FAILED.dispatch();
//        }

    private function setAdFramework():void{
        _chartboost = Chartboost.getInstance();
        if (Chartboost.isIOS()) {
            _chartboost.startWith("5527005c0d602565c4efe19f", "2a9c5ff535369217175fd4accbc62ba0485f984a");
            _chartboost.addDelegateEvent(ChartboostEvent.DID_CACHE_REWARDED_VIDEO, onInterstitialLoaded);
            _chartboost.addDelegateEvent(ChartboostEvent.DID_FAIL_TO_LOAD_REWARDED_VIDEO, onInterstitialFailed);
//            _chartboost.addDelegateEvent(ChartboostEvent.DID_CACHE_MORE_APPS, onMoreAppsLoaded);
//            _chartboost.addDelegateEvent(ChartboostEvent.DID_FAIL_TO_LOAD_MOREAPPS, onMoreAppsFailed);
            _chartboost.addDelegateEvent(ChartboostEvent.DID_CLOSE_REWARDED_VIDEO, onCloseVideo);
            _chartboost.addDelegateEvent(ChartboostEvent.DID_DISMISS_REWARDED_VIDEO, onCloseVideo);
            _chartboost.addDelegateEvent(ChartboostEvent.WILL_DISPLAY_VIDEO, onStartVideo);
//            GameSignals.MORE_GAMES_DISPLAY.add(onDisplayMoreApps);
//            _chartboost.cacheMoreApps(CBLocation.HOME_SCREEN);
        }
    }

        private function onStartVideo(level:String):void{
            SoundMixer.soundTransform = new SoundTransform(0);
        }

        private function onCloseVideo(level:String):void{
            SoundMixer.soundTransform = new SoundTransform(1);
        }

    private function onGameCenter():void{
        _gameCenter.showLeaderboardView();
    }

    public function onHighScore(pScore:uint):void{
        if(pScore > _highScore){
            _highScore = pScore;
        }
        if (GameCenterController.isSupported) {
            trace ("onHighScore = ", pScore.toString(), _highScore.toString());
            if(pScore > _highScore){
                trace ("submitScore");
                _gameCenter.submitScore(pScore,_leaderboardName);
            }
        }
    }

    private function onFacebook(from:String):void{
        var facebook:SocialUI = new SocialUI(SocialServiceType.FACEBOOK);
        var msg:String = from == OptionsNode.CREDITS_FROM_MAIN ? Localization.getString("SOCIAL_MSG_ID") + "\n": Localization.getString("SOCIAL_SCORE_MSG_ID") + _highScore.toString() + "pts!" + "\n";
        facebook.setMessage(msg);
        facebook.addImage(AssetsManager.GetSocialLogo());
        facebook.addURL("https://lvdeluxegames.wordpress.com/");
        facebook.launch();
    }

    private function onTwitter(from:String):void{
        var twitter:SocialUI = new SocialUI(SocialServiceType.TWITTER);
        var msg:String = from == OptionsNode.CREDITS_FROM_MAIN ? Localization.getString("SOCIAL_MSG_ID") + "\n": Localization.getString("SOCIAL_SCORE_MSG_ID") + _highScore.toString() + "pts!" + "\n";
        twitter.setMessage(msg);
        twitter.addImage(AssetsManager.GetSocialLogo());
        twitter.addURL("https://lvdeluxegames.wordpress.com/");
        twitter.launch();
    }

    private function setGameCenterFramework():void{
        if (GameCenterController.isSupported) {
            _gameCenter = new GameCenterController();
            setGameCenterListeners();
            if (!_gameCenter.authenticated) {
                trace ("player not auth, request auth\n");

                _gameCenter.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, authTrue);
                _gameCenter.authenticate();
            }else{
                trace ("player authenticated, request Scores\n");
                _gameCenter.requestScores(100,_leaderboardName,GameCenterLeaderboardPlayerScope.GLOBAL,GameCenterLeaderboardTimeScope.ALLTIME,[_gameCenter.localPlayer]);
            }
        }else{
            _gameCenterCallback();
        }
    }

        private function setGameCenterListeners():void{
            _gameCenter.addEventListener(GameCenterAuthenticationEvent.PLAYER_NOT_AUTHENTICATED,authFailed);
            _gameCenter.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATION_CHANGED,authChanged);
            _gameCenter.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_SUCCEEDED,submitScoreSucceed);
            _gameCenter.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_FAILED,submitScoreFailed);
            _gameCenter.addEventListener(GameCenterLeaderboardEvent.SCORES_LOADED,requestedScoresLoaded);
            _gameCenter.addEventListener(GameCenterLeaderboardEvent.SCORES_FAILED,requestedScoresFailed);
            _gameCenter.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_VIEW_FINISHED,leadearboardViewFinished);
            _gameCenter.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_CATEGORIES_FAILED,leadearboardCategoriesFailed);
            _gameCenter.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_CATEGORIES_LOADED,leadearboardCategoriesSucceed);
        }

        protected function leadearboardCategoriesFailed(event:GameCenterLeaderboardEvent):void{
            trace ("leadearboardCategoriesFailed");
        }

        protected function leadearboardCategoriesSucceed(event:GameCenterLeaderboardEvent):void{
            trace ("leadearboardCategoriesSucceed", event.leaderboardCategories);
        }
        protected function leadearboardViewFinished(event:GameCenterLeaderboardEvent):void{
            trace ("leadearboardViewFinished");
        }

        protected function submitScoreFailed(event:GameCenterLeaderboardEvent):void
        {
            trace ("submitScoreFailed", event.leaderboardCategories);
        }

        protected function submitScoreSucceed(event:GameCenterLeaderboardEvent):void
        {
            trace ("submitScoreSucceed");
        }

        protected function authChanged(event:GameCenterAuthenticationEvent):void
        {
//            _tf.text += ("authChanged\n");
        }

        protected function authFailed(event:GameCenterAuthenticationEvent):void
        {
            _gameCenterCallback();
        }

        protected function requestedScoresFailed(event:GameCenterLeaderboardEvent):void
        {
            _gameCenterCallback();
        }

        protected function requestedScoresLoaded(event:GameCenterLeaderboardEvent):void
        {
            trace ("requestedScoresLoaded");
            for each ( var score : GameCenterScore in event.scores)
            {
                if(score.player.id == _gameCenter.localPlayer.id){
                    _gameCenter.requestLeaderboardCategories();
                    IS_GAMECENTER_SUPPORTED = true;
                    _highScore = score.value;
                    _gameCenterCallback();
                    trace ("player score = ", score.value.toString());
                }
            }

        }

    protected function authTrue(event:GameCenterAuthenticationEvent):void
    {
        trace ("player authenticated, authTrue\n");
        if(_gameCenter.localPlayer!=null){
            trace ("_gameCenter.localPlayer exists, requests scores");
            _gameCenter.requestScores(100,_leaderboardName,GameCenterLeaderboardPlayerScope.GLOBAL,GameCenterLeaderboardTimeScope.ALLTIME,[_gameCenter.localPlayer]);
        }else{
            trace ("_gameCenter.localPlayer not exists");
            _gameCenterCallback();
        }

    }
    }


    public function get highScore():int {
        return _highScore;
    }
}
}
