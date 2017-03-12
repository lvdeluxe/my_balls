/**
 * Created by lvdeluxe on 15-01-28.
 */
package {
import aze.motion.EazeTween;
import aze.motion.easing.Expo;
import aze.motion.easing.Quadratic;
import aze.motion.easing.Quint;
import aze.motion.eaze;

import com.deluxe.Localization;

import com.deluxe.myballs.AccelerometerController;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.AssetsSD;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.audio.SoundManager;
import com.deluxe.myballs.game.GBall;
import com.deluxe.myballs.game.GStar;
import com.deluxe.myballs.game.GUpperWall;
import com.deluxe.myballs.particles.BallExplodeParticles;
import com.deluxe.myballs.particles.VerticalSteamParticles;
import com.deluxe.myballs.physics.NapeComponent;
import com.deluxe.myballs.plugin.PluginsManager;
import com.deluxe.myballs.physics.GNapePhysics;
import com.deluxe.myballs.particles.ParticlesFactory;
import com.deluxe.myballs.ui.UIManager;
import com.deluxe.myballs.game.platforms.GPlatformFactory;
import com.deluxe.myballs.game.GWall;
import com.deluxe.myballs.game.platforms.GPlatform;
import com.deluxe.myballs.utils.ExtendedTimer;
import com.genome2d.Genome2D;
import com.genome2d.components.GCameraController;
import com.genome2d.components.GTransform;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.textures.factories.GTextureFactory;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Bitmap;

import flash.events.TimerEvent;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.net.SharedObject;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.utils.setInterval;
import flash.utils.setTimeout;

import nape.phys.Body;

import com.genome2d.context.GContextConfig;
import com.genome2d.context.stats.GStats;
import com.genome2d.node.GNode;
import com.genome2d.node.GNodePool;
import com.genome2d.textures.GTexture;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.util.ShapeDebug;

[SWF(width='640', height='640', backgroundColor='#000000', frameRate='60')]
public class Main extends Sprite{

	private var _genome:Genome2D;
	private var _physics:GNapePhysics;
	CONFIG::debug {
	    private var _physicsDebug:ShapeDebug;
	}
	private var _camera:GCameraController;
	private var _accelero:AccelerometerController;
	private var _camSpeed:Number = 12;

	private var _background512:GSprite;
	private var _background256:GSprite;
	private var _prevCameraPos:Number = 0;
	private var _uvTileRatio:Number = 1/32;
	private var _diffY:Number = 0;
	private var _ballDiffY:Number = 0;
	private var _prevBallPos:Number = 0;
	private var _wallLeft:GWall;
	private var _wallRight:GWall;
	private var _wallTexture:GTexture;

	private var _markersPool:GNodePool;

	private var _offsetY:Number;
	private var _markers:Vector.<GNode> = new Vector.<GNode>();
	private var _visibleRect:Rectangle = new Rectangle();
	private var _lastCreated:GNode;
    private var _gameOverContainer:GNode;
    private var _guiContainer:GNode;

    private var _bgContainer:GNode;
    private var _ballContainer:GNode;
    private var _platformsContainer:GNode;
    private var _particlesContainer:GNode;
    private var _wallsContainer:GNode;
    private var _foregroundContainer:GNode;

    private var _prevBallY:Number = 0;
    private var _balls:Vector.<GBall>;
    private var _ballShadows:Vector.<GNode>;

    private var _uiManager:UIManager;

    private var _starMultiplier:uint = 1;

    private var _numCollectedStars:uint = 0;

    private var _gravityTimer:ExtendedTimer;
    private var _bonusTimer:ExtendedTimer;
    private var _invincibilityTimer:ExtendedTimer;

    private var _gameStarted:Boolean = false;
    private var _gamePaused:Boolean = false;

    private var _firstPlatform:GPlatform;
    private var _startTestRects:Boolean = false;
    private var _camTargetY:Number;
    private var _camTargetOffset:Number = GameConstants.PLATFORM_OFFSET;
    private var _shatteredGlass:GSprite;

    private var _moveMultiplier:Number = 1;

    private var _ballExplodeParticles:BallExplodeParticles;

    public static var mainCamera:GCameraController;
    private var _plugins:PluginsManager;

    private var _score:uint = 0;
    private var _depth:Number = 0;
    private var _wallUp:NapeComponent;
    private var _userData:SharedObject;
    private var _tutorialComplete:Boolean = false;
    private var _isTutorial:Boolean = false;

    private var _loseStarTimer:ExtendedTimer = new ExtendedTimer(100);
    private var _lostStars:Vector.<GNode> = new Vector.<GNode>();

    [Embed(source="/assets/prototypes/marker_proto.xml", mimeType="application/octet-stream")]
    public static const MarkerXml:Class;

    private var _splash:Bitmap;


	public function Main() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        stage.addEventListener(Event.DEACTIVATE, deactivate);
        stage.addEventListener(Event.ACTIVATE, activate);
        GameConstants.SCREEN_HEIGHT = stage.fullScreenHeight;
        GameConstants.SCREEN_WIDTH = stage.fullScreenWidth;
        GameConstants.ASSETS_SCALE = GameConstants.SCREEN_HEIGHT >= 2048 ? 2 : 1;
        GameConstants.TILE_SIZE = GameConstants.SCREEN_HEIGHT >= 2048 ? 64 : 32;
        setSplashScreen();
        _camTargetOffset = GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE;
        NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
        init();
	}

    private function setSplashScreen():void {
        _splash = AssetsManager.getSplashScreen();
        addChild(_splash);
        _splash.x = -(_splash.width - GameConstants.SCREEN_WIDTH) / 2;
        _splash.y = -(_splash.height - GameConstants.SCREEN_HEIGHT) / 2;
    }

	private function init():void {
		var config:GContextConfig = new GContextConfig(stage, new Rectangle(0,0,GameConstants.SCREEN_WIDTH,GameConstants.SCREEN_HEIGHT));
		GStats.visible = false;
		_genome = Genome2D.getInstance();
		_genome.onInitialized.addOnce(onContext);
		_genome.init(config);
	}

	private function onRender():void {
        if(_gameStarted)
		    cameraFollow();
		offsetStaticObjects();
        if(_startTestRects ||_visibleRect.y >= _firstPlatform.y){
            _startTestRects = true;
            testMarkers();
        }
        if(_gameStarted && _ballDiffY !=0 ){
            _depth += _ballDiffY;
            _score = Math.floor(_depth * GameConstants.SCORE_RATIO);
            _uiManager.updateScore(_score, _plugins.highScore);
        }

        CONFIG::debug {
            _physicsDebug.clear();
            _physicsDebug.draw(_physics.space);
            _physicsDebug.display.y = - _camera.node.transform.y + (GameConstants.SCREEN_HEIGHT / 2);
        }
	}

	private function testMarkers():void {
		for(var i:int = 0; i < _markers.length; i++) {
			var node:GNode = _markers[i];
			if(!_visibleRect.containsRect(node.getBounds())){
				removeMarker(node);
			}
		}
	}

	private function removeMarker(node:GNode):void{
		_markers.splice(_markers.indexOf(node),1);
        var userData:Object = node.userData.get("platform");
        GPlatformFactory.removePlatform(userData);
		node.userData.remove("platform");
		node.setActive(false);
		addMarker();
	}

	private function addMarker():void{
		var newNode:GNode = _markersPool.getNext();
		newNode.transform.x = GameConstants.SCREEN_WIDTH / 2;
		newNode.transform.y = _lastCreated == null ? (GameConstants.SCREEN_HEIGHT * 0.9) : _lastCreated.transform.y + (GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE);
		_genome.root.addChild(newNode);
        newNode.transform.visible = false;
        var platform:Object = GPlatformFactory.addPlatform(newNode.transform.y, _lastCreated == null);
        if(_lastCreated == null)_firstPlatform = platform as GPlatform;
        newNode.userData.set("platform", platform);
		_lastCreated = newNode;
		_markers.push(newNode);
	}

    private var maxBallY:Number = 0;

	private function offsetStaticObjects():void{
		_diffY = _camera.node.transform.y - _prevCameraPos;
        if(_prevBallPos < _balls[0].node.transform.y && _balls[0].node.transform.y > maxBallY)
            _ballDiffY = _balls[0].node.transform.y - _prevBallPos;
        else
            _ballDiffY = 0;
        maxBallY = Math.max(_balls[0].node.transform.y, maxBallY);
		_prevCameraPos = _camera.node.transform.y;
        _prevBallPos = _balls[0].node.transform.y;
        _background512.node.transform.y = _camera.node.transform.y;
        _background256.node.transform.y = _camera.node.transform.y;
		_wallLeft.y = _camera.node.transform.y;
		_wallRight.y = _camera.node.transform.y;
        _wallUp.y = _camera.node.transform.y - (GameConstants.SCREEN_HEIGHT / 2) - (GameConstants.TILE_SIZE / 2);
		_visibleRect.y += _diffY;
		_offsetY = _uvTileRatio * _diffY;
		_background512.texture.uvY += _offsetY / GameConstants.TILE_SIZE;
        _background256.texture.uvY += _offsetY / (GameConstants.TILE_SIZE / 4);
		_wallTexture.uvY += _offsetY;
        _guiContainer.transform.y = _camera.node.transform.y;
        _foregroundContainer .transform.y = _camera.node.transform.y;

        for (var i:int = 0; i < _ballShadows.length; i++) {
            _ballShadows[i].transform.setPosition(_balls[i].x, _balls[i].y);
        }
	}

	private function cameraFollow():void {
        _camTargetY = _camTargetOffset > 0 ? _balls[0].y + _camTargetOffset : _balls[0].y;
        var diff:Number = _camTargetY - _prevBallY;
        if(diff < 0){
            _camera.node.transform.y += Math.floor((_prevBallY - _camera.node.transform.y ) / _camSpeed);
        }else{
            _camTargetOffset -= diff;
            _camera.node.transform.y += Math.floor((_camTargetY - _camera.node.transform.y ) / _camSpeed);
            _prevBallY = _camTargetY;
        }
	}

	private function onContext():void {
        _plugins = new PluginsManager(onPluginReady);
    }

    private function onPluginReady():void{

		AssetsManager.init();
        SoundManager.init();
		_physics = _genome.root.addComponent(GNapePhysics) as GNapePhysics;

        setDebug();

        _camTargetOffset = GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE;

        _startTestRects = false;

		GameSignals.ORIENTATION_UPDATE.add(onOrientation);
		_accelero = new AccelerometerController(stage);

		_visibleRect.x = 0;
		_visibleRect.y = -GameConstants.SCREEN_HEIGHT;
		_visibleRect.width = GameConstants.SCREEN_WIDTH;
		_visibleRect.height = GameConstants.SCREEN_HEIGHT * 3;

        _numCollectedStars =GameConstants.START_STARS;

        switch(Capabilities.language){
            case "fr":
                Localization.init(Localization.FRENCH);
                break;
            default:
                Localization.init(Localization.ENGLISH);
                break;
        }

        getUserData();

        setTimers();
        setContainers();
        GPlatformFactory.initialize(_platformsContainer);
		setBackground();
		setForeground();
		setMarkersPool();
		setWalls();
		setBall();
		setCamera();
        setParticles();

        _genome.root.mouseEnabled = true;
        _genome.root.mouseChildren = true;

		_genome.onPostRender.add(onRender);

        _uiManager = new UIManager(_guiContainer);

        setSignals();

        setShatteredGlass();

        _uiManager.updateScore(_score, _userData.data.score);

        SoundManager.playMainMenuMusic();

        _uiManager.updateNumStars(_numCollectedStars);

        _plugins.loadInterstitial();

        removeChild(_splash);
	}

    private function setShatteredGlass():void{
        _shatteredGlass = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _shatteredGlass.textureId = "shatteredGlass";

        _shatteredGlass.node.transform.alpha = 0.85;
        var scale:Number = GameConstants.SCREEN_HEIGHT / _shatteredGlass.texture.height;
        _shatteredGlass.node.transform.setScale(scale, scale);
        _shatteredGlass.node.transform.visible = false;
        _genome.root.addChild(_shatteredGlass.node);
    }

    private function getUserData():void {

        _userData = SharedObject.getLocal("ball_data");

        var isNewUser:Boolean = true;

        if(_userData.data.playMusic != undefined){
            SoundManager.playMusic = _userData.data.playMusic;
            SoundManager.playSfx = _userData.data.playSfx;
            _tutorialComplete = _userData.data.tutorialComplete;
            isNewUser = false;
            if(_userData.data.score == undefined){
                _userData.data.score = 0;
                _userData.flush();
            }

            if(_userData.data.score < _plugins.highScore){
                _userData.data.score = _plugins.highScore;
                _userData.flush();
            }else{
                CONFIG::release {
                    _plugins.onHighScore(_userData.data.score);
                }
            }
        }

        if(isNewUser){
            _userData.data.playMusic = true;
            _userData.data.playSfx = true;
            _userData.data.tutorialComplete = false;
            _userData.data.score = 0;
            _userData.flush();
        }
    }

    private function setParticles():void {
        _ballExplodeParticles = GNodeFactory.createNodeWithComponent(BallExplodeParticles) as BallExplodeParticles;
        _particlesContainer.addChild(_ballExplodeParticles.node);
    }

    private function setTimers():void{
        _bonusTimer = new ExtendedTimer(GameConstants.STARS_BONUS_TIME,1);
        _bonusTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteBonus);

        _invincibilityTimer = new ExtendedTimer(GameConstants.INVINCIBILITY_TIME,1);
        _invincibilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteInvincibility);

        _gravityTimer = new ExtendedTimer(GameConstants.GRAVITY_BONUS_TIME,1);
        _gravityTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteGravityBonus);

        _loseStarTimer.addEventListener(TimerEvent.TIMER, animatLoseStar);
    }

    private function onCompleteInvincibility(event:TimerEvent):void {
        _invincibilityTimer.reset();
        GameSignals.BALL_INVINCIBILITY_END.dispatch();
    }

    private function onCompleteGravityBonus(event:TimerEvent):void {
        GameSignals.GRAVITY_BONUS_END.dispatch();
        _gravityTimer.reset();
        _moveMultiplier = 1;
    }

    private function onCompleteBonus(event:TimerEvent):void {
        GameSignals.STAR_BONUS_END.dispatch();
        _starMultiplier = 1;
        _bonusTimer.reset();
    }

    private function animateBallExplode():void{
        if(_balls.length == 1){
            _gameStarted = false;
            _balls[0].prepareForKill();
            _balls[0].node.parent.removeChild(_balls[0].node);
            _gameOverContainer.addChild(_balls[0].node);
            _ballShadows[0].parent.removeChild(_ballShadows[0]);
            SoundManager.playWooshSfx();
            eaze(_balls[0].node.transform).to(0.3,{
                x:_camera.node.transform.x,
                y:_camera.node.transform.y,
                scaleX:10,
                scaleY:10
                }).easing(Expo.easeIn).onComplete(function():void{
                    _shatteredGlass.node.transform.setPosition(_camera.node.transform.x, _camera.node.transform.y);
                    _shatteredGlass.node.transform.visible = true;
                    _shatteredGlass.node.transform.alpha = 0;
                    SoundManager.playShatterSfx();
                    eaze(_shatteredGlass.node.transform).to(0.1,{
                        alpha:0.85
                    }).easing(Quadratic.easeOut);
                    eaze(_balls[0].node.transform).to(0.2,{
                        alpha:0
                    }).easing(Quadratic.easeOut).delay(2).onComplete(function():void{
                        eaze(_shatteredGlass.node.transform).to(1,{
                            alpha:0
                        }).easing(Quadratic.easeIn).onComplete(function():void{
                            GameSignals.HIGH_SCORE.dispatch(_score);
                            _uiManager.updateOptionsScore(_score, _score >_userData.data.score);
                            if(_score >_userData.data.score){
                                _userData.data.score = _score;
                                _userData.flush();
                            }
                            GameSignals.QUIT_GAME.dispatch(UIManager.OPTIONS_GAME_OVER);
                            _shatteredGlass.node.transform.visible = false;
                            SoundManager.playGameOverMusic();
                        });
                    });
                });


        }else{
            _numCollectedStars = GameConstants.START_STARS;
            _ballShadows[0].parent.removeChild(_ballShadows[0]);
            _ballShadows.shift();
            _physics.removeFirstJoint();
            var ballDestroyed:GBall = _balls.shift();
            ballDestroyed.isMainBall = false;
            ballDestroyed.prepareForKill();
            _ballExplodeParticles.node.transform.x = ballDestroyed.node.transform.x;
            _ballExplodeParticles.node.transform.y = ballDestroyed.node.transform.y;
            ballDestroyed.node.parent.removeChild(ballDestroyed.node);
            _ballExplodeParticles.emit = true;
            _balls[0].isMainBall = true;
            SoundManager.playHammerSfx();
        }
    }

    private function setSignals():void {
        GameSignals.COLLECTED_BONUS.add(onCollectBonus);
        GameSignals.UPDATE_NUM_STARS.add(onCollectStar);
        GameSignals.GAME_START.add(onStartGame);
        GameSignals.PAUSE.add(onPause);
        GameSignals.QUIT_GAME.add(onQuit);
        GameSignals.PLAY_AGAIN.add(onPlayAgain);
        GameSignals.TOGGLE_MUSIC.add(onToggleMusic);
        GameSignals.TOGGLE_SFX.add(onToggleSfx);
        GameSignals.TUTORIAL_COMPLETE.add(onTutorialComplete);
        GameSignals.UPDATE_BALL_DAMAGE.add(onUpdateStars);
    }

    private function onTutorialComplete():void{
        _isTutorial = false;
        _userData.data.tutorialComplete = true;
        _userData.flush();
    }

    private function onToggleSfx(sfxOn:Boolean):void{
        _userData.data.playSfx = sfxOn;
        _userData.flush();
    }

    private function onToggleMusic(musicOn:Boolean):void{
        _userData.data.playMusic = musicOn;
        _userData.flush();
    }

    private function onPlayAgain():void{
        _plugins.showInterstitial();
        SoundManager.playMainMenuMusic();
    }

    private function onQuit(from:String):void{
        _plugins.loadInterstitial();
        _accelero.disable();
        if(from == UIManager.OPTIONS_IN_GAME){
            _plugins.showInterstitial();
            GameSignals.PAUSE.dispatch(false);
        }
        _gameStarted = false;
        _visibleRect.x = 0;
        _visibleRect.y = -GameConstants.SCREEN_HEIGHT;
        _visibleRect.width = GameConstants.SCREEN_WIDTH;
        _visibleRect.height = GameConstants.SCREEN_HEIGHT * 3;

        _camTargetOffset = GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE;

        _numCollectedStars = GameConstants.START_STARS;
        _uiManager.updateNumStars(_numCollectedStars);

        _depth = 0;
        _score = 0;
        _uiManager.updateScore(_score, _userData.data.score);
        _prevBallY = 0;
        _startTestRects = false;
        _prevBallPos = 0;
        _ballDiffY = 0;

        for(var i:uint = 0 ; i < _markers.length ; i++){
            var userData:Object = _markers[i].userData.get("platform");
            GPlatformFactory.removePlatform(userData);
            _markers[i].userData.remove("platform");
            _markers[i].setActive(false);
        }

        _lastCreated = null;

        _markers = new Vector.<GNode>();
        _camera.node.transform.setPosition(GameConstants.SCREEN_WIDTH / 2,GameConstants.SCREEN_HEIGHT / 2);
        _prevCameraPos = GameConstants.SCREEN_HEIGHT / 2;

        _gravityTimer.stop();
        _gravityTimer.reset();

        _bonusTimer.stop();
        _bonusTimer.reset();

        _invincibilityTimer.stop();
        _invincibilityTimer.reset();

        _physics.removeJoints();

        for (i = 0; i < _ballShadows.length; i++) {
            _ballShadows[i].setActive(false);
            _ballShadows[i].dispose();
        }

        for(i = 0 ; i < _balls.length ; i++){
            _balls[i].prepareForKill();
            _balls[i].setActive(false);
            _balls[i].dispose();
            _balls[i].node.parent.removeChild(_balls[i].node);
        }
//
        setBall();

        var pt:Point = new Point(GameConstants.SCREEN_WIDTH / 2,-GameConstants.SCREEN_HEIGHT +  (GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE) + GameConstants.TILE_SIZE);

        do{
            addMarker();
            pt.y += GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE;
        }
        while(_visibleRect.containsPoint(pt));

        GStar.IS_BONUS = false;
    }

    private function onPause(pPaused:Boolean):void{
        _gamePaused = pPaused;
        if(_gamePaused){
            EazeTween.pauseAllTweens();
            _bonusTimer.pause();
            _gravityTimer.pause();
            _invincibilityTimer.pause();
            SoundManager.playMainMenuMusic();
            _accelero.disable();
        }else{
            EazeTween.resumeAllTweens();
            _bonusTimer.resume();
            _gravityTimer.resume();
            _invincibilityTimer.resume();
            SoundManager.playGameplayMusic();
            _accelero.enable();
        }
    }

    private function setTutorialState():void{
        _uiManager.displayTutorial(_balls[0].node.transform);
        _isTutorial = true;
    }


    private function onStartGame():void{
        if(!_tutorialComplete){
            setTutorialState();

        }
        maxBallY = _balls[0].node.transform.y;
        _gameStarted = true;
        _camTargetY = _balls[0].y + (GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE);
        SoundManager.playGameplayMusic();
        _accelero.enable();
    }



    private function animatLoseStar(event:TimerEvent):void{
        var star:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        star.texture = AssetsManager.getStarTexture();
        var pos:Point = new Point(_balls[0].node.transform.x, _balls[0].node.transform.y);
        star.node.transform.setPosition(pos.x, pos.y);
        _genome.root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(star.node);
        var xOffsetRnd:Number = Math.random() > 0.5 ? - (GameConstants.TILE_SIZE * 2) : GameConstants.TILE_SIZE * 2;
        var xRnd:Number = xOffsetRnd + (-GameConstants.TILE_SIZE + (Math.random()*GameConstants.TILE_SIZE * 2));
        var yRnd:Number = GameConstants.TILE_SIZE * 2 + (Math.random() * (GameConstants.TILE_SIZE * 2));
        var xAnchor:Number = xRnd / 2;
        eaze(star.node.transform).to(0.5, {x:[pos.x + xAnchor, pos.x + xRnd], y:[pos.y - (yRnd * 1.5), pos.y + (yRnd)], alpha:0}).easing(Quadratic.easeOut).onComplete(function():void{
            _genome.root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(star.node);
            _lostStars.splice(_lostStars.indexOf(star.node), 1);
            star = null;
        });
        _lostStars.push(star.node);
    }

    private function startTimerLoseStars(numStars:uint):void{
        _loseStarTimer.repeatCount = numStars;
        if(_loseStarTimer.running){
            for(var i:uint = 0 ; i < _lostStars.length ; i++){
                EazeTween.killTweensOf(_lostStars[i].transform);
                _genome.root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(_lostStars[i]);
            }
            _lostStars = new Vector.<GNode>();
            _loseStarTimer.stop();
        }
        _loseStarTimer.reset();
        _loseStarTimer.start();
    }

    private function onUpdateStars(numStars:uint):void{
        if(_numCollectedStars <= numStars){
            _numCollectedStars = 0;
            animateBallExplode();
        }else{
            _numCollectedStars -= numStars;
            if(numStars == 1){
                animatLoseStar(null);
            }else{
                startTimerLoseStars(numStars);
            }
        }
        if(_numCollectedStars <= GameConstants.BALL_DAMAGE_ALARM)
            _balls[0].updateColor(_numCollectedStars / GameConstants.BALL_DAMAGE_ALARM);
        _uiManager.updateNumStars(_numCollectedStars);
    }

    private function onCollectStar():void{
        _numCollectedStars += 1 * _starMultiplier;
        _uiManager.updateNumStars(_numCollectedStars);
        if(_numCollectedStars <= GameConstants.BALL_DAMAGE_ALARM)
            _balls[0].updateColor(_numCollectedStars / GameConstants.BALL_DAMAGE_ALARM);
    }

    private function onCollectBonus(pos:Vec2, pBonus:Body):void{
        SoundManager.playBonusSfx();
        var rnd:Number = Math.random();
        if(rnd > 0.75){
            setStarsBonus(pos);
        }else if(rnd > 0.5){
            setBallsBonus(pos);
        }else if(rnd > 0.25){
            setInvincibleBonus(pos);
        }else{
            setGravityBonus(pos);
        }
    }

    private function setInvincibleBonus(pPos:Vec2):void{
        GameSignals.INVINCIBILITY_BONUS_START.dispatch();
        if(_invincibilityTimer.running){
            _invincibilityTimer.stop();
            _invincibilityTimer.reset();
        }
        _invincibilityTimer.start();
    }

    private function setStarsBonus(pPos:Vec2):void{
        _starMultiplier = GameConstants.STAR_BONUS_MULTIPLIER;
        if(_bonusTimer.running){
            _bonusTimer.stop();
            _bonusTimer.reset();
        }
        _bonusTimer.start();
        ParticlesFactory.triggerStarsBonusParticles(pPos);
        GameSignals.STAR_BONUS_START.dispatch();
    }

    private function setGravityBonus(pPos:Vec2):void{
        if(_gravityTimer.running){
            _gravityTimer.stop();
            _gravityTimer.reset();
        }
        _moveMultiplier = GameConstants.ORIENTATION_MULTIPLIER;
        _gravityTimer.start();
        GameSignals.GRAVITY_BONUS_START.dispatch();
        ParticlesFactory.triggerGravityBonusParticles(pPos);
    }

    private function setBallsBonus(pPos:Vec2):void{
        GameSignals.BALLS_BONUS_START.dispatch();
        ParticlesFactory.triggerBallsBonusParticles(pPos);
        createBonusBall(SoundManager.playPop1Sfx);
        setTimeout(GameSignals.BALLS_BONUS_END.dispatch, 2000);
    }

    private function createBonusBall(soundFunc:Function):void{
        var ball:GBall = GNodeFactory.createNodeWithComponent(GBall) as GBall;

        _ballContainer.addChild(ball.node);
        ball.x = _balls[_balls.length - 1].body.position.x;
        ball.y = _balls[_balls.length - 1].body.position.y - _balls[_balls.length - 1].body.shapes.at(0).bounds.width - 10;
        _physics.createJoint(_balls[_balls.length - 1].body, ball.body);
        _balls.push(ball);

        ball.isMainBall = false;

        var ballShadow:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        ballShadow.texture = AssetsManager.getBallShadowTexture();
        _ballContainer.addChild(ballShadow.node);
        _ballShadows.push(ballShadow.node);
        ball.node.transform.alpha = 0.3;
        soundFunc();
    }

    private function setContainers():void {
        _bgContainer = GNodeFactory.createNode("bgContainer");
        _genome.root.addChild(_bgContainer);

        _ballContainer = GNodeFactory.createNode("ballContainer");
        _genome.root.addChild(_ballContainer);

        _platformsContainer = GNodeFactory.createNode("platformsContainer");
        _genome.root.addChild(_platformsContainer);

        _particlesContainer = GNodeFactory.createNode("particlesContainer");
        _genome.root.addChild(_particlesContainer);

        _wallsContainer = GNodeFactory.createNode("wallsContainer");
        _genome.root.addChild(_wallsContainer);

        _foregroundContainer = GNodeFactory.createNode("foregroundContainer");
        _genome.root.addChild(_foregroundContainer);

        _gameOverContainer = GNodeFactory.createNode("gameOverContainer");
        _genome.root.addChild(_gameOverContainer);

        _guiContainer = GNodeFactory.createNode("guiContainer");
        _guiContainer.transform.setPosition(GameConstants.SCREEN_WIDTH / 2, GameConstants.SCREEN_HEIGHT / 2);
        _genome.root.addChild(_guiContainer);
    }

    private function onClick(sig:GNodeMouseSignal):void{
        if(_gameStarted)
            _balls[0].jump();
    }

	private function setCamera():void {
		_camera = GNodeFactory.createNodeWithComponent(GCameraController) as GCameraController;
		_genome.root.addChild(_camera.node);
		_camera.node.transform.setPosition(GameConstants.SCREEN_WIDTH / 2,GameConstants.SCREEN_HEIGHT / 2);
		_prevCameraPos = GameConstants.SCREEN_HEIGHT / 2;
        mainCamera = _camera;
	}

	private function setMarkersPool():void {
		var str:String = new MarkerXml();
		var xml:Xml = Xml.parse(str);

        GTextureFactory.createFromBitmapData("marker", new BitmapData(GameConstants.TILE_SIZE,GameConstants.TILE_SIZE,false,0xffcc0000));

		_markersPool = new GNodePool(xml,20,20);

		var pt:Point = new Point(GameConstants.SCREEN_WIDTH / 2,-GameConstants.SCREEN_HEIGHT + (GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE) + GameConstants.TILE_SIZE);

		do{
			addMarker();
			pt.y += GameConstants.PLATFORM_OFFSET * GameConstants.ASSETS_SCALE;
		}
		while(_visibleRect.containsPoint(pt))
	}

	private function onOrientation(accelX:Number, accelY:Number):void {
        if(_gameStarted && !_isTutorial){
            _balls[0].body.applyImpulse(Vec2.weak(accelX * 20 * _moveMultiplier, 0));
        }
	}

	private function setBall():void {
        _balls = new Vector.<GBall>();

		var ball:GBall = GNodeFactory.createNodeWithComponent(GBall) as GBall;
		_ballContainer.addChild(ball.node);

        ball.x = GameConstants.SCREEN_WIDTH / 2;
        ball.y = (GameConstants.SCREEN_HEIGHT * 0.9) - (GameConstants.TILE_SIZE * 2);
        ball.body.position.setxy(GameConstants.SCREEN_WIDTH / 2, (GameConstants.SCREEN_HEIGHT * 0.9) - (GameConstants.TILE_SIZE * 2));
        _balls.push(ball);

        ball.body.type = BodyType.KINEMATIC;

        setTimeout(function():void{
            ball.body.type = BodyType.DYNAMIC;
        }, 100);

        _ballShadows = new Vector.<GNode>();

        var ballShadow:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        ballShadow.texture = AssetsManager.getBallShadowTexture();
        _ballContainer.addChild(ballShadow.node);
        _ballShadows.push(ballShadow.node);

        ball.isMainBall = true;
	}

	private function setWalls():void {
		_wallTexture = AssetsManager.getWallTexture();
		_wallLeft = GNodeFactory.createNodeWithComponent(GWall) as GWall;
		_wallLeft.node.addComponent(GSprite);
		(_wallLeft.node.getComponent(GSprite) as GSprite).texture = _wallTexture;
		(_wallLeft.node.getComponent(GSprite) as GSprite).texture.uvScaleY = GameConstants.SCREEN_HEIGHT / GameConstants.TILE_SIZE;
		_wallLeft.node.transform.scaleY = GameConstants.SCREEN_HEIGHT / GameConstants.TILE_SIZE;
		_wallsContainer.addChild(_wallLeft.node);
		_wallLeft.x = GameConstants.TILE_SIZE / 2;
		_wallLeft.y = GameConstants.SCREEN_HEIGHT / 2;

		_wallRight = GNodeFactory.createNodeWithComponent(GWall) as GWall;
		_wallRight.node.addComponent(GSprite);
		(_wallRight.node.getComponent(GSprite) as GSprite).texture = _wallTexture;
		_wallRight.node.transform.scaleY = GameConstants.SCREEN_HEIGHT / GameConstants.TILE_SIZE;
        _wallsContainer.addChild(_wallRight.node);
		_wallRight.x = GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE / 2);
		_wallRight.y = GameConstants.SCREEN_HEIGHT / 2;

        _wallUp = GNodeFactory.createNodeWithComponent(GUpperWall) as GUpperWall;
        _wallUp.node.transform.scaleY = GameConstants.SCREEN_WIDTH / GameConstants.TILE_SIZE;
        _wallsContainer.addChild(_wallUp.node);
        _wallUp.x = GameConstants.SCREEN_WIDTH / 2;
        _wallUp.y = 0;
	}
    private function setDebug():void {
        CONFIG::debug {
            _physicsDebug = new ShapeDebug(GameConstants.SCREEN_WIDTH,10,0xcc0000);
            stage.addChild(_physicsDebug.display);
        }
    }
	private function setForeground():void {
        var foregroundTexture:GTexture = AssetsManager.getForegroundTexture();
        var upForeground:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        upForeground.texture = foregroundTexture;
        upForeground.node.transform.scaleX = (GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 2)) / foregroundTexture.width;
        upForeground.node.transform.setPosition(GameConstants.SCREEN_WIDTH / 2, -(GameConstants.SCREEN_HEIGHT / 2) + (foregroundTexture.height / 2));
        _foregroundContainer.addChild(upForeground.node);

        var downForeground:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        downForeground.texture = foregroundTexture;
        downForeground.node.transform.scaleX = (GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 2)) / foregroundTexture.width;
        downForeground.node.transform.scaleY = -1;
        downForeground.node.transform.setPosition(GameConstants.SCREEN_WIDTH / 2, (GameConstants.SCREEN_HEIGHT / 2) - (foregroundTexture.height / 2));
        _foregroundContainer.addChild(downForeground.node);

        var leftForeground:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        leftForeground.texture = foregroundTexture;
        leftForeground.node.transform.scaleX = GameConstants.SCREEN_HEIGHT / foregroundTexture.width;
        leftForeground.node.transform.rotation = -Math.PI / 2;
        leftForeground.node.transform.setPosition((GameConstants.TILE_SIZE) + (foregroundTexture.height / 2),0);
        _foregroundContainer.addChild(leftForeground.node);

        var rightForeground:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        rightForeground.texture = foregroundTexture;
        rightForeground.node.transform.scaleX = GameConstants.SCREEN_HEIGHT / foregroundTexture.width;
        rightForeground.node.transform.rotation = Math.PI / 2;
        rightForeground.node.transform.setPosition(GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE) - (foregroundTexture.height / 2),0);
        _foregroundContainer.addChild(rightForeground.node);

        _foregroundContainer.transform.alpha = 0.5;
    }


	private function setBackground():void {
		_background512 = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		_background512.textureId = "bgParallax512Texture";
		_background512.texture.uvScaleX = GameConstants.SCREEN_WIDTH / _background512.texture.width;
		_background512.texture.uvScaleY = GameConstants.SCREEN_HEIGHT / _background512.texture.height;
		_background512.node.transform.scaleX = GameConstants.SCREEN_WIDTH / _background512.texture.width;
		_background512.node.transform.scaleY = GameConstants.SCREEN_HEIGHT / _background512.texture.height;

        _bgContainer.addChild(_background512.node);
		_background512.node.transform.x = GameConstants.SCREEN_WIDTH / 2;
		_background512.node.transform.y = GameConstants.SCREEN_HEIGHT / 2;
        _background512.node.mouseEnabled = true;
        _background512.node.onMouseClick.add(onClick);

        _background256 = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _background256.textureId = "bgParallax256Texture";
        _background256.texture.uvScaleX = GameConstants.SCREEN_WIDTH / _background256.texture.width;
        _background256.texture.uvScaleY = GameConstants.SCREEN_HEIGHT / _background256.texture.height;
        _background256.node.transform.scaleX = GameConstants.SCREEN_WIDTH / _background256.texture.width;
        _background256.node.transform.scaleY = GameConstants.SCREEN_HEIGHT / _background256.texture.height;


        _bgContainer.addChild(_background256.node);
        _background256.node.transform.x = GameConstants.SCREEN_WIDTH / 2;
        _background256.node.transform.y = GameConstants.SCREEN_HEIGHT / 2;
        _background256.node.mouseEnabled = false;
	}

	private function activate(e:Event):void
	{
        SoundMixer.soundTransform = new SoundTransform(1);
	}

	private function deactivate(e:Event):void
	{
		if(_gameStarted){
			GameSignals.PAUSE.dispatch(true);
		}
        SoundMixer.soundTransform = new SoundTransform(0);
	}
}
}
