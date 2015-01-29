/**
 * Created by lvdeluxe on 15-01-05.
 */
package com.deluxe.myballs.states.game.platforms {
import com.deluxe.myballs.GameConstants;

import citrus.core.CitrusEngine;
import citrus.core.starling.StarlingState;
import citrus.objects.CitrusSpritePool;
import citrus.objects.NapeObjectPool;

import com.deluxe.myballs.states.game.bonus.NapeStar;
import com.deluxe.myballs.states.game.obstacles.NapeArrow;
import com.deluxe.myballs.states.game.obstacles.NapeCritter;

import flash.utils.Dictionary;

import com.deluxe.myballs.states.game.obstacles.ArrowContainer;
import com.deluxe.myballs.states.game.obstacles.NapeCritter;
import com.deluxe.myballs.states.game.obstacles.NapeArrow;

public class PlatformFactory {

	private static var _defaultPlatforms:NapeObjectPool;
	private static var _critterPlatforms:NapeObjectPool;
	private static var _arrowPlatforms:NapeObjectPool;
	private static var _destructPlatforms:NapeObjectPool;
	private static var _starPlatforms:NapeObjectPool;

	private static var _currentState:StarlingState;

	private static var _obstacleDictionary:Dictionary = new Dictionary();

	private static var ALIGN_RIGHT:Boolean = true;
	private static var INC_ALIGN:uint = 0;
	private static var MAX_ALIGN:uint = 5;

	public function PlatformFactory() {

	}

	public static function initialize():void{
		_currentState = CitrusEngine.getInstance().state as StarlingState;

		_defaultPlatforms = new NapeObjectPool(NapePlatform, null , 1);
		_currentState.addPoolObject(_defaultPlatforms);
		_defaultPlatforms.onRecycle.add(onPlatformRecycle);
		_defaultPlatforms.onDispose.add(onPlatformDispose);
		_defaultPlatforms.initializePool(1);

		_starPlatforms = new NapeObjectPool(StarPlatform, null , 1);
		_currentState.addPoolObject(_starPlatforms);
		_starPlatforms.onRecycle.add(onPlatformRecycle);
		_starPlatforms.onDispose.add(onPlatformDispose);
		_starPlatforms.initializePool(1);

		_destructPlatforms = new NapeObjectPool(DestructiblePlatform, null , 1);
		_currentState.addPoolObject(_destructPlatforms);
		_destructPlatforms.onRecycle.add(onPlatformRecycle);
		_destructPlatforms.onDispose.add(onPlatformDispose);
		_destructPlatforms.initializePool(1);

		_critterPlatforms = new NapeObjectPool(CritterPlatform, null , 1);
		_currentState.addPoolObject(_critterPlatforms);
		_critterPlatforms.onRecycle.add(onPlatformRecycle);
		_critterPlatforms.onDispose.add(onPlatformDispose);
		_critterPlatforms.initializePool(1);

		_arrowPlatforms = new NapeObjectPool(ArrowPlatform, null , 1);
		_currentState.addPoolObject(_arrowPlatforms);
		_arrowPlatforms.onRecycle.add(onPlatformRecycle);
		_arrowPlatforms.onDispose.add(onPlatformDispose);
		_arrowPlatforms.initializePool(1);
	}

	private static function onPlatformRecycle(platform:NapePlatform, params:Object):void{
		platform.prepareForRecycle();
	}

	private static function onPlatformDispose(platform:NapePlatform):void{
		platform.prepareForDispose();
	}

	public static function updateVisibility(marker:PlatformMarker, pVisible:Boolean):void{
		var obj:Object = _obstacleDictionary[marker.y];
		if(obj is Array){
			var arr:Array = obj as Array;
			for(var i:uint = 0 ; i < arr.length ; i++){
				NapePlatform(arr[i]).setVisibility(pVisible);
			}
		}else if(obj is NapePlatform){
			NapePlatform(obj).setVisibility(pVisible);
		}
	}

	public static function removeObstacle(marker:PlatformMarker):void{
		var obj:Object = _obstacleDictionary[marker.y];
		if(obj is DestructibleGroup){
			DestructibleGroup(obj).destroyPlatforms();
		}else if(obj is NapePlatform){
			NapePlatform(obj).kill = true;
		}
		_obstacleDictionary[marker.y] = null;
	}

	public static function addObstacle(marker:PlatformMarker):void{
		var obj:Object;
		var rnd:Number = Math.random();
		if(rnd < 0.2){
//			obj = getDefaultPlatform(marker);
			obj = getCritterPlatform(marker);
		}else if(rnd < 0.4){
//			obj = getDestructiblePlatform(marker);
			obj = getArrowPlatform(marker);
		}else if(rnd < 0.6){
			obj = getDestructiblePlatform(marker);
		}else if(rnd < 0.8){
//			obj = getDestructiblePlatform(marker);
			obj = getStarPlatform(marker);
		}else{
			obj = getDefaultPlatform(marker);
		}
		_obstacleDictionary[marker.y] = obj;
	}

	private static function getStarPlatform(marker:PlatformMarker):Object{
		var obj:StarPlatform = _starPlatforms.get({ x:marker.x, y:marker.y}).data;
		return obj;
	}

	private static function getDestructiblePlatform(marker:PlatformMarker):Object{
		var group:DestructibleGroup = new DestructibleGroup(marker.y);
		for(var i:uint = 0 ; i < group.numPlatforms ; i++){
			group.addPlatform(_destructPlatforms.get(group.getParams()).data as DestructiblePlatform);
		}
		return group;
	}

	private static function getArrowPlatform(marker:PlatformMarker):Object{
		var obj:ArrowPlatform = _arrowPlatforms.get({ x:marker.x, y:marker.y}).data;
		return obj;
	}

	private static function getDefaultPlatform(marker:PlatformMarker):Object{
		var obj:NapePlatform = _defaultPlatforms.get({ x:marker.x, y:marker.y}).data;
		return obj;
	}

	private static function getCritterPlatform(marker:PlatformMarker):Object{
		var obj:CritterPlatform = _critterPlatforms.get({ x:marker.x, y:marker.y}).data;
		return obj;
	}

	private static function getRandomXPosition(pWidth:Number):uint{
		var remain:Number = (GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 2) - pWidth);
		var pos:uint = Math.floor((GameConstants.SCREEN_WIDTH / 2)- (remain / 2) + (Math.random() * remain));
		return pos - (pos % GameConstants.TILE_SIZE);
	}

	public static function getXPosition(pWidth:Number):uint{
		var remain:Number = (GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 2) - pWidth);
		var units:int = int(remain / GameConstants.TILE_SIZE) / 2;
		var rndUnits:int = Math.floor(Math.random() * units);
		if(rndUnits != units){
			PlatformFactory.INC_ALIGN++;
			if(PlatformFactory.INC_ALIGN == PlatformFactory.MAX_ALIGN){
				rndUnits = units;
				PlatformFactory.INC_ALIGN = 0;
			}
		}else{
			PlatformFactory.INC_ALIGN = 0;
		}
		var rnd:int = PlatformFactory.ALIGN_RIGHT ? rndUnits : -rndUnits;
		var pos:uint = (GameConstants.SCREEN_WIDTH / 2) + (rnd * GameConstants.TILE_SIZE);
		PlatformFactory.ALIGN_RIGHT = !PlatformFactory.ALIGN_RIGHT;
		var even:Boolean = (pWidth / GameConstants.TILE_SIZE) % 2 == 0;
		var offset:uint = even ? 0 : (PlatformFactory.ALIGN_RIGHT ? -GameConstants.TILE_SIZE / 2 : GameConstants.TILE_SIZE / 2);
		return pos + offset;
	}
}
}
