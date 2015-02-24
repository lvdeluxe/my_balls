/**
 * Created by lvdeluxe on 15-01-28.
 */
package {
import aze.motion.easing.Quadratic;
import aze.motion.eaze;

import com.deluxe.myballs.AccelerometerController;
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.GameSignals;
import com.deluxe.myballs.SoundManager;
import com.deluxe.myballs.game.GBall;
import com.deluxe.myballs.ui.GButton;
import com.deluxe.myballs.physics.GNapePhysics;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.particles.ParticlesFactory;
import com.deluxe.myballs.ui.UIManager;
import com.deluxe.myballs.platforms.GPlatformFactory;
import com.deluxe.myballs.game.GWall;
import com.deluxe.myballs.platforms.GPlatform;
import com.deluxe.myballs.utils.ExtendedTimer;
import com.genome2d.Genome2D;
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.geom.GCurve;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.textures.factories.GTextureFactory;
import com.greensock.TweenMax;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;

import flash.events.MouseEvent;

import flash.events.TimerEvent;

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

	private var _background:GSprite;
	private var _prevCameraPos:Number = 0;
	private var _uvTileRatio:Number = 1/32;
	private var _diffY:Number = 0;
	private var _wallLeft:GWall;
	private var _wallRight:GWall;
	private var _wallTexture:GTexture;

	private var _markersPool:GNodePool;

	private var _offsetY:Number;
	private var _markers:Vector.<GNode> = new Vector.<GNode>();
	private var _visibleRect:Rectangle = new Rectangle();
	private var _lastCreated:GNode;
    private var _guiContainer:GNode;

    private var _bgContainer:GNode;
    private var _ballContainer:GNode;
    private var _platformsContainer:GNode;
    private var _particlesContainer:GNode;
    private var _wallsContainer:GNode;

    private var _prevBallY:Number = 0;

    private var rndRed:Number = Math.random() / 10000;
    private var rndGreen:Number = Math.random() / 10000;
    private var rndBlue:Number = Math.random() / 10000;
    private var rndBlueDirection:int;
    private var rndGreenDirection:int;
    private var rndRedDirection:int;

    private var _balls:Vector.<GBall>;
    private var _ballShadows:Vector.<GNode>;

    private var _uiManager:UIManager;

    private var _starMultiplier:uint = 1;

    private var _numCollectedStars:uint = 0;

    private var _bonusTimer:ExtendedTimer;
    private var _invincibilityTimer:ExtendedTimer;

    private var _gameStarted:Boolean = false;
    private var _gamePaused:Boolean = false;

    private var _firstPlatform:GPlatform;
    private var _startTestRects:Boolean = false;
    private var _camTargetY:Number;
    private var _camTargetOffset:Number = 200;


	public function Main() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        stage.addEventListener(Event.DEACTIVATE, deactivate);
        stage.addEventListener(Event.ACTIVATE, activate);
        GameConstants.SCREEN_HEIGHT = stage.fullScreenHeight;
        GameConstants.SCREEN_WIDTH = stage.fullScreenWidth;
        //setSplashScreen();
        NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
        init();

	}

	private function init():void {
		var config:GContextConfig = new GContextConfig(stage, new Rectangle(0,0,GameConstants.SCREEN_WIDTH,GameConstants.SCREEN_HEIGHT));
		GStats.visible = true;
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

        //offsetColors();
		CONFIG::debug {
			_physicsDebug.clear();
			_physicsDebug.draw(_physics.space);
			_physicsDebug.display.y = - _camera.node.transform.y + (GameConstants.SCREEN_HEIGHT / 2);
		}
	}


    private function offsetColors():void{
        _background.node.transform.blue += rndBlue * rndBlueDirection * _diffY;
        _wallLeft.node.transform.blue += rndBlue * rndBlueDirection * _diffY;
        _wallRight.node.transform.blue += rndBlue * rndBlueDirection * _diffY;
        _background.node.transform.red += rndRed * rndRedDirection * _diffY;
        _wallLeft.node.transform.red += rndRed * rndRedDirection * _diffY;
        _wallRight.node.transform.red += rndRed * rndRedDirection * _diffY;
        _background.node.transform.green += rndGreen * rndGreenDirection * _diffY;
        _wallLeft.node.transform.green += rndGreen * rndGreenDirection * _diffY;
        _wallRight.node.transform.green += rndGreen * rndGreenDirection * _diffY;
        if(_background.node.transform.green > 1 ||  _background.node.transform.green < 0){
            rndGreenDirection *= -1;
        }
        if(_background.node.transform.red > 1 ||  _background.node.transform.red < 0){
            rndRedDirection *= -1;
        }
        if(_background.node.transform.blue > 1 ||  _background.node.transform.blue < 0){
            rndBlueDirection *= -1;
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
		newNode.transform.y = _lastCreated == null ? GameConstants.SCREEN_HEIGHT - 100 : _lastCreated.transform.y + 200;
//		newNode.transform.y = _lastCreated == null ? -GameConstants.SCREEN_HEIGHT + 200 : _lastCreated.transform.y + 200;
		_genome.root.addChild(newNode);
        newNode.transform.visible = false;
        var platform:Object = GPlatformFactory.addPlatform(newNode.transform.y, _lastCreated == null);
        if(_lastCreated == null)_firstPlatform = platform as GPlatform;
        newNode.userData.set("platform", platform);
		_lastCreated = newNode;
		_markers.push(newNode);
	}

	private function offsetStaticObjects():void{
//        _ballParticles.node.transform.x = _ball.x;
//        _ballParticles.node.transform.y = _ball.y;
//        _ballParticles.node.transform.rotation = _ball.rotation;
		_diffY = _camera.node.transform.y - _prevCameraPos;
		_prevCameraPos = _camera.node.transform.y;
		_background.node.transform.y = _camera.node.transform.y;
		_wallLeft.y = _camera.node.transform.y;
		_wallRight.y = _camera.node.transform.y;
		_visibleRect.y += _diffY;
		_offsetY = _uvTileRatio * _diffY;
		_background.texture.uvY += _offsetY;
		_wallTexture.uvY += _offsetY;
        _guiContainer.transform.y = _camera.node.transform.y;

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
		AssetsManager.init();
        SoundManager.init();
		_physics = _genome.root.addComponent(GNapePhysics) as GNapePhysics;

		GameSignals.ORIENTATION_UPDATE.add(onOrientation);
		_accelero = new AccelerometerController(stage);

        rndBlueDirection = Math.random() > 0.5 ? -1 : 1;
        rndRedDirection = Math.random() > 0.5 ? -1 : 1;
        rndGreenDirection = Math.random() > 0.5 ? -1 : 1;

		_visibleRect.x = 0;
		_visibleRect.y = -GameConstants.SCREEN_HEIGHT;
		_visibleRect.width = GameConstants.SCREEN_WIDTH;
		_visibleRect.height = GameConstants.SCREEN_HEIGHT * 3;

        setTimers();
        setContainers();
        GPlatformFactory.initialize(_platformsContainer);
		setBackground();
		setMarkersPool();
		setWalls();
		setBall();
		setCamera();
		setDebug();

        _genome.root.mouseEnabled = true;
        _genome.root.mouseChildren = true;

		_genome.onPostRender.add(onRender);

        _ballShadows = new Vector.<GNode>();

        var ballShadow:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        ballShadow.texture = AssetsManager.getBallShadowTexture();
        _ballContainer.addChild(ballShadow.node);
        _ballShadows.push(ballShadow.node);

        _uiManager = new UIManager(_guiContainer);

        setSignals();
//        animateBallExplode();
	}

    private function setTimers():void{
        _bonusTimer = new ExtendedTimer(GameConstants.STARS_BONUS_TIME,1);
        _bonusTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteBonus);

        _invincibilityTimer = new ExtendedTimer(GameConstants.INVINCIBILITY_TIME,1);
        _invincibilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteInvincibility);
    }

    private function onCompleteInvincibility(event:TimerEvent):void {
        _invincibilityTimer.reset();
        GameSignals.BALL_INVINCIBILITY_END.dispatch();
    }

    private function onCompleteBonus(event:TimerEvent):void {
        GameSignals.STAR_BONUS_END.dispatch();
        _starMultiplier = 1;
        _bonusTimer.reset();
    }

    private function animateBallExplode():void{
        _balls[0].prepareForKill();

        var xPos:Array = [];
        var yPos:Array = [];
        for (var i:int = 0; i < 10; i++) {
            var x_tmp:Number = Math.random() * GameConstants.SCREEN_WIDTH;
            var y_tmp:Number = Math.random() * GameConstants.SCREEN_HEIGHT;
            xPos.push(x_tmp);
            yPos.push(y_tmp);
        }

        _ballShadows[0].transform.setPosition(_balls[0].node.transform.x, _balls[0].node.transform.y);

        eaze(_balls[0].node.transform).to(5, {
            x:xPos,
            y:yPos,
            scaleX:0.5,
            scaleY:0.5
        }).easing(Quadratic.easeIn);
        eaze(_ballShadows[0].transform).to(5, {
            x:xPos,
            y:yPos,
            scaleX:0.5,
            scaleY:0.5
        }).easing(Quadratic.easeIn);
    }

    private function setSignals():void {
        GameSignals.COLLECT_BONUS.add(onCollectBonus);
        GameSignals.UPDATE_NUM_STARS.add(onCollectStar);
        GameSignals.GAME_START.add(onStartGame);
        GameSignals.PAUSE.add(onPause);
    }

    private function onPause(pPaused:Boolean):void{
        _gamePaused = pPaused;
        TweenMax.globalTimeScale = pPaused ? 0 : 1;
    }

    private function onStartGame():void{
        _gameStarted = true;
        _camTargetY = _balls[0].y + 200;
    }


    private function onCollectStar():void{
        _numCollectedStars += 1 * _starMultiplier;
        if(_numCollectedStars >= GameConstants.STARS_FOR_INVINCIBILITY){
            _numCollectedStars = _numCollectedStars - GameConstants.STARS_FOR_INVINCIBILITY;
            GameSignals.BALL_INVINCIBILITY_START.dispatch();
            if(_invincibilityTimer.running){
                _invincibilityTimer.stop();
                _invincibilityTimer.reset();
            }
            _invincibilityTimer.start();
        }
        _uiManager.updateNumStars(_numCollectedStars);
    }

    private function onCollectBonus(pBonus:Body, pBall:Body):void{
        SoundManager.playBonusSfx();
        var rnd:Number = Math.random();
        if(rnd < 0.5){
            setStarsBonus(pBall.position);
        }else{
            setBallsBonus(pBall.position);
        }
    }

    private function setStarsBonus(pPos:Vec2):void{
        _starMultiplier = 2;
        if(_bonusTimer.running){
            _bonusTimer.stop();
            _bonusTimer.reset();
        }
        _bonusTimer.start();
        ParticlesFactory.triggerStarsBonusParticles(pPos);
        GameSignals.STAR_BONUS_START.dispatch();
    }

    private function setBallsBonus(pPos:Vec2):void{
        var xImpulse:Number = 300;
        for (var i:int = 0; i < 2; i++) {
            var ball:GBall = GNodeFactory.createNodeWithComponent(GBall) as GBall;
            ball.node.addComponent(GSprite);
            (ball.node.getComponent(GSprite) as GSprite).texture = AssetsManager.getBallTexture();
            _ballContainer.addChild(ball.node);
            ball.x = pPos.x;
            ball.y = pPos.y;
            _balls.push(ball);
            var ballShadow:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
            ballShadow.texture = AssetsManager.getBallShadowTexture();
            _ballContainer.addChild(ballShadow.node);
            _ballShadows.push(ballShadow.node);
            ball.body.applyImpulse(Vec2.weak(xImpulse, -300));
            ball.node.transform.green = 0.1;
            xImpulse *= -1;
        }

        ParticlesFactory.triggerBallsBonusParticles(pPos);
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

        _guiContainer = GNodeFactory.createNode("guiContainer");
        _guiContainer.transform.setPosition(GameConstants.SCREEN_WIDTH / 2, GameConstants.SCREEN_HEIGHT / 2);
        _genome.root.addChild(_guiContainer);
    }

    private function onClick(sig:GNodeMouseSignal):void{
        for (var i:int = 0; i < _balls.length; i++) {
            var b:GBall = _balls[i];
            b.jump();
        }
    }

	private function setCamera():void {
		_camera = GNodeFactory.createNodeWithComponent(GCameraController) as GCameraController;
		_genome.root.addChild(_camera.node);
		_camera.node.transform.setPosition(GameConstants.SCREEN_WIDTH / 2,GameConstants.SCREEN_HEIGHT / 2);
		_prevCameraPos = GameConstants.SCREEN_HEIGHT / 2;
	}

	private function setMarkersPool():void {
		var str:String = new AssetsManager.MarkerXml();
		var xml:Xml = Xml.parse(str);

        GTextureFactory.createFromBitmapData("marker", new BitmapData(32,32,false,0xffcc0000));

		_markersPool = new GNodePool(xml,20,20);

		var pt:Point = new Point(320,-GameConstants.SCREEN_HEIGHT + 232);

		do{
			addMarker();
			pt.y += 200;
		}
		while(_visibleRect.containsPoint(pt))
	}

	private function onOrientation(accelX:Number, accelY:Number):void {
        if(_gameStarted){
            for (var i:int = 0; i < _balls.length; i++) {
                var b:GBall = _balls[i];
                b.body.applyImpulse(Vec2.weak(accelX * 10, 0));
            }
        }
	}

	private function setBall():void {
        _balls = new Vector.<GBall>();
		var ball:GBall = GNodeFactory.createNodeWithComponent(GBall) as GBall;
        ball.node.addComponent(GSprite);
		(ball.node.getComponent(GSprite) as GSprite).texture = AssetsManager.getBallTexture();
		_ballContainer.addChild(ball.node);
        ball.x = 320;
        ball.y = 450;
        _balls.push(ball);
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
	}

	private function setBackground():void {
		_background = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		_background.texture = AssetsManager.getBgTexture();
		_background.texture.uvScaleX = GameConstants.SCREEN_WIDTH / GameConstants.TILE_SIZE;
		_background.texture.uvScaleY = GameConstants.SCREEN_HEIGHT / GameConstants.TILE_SIZE;
		_background.node.transform.scaleX = GameConstants.SCREEN_WIDTH / GameConstants.TILE_SIZE;
		_background.node.transform.scaleY = GameConstants.SCREEN_HEIGHT / GameConstants.TILE_SIZE;
		_bgContainer.addChild(_background.node);
		_background.node.transform.x = 320;
		_background.node.transform.y = 320;
        _background.node.mouseEnabled = true;
        _background.node.onMouseClick.add(onClick);
	}

	private function setDebug():void {
		CONFIG::debug {
		_physicsDebug = new ShapeDebug(GameConstants.SCREEN_WIDTH,GameConstants.SCREEN_HEIGHT,0xcc0000);
		stage.addChild(_physicsDebug.display);
		}
	}

	private function activate(e:Event):void
	{
		//SoundsManager.resumeAllSounds();
	}

	private function deactivate(e:Event):void
	{
		if(_gameStarted){
			GameSignals.PAUSE.dispatch(true);
		}
//		SoundsManager.pauseAllSounds();
	}
}
}
