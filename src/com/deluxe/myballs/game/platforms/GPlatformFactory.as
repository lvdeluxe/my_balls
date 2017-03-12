/**
 * Created by lvdeluxe on 15-01-05.
 */
package com.deluxe.myballs.game.platforms {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;
import com.genome2d.node.GNode;
import com.genome2d.node.GNodePool;

public class GPlatformFactory {

    [Embed(source="/assets/prototypes/defaultPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const DefaultPlatformXml:Class;
    [Embed(source="/assets/prototypes/starsPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const StarPlatformXml:Class;
    [Embed(source="/assets/prototypes/horizontalSteamPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const HorizontalSteamPlatformXml:Class;
    [Embed(source="/assets/prototypes/critterPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const CritterPlatformXml:Class;
    [Embed(source="/assets/prototypes/destructPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const DestructPlatformXml:Class;
    [Embed(source="/assets/prototypes/movingPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const MovingPlatformXml:Class;
    [Embed(source="/assets/prototypes/verticalSteamPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const VerticalSteamPlatformXml:Class;
    [Embed(source="/assets/prototypes/electricPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const ElectricPlatformXml:Class;
    [Embed(source="/assets/prototypes/coilPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const CoilPlatformXml:Class;

	private static var _defaultPlatforms:GNodePool;
	private static var _critterPlatforms:GNodePool;
	private static var _hSteamPlatforms:GNodePool;
	private static var _destructPlatforms:GNodePool;
	private static var _starPlatforms:GNodePool;
	private static var _movingPlatforms:GNodePool;
	private static var _vSteamPlatforms:GNodePool;
	private static var _electricPlatforms:GNodePool;
	private static var _coilPlatforms:GNodePool;

	private static var ALIGN_RIGHT:Boolean = true;
	private static var INC_ALIGN:uint = 0;
	private static var MAX_ALIGN:uint = 2;
	private static var DESTRUCT_GROUP:uint = 0;

	private static var _rootNode:GNode;

    private static var _defaultBucket:Array = [getDefaultPlatform,getHorizontalSteamPlatform,getCritterPlatform,getStarPlatform,getDestructiblePlatform,getVerticalSteamPlatform,getMovingPlatform,getElectricPlatform,getCoilPlatform];
    private static var _currentBucket:Array = [];
    private static var _lastPlatformFunc:Function;

	public static function initialize(rootNode:GNode):void{
		_rootNode = rootNode;

		var str:String = new DefaultPlatformXml();
		var defaultXml:Xml = Xml.parse(str);
		_defaultPlatforms = new GNodePool(defaultXml, 20 , 20);

		str = new StarPlatformXml();
		var starsXml:Xml = Xml.parse(str);
		_starPlatforms = new GNodePool(starsXml, 20 , 20);
//
        str = new HorizontalSteamPlatformXml();
        var arrowXml:Xml = Xml.parse(str);
        _hSteamPlatforms = new GNodePool(arrowXml, 20 , 20);

        str = new CritterPlatformXml();
        var critterXml:Xml = Xml.parse(str);
        _critterPlatforms = new GNodePool(critterXml, 20 , 20);
//
        str = new DestructPlatformXml();
        var destructXml:Xml = Xml.parse(str);
        _destructPlatforms = new GNodePool(destructXml, 100 , 100);
//
        str = new MovingPlatformXml();
        var movingXml:Xml = Xml.parse(str);
        _movingPlatforms = new GNodePool(movingXml, 20 , 20);

        str = new VerticalSteamPlatformXml();
        var vSteamXml:Xml = Xml.parse(str);
        _vSteamPlatforms = new GNodePool(vSteamXml, 20 , 20);

        str = new ElectricPlatformXml();
        var electricXml:Xml = Xml.parse(str);
        _electricPlatforms = new GNodePool(electricXml, 20 , 20);

        str = new CoilPlatformXml();
        var coilXml:Xml = Xml.parse(str);
        _coilPlatforms = new GNodePool(coilXml, 20 , 20);

        _lastPlatformFunc = getDefaultPlatform;
//
        critterXml = null;
        starsXml = null;
        arrowXml = null;
        defaultXml = null;
        destructXml = null;
        movingXml = null;
        vSteamXml = null;
        electricXml = null;
        coilXml = null;
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

//        return getElectricPlatform(pY);

        _currentBucket = _defaultBucket.slice();
        _currentBucket.splice(_currentBucket.indexOf(_lastPlatformFunc), 1);
        var rnd:Number = Math.floor(Math.random() * _currentBucket.length);
        _lastPlatformFunc = _currentBucket[rnd];
        return _lastPlatformFunc(pY);
	}

	private static function getCoilPlatform(pY:Number):GPlatform{
		var node:GNode = _coilPlatforms.getNext();
		var platform:GCoilPlatform = node.getComponent(GCoilPlatform) as GCoilPlatform;
		platform.y = pY;
		platform.x = getXPosition(platform.width);
		_rootNode.addChild(node);
		platform.activate();
		return platform;
	}

	private static function getElectricPlatform(pY:Number):GPlatform{
		var node:GNode = _electricPlatforms.getNext();
		var platform:GElectricPlatform = node.getComponent(GElectricPlatform) as GElectricPlatform;
		platform.y = pY;
		platform.x = getXPosition(platform.width);
		_rootNode.addChild(node);
		platform.activate();
		return platform;
	}
//
	private static function getStarPlatform(pY:Number):GPlatform{
		var node:GNode = _starPlatforms.getNext();
		var platform:GStarsPlatform = node.getComponent(GStarsPlatform) as GStarsPlatform;
		platform.y = pY;
		platform.x = getXPosition(platform.width);
		_rootNode.addChild(node);
		platform.activate();
		return platform;
	}
////
	private static function getHorizontalSteamPlatform(pY:Number):GPlatform{
        var node:GNode = _hSteamPlatforms.getNext();
        var platform:GHorizontalSteamPlatform = node.getComponent(GHorizontalSteamPlatform) as GHorizontalSteamPlatform;
        platform.y = pY;
        platform.x = getXPosition(platform.width);
        platform.activate();
        _rootNode.addChild(node);
        return platform;
	}

    private static function getVerticalSteamPlatform(pY:Number):GPlatform{
        var node:GNode = _vSteamPlatforms.getNext();
        var platform:GVerticalSteamPlatform = node.getComponent(GVerticalSteamPlatform) as GVerticalSteamPlatform;
        platform.y = pY;
        platform.x = getXPosition(platform.width);
        platform.activate();
        _rootNode.addChild(node);
        return platform;
	}
//
    private static function getCritterPlatform(pY:Number):GPlatform{
        var node:GNode = _critterPlatforms.getNext();
        var platform:GCritterPlatform = node.getComponent(GCritterPlatform) as GCritterPlatform;
        platform.y = pY;
        platform.x = getXPosition(platform.width);
        platform.activate();
        _rootNode.addChild(node);
        return platform;
	}
//
	private static function getDestructiblePlatform(pY:Number):Object{
        var v:Vector.<GDestructiblePlatform> = new Vector.<GDestructiblePlatform>();
        var minWidthUnits:uint = int(GameConstants.SCREEN_WIDTH * 0.65 / GameConstants.TILE_SIZE);
        var maxWidthUnits:Number = ((GameConstants.SCREEN_WIDTH) - (GameConstants.TILE_SIZE * 4)) / GameConstants.TILE_SIZE;
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
        if(Math.random() < GameConstants.BONUS_PROBABILITY)
            platform.activateBonus();
		_rootNode.addChild(node);
		return platform;
	}

	public static function getXPosition(pWidth:Number):uint{
		var remain:Number = (GameConstants.SCREEN_WIDTH - (GameConstants.TILE_SIZE * 2) - pWidth);
		var units:int = int(remain / GameConstants.TILE_SIZE) / 2;
		var rndUnits:int = Math.floor(Math.random() * units);
        var invertAlign:Boolean = false;
		if(rndUnits != units){
			GPlatformFactory.INC_ALIGN++;
			if(GPlatformFactory.INC_ALIGN == GPlatformFactory.MAX_ALIGN){
				rndUnits = units;
				GPlatformFactory.INC_ALIGN = 0;
                invertAlign = true;
                var lapos:Number = 0;
                if(GPlatformFactory.ALIGN_RIGHT){
                    lapos = GameConstants.SCREEN_WIDTH - GameConstants.TILE_SIZE - (pWidth / 2);
                }else{
                    lapos = GameConstants.TILE_SIZE + (pWidth / 2);
                }
                GPlatformFactory.ALIGN_RIGHT = !GPlatformFactory.ALIGN_RIGHT;
                return lapos;
			}
		}else{
			GPlatformFactory.INC_ALIGN = 0;
            invertAlign = true;
		}
		var rnd:int = GPlatformFactory.ALIGN_RIGHT ? rndUnits : -rndUnits;
		var pos:uint = (GameConstants.SCREEN_WIDTH / 2) + (rnd * GameConstants.TILE_SIZE);
		var even:Boolean = (pWidth / GameConstants.TILE_SIZE) % 2 == 0;
		var offset:int = even ? 0 : (GPlatformFactory.ALIGN_RIGHT ? GameConstants.TILE_SIZE / 2 : -GameConstants.TILE_SIZE / 2);
        if(invertAlign)
            GPlatformFactory.ALIGN_RIGHT = !GPlatformFactory.ALIGN_RIGHT;
		return pos + offset;
	}
}
}
