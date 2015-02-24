/**
 * Created by lvdeluxe on 15-01-05.
 */
package com.deluxe.myballs.platforms {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.genome2d.node.GNode;
import com.genome2d.node.GNodePool;

public class GPlatformFactory {

	private static var _defaultPlatforms:GNodePool;
	private static var _critterPlatforms:GNodePool;
	private static var _arrowPlatforms:GNodePool;
	private static var _destructPlatforms:GNodePool;
	private static var _starPlatforms:GNodePool;
	private static var _movingPlatforms:GNodePool;
	private static var _spikesPlatforms:GNodePool;

	private static var ALIGN_RIGHT:Boolean = true;
	private static var INC_ALIGN:uint = 0;
	private static var MAX_ALIGN:uint = 5;
	private static var DESTRUCT_GROUP:uint = 0;

	private static var _rootNode:GNode;


    private static var _bonusProbability:Number = 1;//0.5;

	public static function initialize(rootNode:GNode):void{
		_rootNode = rootNode;

		var str:String = new AssetsManager.DefaultPlatformXml();
		var defaultXml:Xml = Xml.parse(str);
		_defaultPlatforms = new GNodePool(defaultXml, 20 , 20);

		str = new AssetsManager.StarPlatformXml();
		var starsXml:Xml = Xml.parse(str);
		_starPlatforms = new GNodePool(starsXml, 20 , 20);

        str = new AssetsManager.ArrowPlatformXml();
        var arrowXml:Xml = Xml.parse(str);
        _arrowPlatforms = new GNodePool(arrowXml, 20 , 20);

        str = new AssetsManager.CritterPlatformXml();
        var critterXml:Xml = Xml.parse(str);
        _critterPlatforms = new GNodePool(critterXml, 20 , 20);

        str = new AssetsManager.DestructPlatformXml();
        var destructXml:Xml = Xml.parse(str);
        _destructPlatforms = new GNodePool(destructXml, 100 , 100);

        str = new AssetsManager.MovingPlatformXml();
        var movingXml:Xml = Xml.parse(str);
        _movingPlatforms = new GNodePool(movingXml, 20 , 20);

        str = new AssetsManager.SpikesPlatformXml();
        var spikesXml:Xml = Xml.parse(str);
        _spikesPlatforms = new GNodePool(spikesXml, 20 , 20);

        critterXml = null;
        starsXml = null;
        arrowXml = null;
        defaultXml = null;
        destructXml = null;
        movingXml = null;
        spikesXml = null;
	}

    private static function removeDestructiblePlatforms(v:Vector.<GDestructiblePlatform>):void{
        for (var i:int = 0; i < v.length; i++) {
            var p:GDestructiblePlatform = v[i];
            p.deactivate();
        }
    }


	public static function removePlatform(o:Object):void{
        if(o is GPlatform)
            (o as GPlatform).deactivate();
        else
            removeDestructiblePlatforms(o as Vector.<GDestructiblePlatform>);
	}

	public static function addPlatform(pY:Number, pFirst:Boolean):Object{
        if(pFirst)
            return getFirstPlatform(pY);

		var rnd:Number = Math.random();

        var prob:Number = 1/7;

//        return getSpikesPlatform(pY);

		if(rnd < prob * 1){
            return getArrowPlatform(pY);
		}else if(rnd < prob * 2){
            return getCritterPlatform(pY);
		}else if(rnd < prob * 3){
            return getStarPlatform(pY);
		}else if(rnd < prob * 4){
            return getDestructiblePlatform(pY);
		}else if(rnd < prob * 5){
            return getSpikesPlatform(pY);
		}else if(rnd < prob * 6){
            return getMovingPlatform(pY);
		}else{
            return getDefaultPlatform(pY);
		}
	}

	private static function getStarPlatform(pY:Number):GPlatform{
		var node:GNode = _starPlatforms.getNext();
		var platform:GStarsPlatform = node.getComponent(GStarsPlatform) as GStarsPlatform;
		platform.y = pY;
		platform.x = getXPosition(platform.width);
		_rootNode.addChild(node);
		platform.activate();
		return platform;
	}
//
	private static function getArrowPlatform(pY:Number):GPlatform{
        var node:GNode = _arrowPlatforms.getNext();
        var platform:GArrowPlatform = node.getComponent(GArrowPlatform) as GArrowPlatform;
        platform.y = pY;
        platform.x = getXPosition(platform.width);
        platform.activate();
        _rootNode.addChild(node);
        return platform;
	}

    private static function getSpikesPlatform(pY:Number):GPlatform{
        var node:GNode = _spikesPlatforms.getNext();
        var platform:GSpikesPlatform = node.getComponent(GSpikesPlatform) as GSpikesPlatform;
        platform.y = pY;
        platform.x = getXPosition(platform.width);
        platform.activate();
        _rootNode.addChild(node);
        return platform;
	}

    private static function getCritterPlatform(pY:Number):GPlatform{
        var node:GNode = _critterPlatforms.getNext();
        var platform:GCritterPlatform = node.getComponent(GCritterPlatform) as GCritterPlatform;
        platform.y = pY;
        platform.x = getXPosition(platform.width);
        platform.activate();
        _rootNode.addChild(node);
        return platform;
	}

	private static function getDestructiblePlatform(pY:Number):Object{
        var v:Vector.<GDestructiblePlatform> = new Vector.<GDestructiblePlatform>();
        var minWidthUnits:uint = 5;
        var maxWidthUnits:Number = (GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 6)) / GameConstants.TILE_SIZE;
        var numPlatforms:uint = minWidthUnits + Math.floor(Math.random() * (maxWidthUnits - minWidthUnits)) ;
        var totalWidth:Number = numPlatforms * GameConstants.TILE_SIZE;
        var randomX:Number = getXPosition(totalWidth);
        var xPos:uint = randomX - ((totalWidth / 2)) + GameConstants.TILE_SIZE / 2;
        for(var i:uint = 0 ; i < numPlatforms ; i++){
            var node:GNode = _destructPlatforms.getNext();
            var platform:GDestructiblePlatform = node.getComponent(GDestructiblePlatform) as GDestructiblePlatform;
            platform.group = DESTRUCT_GROUP;
            platform.y = pY;
            platform.index = i;
            platform.totalWidth = totalWidth;
            _rootNode.addChild(node);
            platform.x =  xPos + (GameConstants.TILE_SIZE * i);
            platform.activate();
            v.push(platform);
        }
        DESTRUCT_GROUP++;
		return v;
	}

	private static function getMovingPlatform(pY:Number):GPlatform{
		var node:GNode = _movingPlatforms.getNext();
		var platform:GMovingPlatform = node.getComponent(GMovingPlatform) as GMovingPlatform;
		platform.y = pY;
		platform.x = GameConstants.SCREEN_WIDTH / 2;
		platform.activate();
		_rootNode.addChild(node);
		return platform;
	}

	private static function getFirstPlatform(pY:Number):GPlatform{
        var node:GNode = _defaultPlatforms.getNext();
        var platform:GPlatform = node.getComponent(GPlatform) as GPlatform;
        platform.y = pY;
        platform.x = GameConstants.SCREEN_WIDTH / 2;
        platform.activate();
        _rootNode.addChild(node);
        return platform;
    }

	private static function getDefaultPlatform(pY:Number):GPlatform{
		var node:GNode = _defaultPlatforms.getNext();
		var platform:GPlatform = node.getComponent(GPlatform) as GPlatform;
		platform.y = pY;
		platform.x = getXPosition(platform.width);
		platform.activate();
        if(Math.random() < _bonusProbability)
            platform.activateBonus();
		_rootNode.addChild(node);
		return platform;
	}

	public static function getXPosition(pWidth:Number):uint{
		var remain:Number = (GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 2) - pWidth);
		var units:int = int(remain / GameConstants.TILE_SIZE) / 2;
		var rndUnits:int = Math.floor(Math.random() * units);
		if(rndUnits != units){
			GPlatformFactory.INC_ALIGN++;
			if(GPlatformFactory.INC_ALIGN == GPlatformFactory.MAX_ALIGN){
				rndUnits = units;
				GPlatformFactory.INC_ALIGN = 0;
			}
		}else{
			GPlatformFactory.INC_ALIGN = 0;
		}
		var rnd:int = GPlatformFactory.ALIGN_RIGHT ? rndUnits : -rndUnits;
		var pos:uint = (GameConstants.SCREEN_WIDTH / 2) + (rnd * GameConstants.TILE_SIZE);
		GPlatformFactory.ALIGN_RIGHT = !GPlatformFactory.ALIGN_RIGHT;
		var even:Boolean = (pWidth / GameConstants.TILE_SIZE) % 2 == 0;
		var offset:int = even ? 0 : (GPlatformFactory.ALIGN_RIGHT ? -GameConstants.TILE_SIZE / 2 : GameConstants.TILE_SIZE / 2);
		return pos + offset;
	}
}
}
