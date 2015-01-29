/**
 * Created by lvdeluxe on 14-12-10.
 */
package com.deluxe.myballs.states {
import citrus.utils.objectmakers.ObjectMakerStarling;
import citrus.view.starlingview.StarlingCamera;

import com.deluxe.myballs.*;

import citrus.core.starling.StarlingState;
import citrus.objects.CitrusSpritePool;
import citrus.objects.NapeObjectPool
import citrus.physics.nape.Nape;

import com.deluxe.myballs.states.game.Background;
import com.deluxe.myballs.states.game.BallBody;
import com.deluxe.myballs.states.game.NapeWall;
import com.deluxe.myballs.states.game.platforms.PlatformFactory;
import com.deluxe.myballs.states.game.platforms.PlatformFactory;
import com.deluxe.myballs.states.game.platforms.PlatformMarker;
import com.deluxe.myballs.ui.GameHUD;

import flash.geom.Point;
import flash.geom.Rectangle;

import nape.geom.Vec2;

import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.extensions.krecha.ScrollImage;
import starling.extensions.krecha.ScrollTile;
import starling.textures.TextureSmoothing;

public class GameState extends StarlingState{

	public var _ball:BallBody;
	private  var _nape:Nape;

	private var _markers:CitrusSpritePool;

	private var _markerBounds:Rectangle = new Rectangle();

	private var _lastPlatformY:Number;

	private var _cameraRect:Rectangle = new Rectangle();

	private var _hud:GameHUD;

	private var _started:Boolean = true;

	private var _accelero:AccelerometerController;
	private var _numStars:uint = 0;

	public function GameState() {
	}

	override public function initialize():void {
		super.initialize();

		GameSignals.ORIENTATION_UPDATE.add(onOrientation);
		GameSignals.COLLECT_STAR.add(onCollectStar);
		GameSignals.BALL_JUMP.add(onBallJump);

		_nape = new Nape("nape", { gravity:new Vec2(0, 150)});
		//_nape.visible = true;
		add(_nape);

		PlatformFactory.initialize();

		setBackground();

		setMarkers();

		setBall();

		setWalls();

		_accelero = new AccelerometerController();

		camera.setUp(_ptTarget,new Rectangle(0,0,GameConstants.SCREEN_WIDTH,1000000),new Point(0.5,0.5),new Point(0.1,0.1));
		camera.followTarget = true;
		camera.allowRotation = false;
		camera.allowZoom = false;

		_hud = new GameHUD();
		addChild(_hud);

		_started = true;
	}

	private var _ptTarget:Point = new Point();

	private function onCollectStar(numStars:uint):void{
		_numStars+=numStars;
		_hud.updateStarsCounter(_numStars);
	}

	private function setMarkers():void {
		_markers = new CitrusSpritePool(PlatformMarker, {visible:false, width:GameConstants.TILE_SIZE, height:GameConstants.TILE_SIZE}, 1);
		addPoolObject(_markers);
		_markers.initializePool(1);

		_lastPlatformY = 0;
		var numPlatforms:uint = Math.floor((GameConstants.SCREEN_HEIGHT * 3) / GameConstants.PLATFORM_OFFSET);

		for(var i:uint = 0 ; i < numPlatforms ; i++){
			setObstacle(null);
		}
	}

	override public function destroy():void{
		_accelero.destroy();
		GameSignals.ORIENTATION_UPDATE.remove(onOrientation);
		GameSignals.BALL_JUMP.remove(onBallJump);
		GameSignals.COLLECT_STAR.remove(onCollectStar);
		removeChild(_hud);
		super.destroy();
	}

	private function onBallJump():void {
		_ball.jump();
	}

	private var _background:ScrollImage;

	private function setBackground():void {
		_background = new ScrollImage(GameConstants.SCREEN_WIDTH,GameConstants.SCREEN_HEIGHT);
		var bgTile:ScrollTile = new ScrollTile(AssetsManager.getBgTexture());
		_background.blendMode = BlendMode.NONE;
		_background.smoothing = TextureSmoothing.NONE;
		_background.mipMapping = false;
		_background.addLayer(bgTile);
		addChildAt(_background, 0);
		StarlingCamera
	}

	private function setWalls():void {

		_leftWall = new NapeWall("leftWall",{width:GameConstants.TILE_SIZE, height:GameConstants.SCREEN_HEIGHT, x:GameConstants.TILE_SIZE / 2, y: (GameConstants.SCREEN_HEIGHT / 2)});
		add(_leftWall);
		_rightWall = new NapeWall("rightWall",{width:GameConstants.TILE_SIZE, height:GameConstants.SCREEN_HEIGHT, x:GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE / 2), y:(GameConstants.SCREEN_HEIGHT / 2)});
		add(_rightWall);
	}

	private function onOrientation(accelX:Number, accelY:Number):void {
		_ball.impulse = Vec2.weak(accelX * 10, 0);
	}

	private function setBall():void {
		_ball = new BallBody("ball",{radius:GameConstants.TILE_SIZE / 2, group:1});
		add(_ball);
		_ball.x = GameConstants.SCREEN_WIDTH / 2;
		_ball.y = 200;
	}

	private function setCameraRectangle():void{
		_cameraRect.x = camera.getRect().x;
		_cameraRect.y = camera.getRect().y - GameConstants.SCREEN_HEIGHT;
		_cameraRect.width = camera.getRect().width;
		_cameraRect.height = GameConstants.SCREEN_HEIGHT * 4;
	}

	private var _prevCamY:Number = 0;

	private var _leftWall:NapeWall;
	private var _rightWall:NapeWall;
	private var _offsetY:int;

	override public function update(timeDelta:Number):void
	{
		if(_started){
			super.update(timeDelta);
			setCameraRectangle();
			_offsetY = camera.getRect().y - _prevCamY;
			_ptTarget.x = int(_ball.x);
			_ptTarget.y = int(_ball.y);
			_background.tilesOffsetY -= _offsetY;
			_leftWall.offset(_offsetY);
			_rightWall.offset(_offsetY);
			_markers.foreachRecycled(checkMarkers);
			_prevCamY = camera.getRect().y;
		}
	}

	private function setObstacle(marker:PlatformMarker):void{
		if(marker != null){
			PlatformFactory.removeObstacle(marker);
			marker.kill = true;
		}
		var currentMarker:PlatformMarker = _markers.get({y:_lastPlatformY + GameConstants.PLATFORM_OFFSET, x:GameConstants.SCREEN_WIDTH / 2}).data as PlatformMarker;
		PlatformFactory.addObstacle(currentMarker);

		_lastPlatformY = currentMarker.y;

	}

	private var _screenBounds:Rectangle = new Rectangle();

	private function checkMarkers(marker:PlatformMarker):Boolean{
		(view.getArt(marker).content as DisplayObject).getBounds( view.getArt(marker).parent, _screenBounds );
		PlatformFactory.updateVisibility(marker, camera.intersectsRect( _screenBounds, camera.getRect() ));
		(view.getArt(marker).content as DisplayObject).getBounds( view.getArt(marker).parent, _markerBounds );
		if (!camera.intersectsRect( _markerBounds, _cameraRect ) ){
			setObstacle(marker);
			return true;
		}
		return false;
	}
}
}
