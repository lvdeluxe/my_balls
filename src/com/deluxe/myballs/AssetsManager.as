/**
 * Created by lvdeluxe on 14-12-10.
 */
package com.deluxe.myballs {
import flash.display.BitmapData;
import flash.utils.ByteArray;

import starling.display.BlendMode;
import starling.display.MovieClip;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import com.deluxe.myballs.ui.UIManager;

public class AssetsManager {

	[Embed(source="/assets/ui/futuraBT.fnt", mimeType="application/octet-stream")]
	public static const FontXml:Class;
//	[Embed(source="/assets/ui/futuraBT_0.png")]
//	public static const FontTexture:Class;

	[Embed(source="/assets/sprites.xml", mimeType="application/octet-stream")]
	public static const AtlasXml:Class;
	[Embed(source="/assets/sprites_pvrtc.atf", mimeType="application/octet-stream")]
	public static const AtlasTexture:Class;

	[Embed(source="/assets/critters2.xml", mimeType="application/octet-stream")]
	public static const AnimsXml:Class;
	[Embed(source="/assets/critters2.png")]
	public static const AnimsTexture:Class;

	private static var _atlas:TextureAtlas;
	private static var _anims:TextureAtlas;

//	[Embed(source="/assets/ui/btn_on.png")]
//	public static const ButtonOn:Class;
//	[Embed(source="/assets/ui/btn_off.png")]
//	public static const ButtonOff:Class;

	public static function init():void{
		var atlas_str:String = new AtlasXml();
		var atlasXML:XML = new XML(atlas_str);
		var data:ByteArray = new AtlasTexture();
		_atlas = new TextureAtlas(Texture.fromAtfData(data),atlasXML);

		var texture:Texture = Texture.fromBitmap(new AnimsTexture());
		var xml:XML = XML(new AnimsXml());
		_anims = new TextureAtlas(texture, xml);



		//var fontTexture:Texture = _atlas.getTexture("futuraBT_0.png");//Texture.fromBitmap(new FontTexture());
		var fontXml:XML = XML(new FontXml());
		TextField.registerBitmapFont(new BitmapFont(_atlas.getTexture("futuraBT_0.png"), fontXml));

		UIManager.init();
	}

	public static function getCritterMovieClip():MovieClip{
		var mc:MovieClip = new MovieClip(_anims.getTextures("critterA_"), 24);
		return mc;
	}

	public static function geBtnOffTexture():Texture {
		return _atlas.getTexture("btn_off.png");
	}

	public static function geBtnOnTexture():Texture {
		return _atlas.getTexture("btn_on.png");
	}

	public static function getWallTexture():Texture {
		return _atlas.getTexture("wall_tile.jpg");
	}

	public static function getBallTexture():Texture {
		return _atlas.getTexture("ball.png");
	}

	public static function getDestructiblePlatformTexture():Texture {
		return _atlas.getTexture("platform_destructible.jpg");
	}

	public static function getPlatformTexture():Texture {
		return _atlas.getTexture("platform.jpg");
	}

	public static function getBgTexture():Texture {
		return _atlas.getTexture("background.jpg");
	}

	public static function getArrowContainerRightTexture():Texture {
		return _atlas.getTexture("enemy_container_right.png");
	}

	public static function getArrowRightTexture():Texture {
		return _atlas.getTexture("enemy_right.png");
	}

	public static function getArrowContainerLeftTexture():Texture {
		return _atlas.getTexture("enemy_container_left.png");
	}

	public static function getArrowLeftTexture():Texture {
		return _atlas.getTexture("enemy_left.png");
	}

	public static function getStarTexture():Texture {
		return _atlas.getTexture("star.png");
	}

	public static function getShadowTexture():Texture {
		return _atlas.getTexture("platform_shadow.png");
	}

	public static function getShadowDestructEndTexture():Texture {
		return _atlas.getTexture("platform_shadow_destruct_end.png");
	}

	public static function getShadowDestructTexture():Texture {
		return _atlas.getTexture("platform_shadow_destruct.png");
	}
}
}
