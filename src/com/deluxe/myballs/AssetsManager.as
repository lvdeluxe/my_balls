/**
 * Created by lvdeluxe on 14-12-10.
 */
package com.deluxe.myballs {
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.GTextureFontAtlas;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.factories.GTextureFactory;

public class AssetsManager {

    //PROTOS
    [Embed(source="/assets/prototypes/marker_proto.xml", mimeType="application/octet-stream")]
    public static const MarkerXml:Class;
    [Embed(source="/assets/prototypes/defaultPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const DefaultPlatformXml:Class;
    [Embed(source="/assets/prototypes/starsPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const StarPlatformXml:Class;
    [Embed(source="/assets/prototypes/arrowPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const ArrowPlatformXml:Class;
    [Embed(source="/assets/prototypes/critterPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const CritterPlatformXml:Class;
    [Embed(source="/assets/prototypes/destructPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const DestructPlatformXml:Class;
    [Embed(source="/assets/prototypes/movingPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const MovingPlatformXml:Class;
    [Embed(source="/assets/prototypes/spikesPlatform_proto.xml", mimeType="application/octet-stream")]
    public static const SpikesPlatformXml:Class;

	[Embed(source="/assets/fonts/futura.fnt", mimeType="application/octet-stream")]
	public static const FontXml:Class;
	[Embed(source="/assets/fonts/futura.png")]
	public static const FontTexture:Class;

	[Embed(source="/assets/sprites.xml", mimeType="application/octet-stream")]
	public static const AtlasXml:Class;
	[Embed(source="/assets/sprites.png")]
	public static const AtlasTexture:Class;

	[Embed(source="/assets/background.jpg")]
	public static const BackgroundTexture:Class;

	[Embed(source="/assets/wall_tile.jpg")]
	public static const WallTexture:Class;

	private static var _gTextureAtlas:GTextureAtlas;
    private static var _fontAtlas:GTextureFontAtlas;

	public static function init():void{
        var str:String = new FontXml();
        var xml:Xml = Xml.parse(str);
        _fontAtlas = GTextureAtlasFactory.createFromBitmapDataAndFontXml("futura", new FontTexture().bitmapData,xml);
		trace(_fontAtlas);
        _gTextureAtlas = GTextureAtlasFactory.createFromEmbedded("atlas",AtlasTexture, AtlasXml);
        GTextureFactory.createFromEmbedded("wallTexture", WallTexture,1,true);
        GTextureFactory.createFromEmbedded("bgTexture", BackgroundTexture,1, true);
	}

    public static function getModalTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_modal.png");
    }

    public static function getPopupBgTopLeftTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_top_left.png");
    }

    public static function getPopupBgTopRightTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_top_right.png");
    }

    public static function getPopupBgTopTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_top.png");
    }

    public static function getPopupBgBottomLeftTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_bottom_left.png");
    }

    public static function getPopupBgBottomRightTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_bottom_right.png");
    }

    public static function getPopupBgBottomTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_bottom.png");
    }

    public static function getPopupBgLeftTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_left.png");
    }

    public static function getPopupBgRightTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_right.png");
    }

    public static function getPopupBgCenterTexture():GTexture{
        return _gTextureAtlas.getSubTexture("popup_bg_center.png");
    }

    public static function getBtnOnTexture():GTexture{
        return _gTextureAtlas.getSubTexture("btn_on.png");
    }

    public static function getBtnOffTexture():GTexture{
        return _gTextureAtlas.getSubTexture("btn_off.png");
    }

    public static function getLogoTexture():GTexture{
        return _gTextureAtlas.getSubTexture("logo.png");
    }

    public static function getMeterBarTexture():GTexture{
        return _gTextureAtlas.getSubTexture("bar.jpg");
    }

    public static function getMeterBoxLeftTexture():GTexture{
        return _gTextureAtlas.getSubTexture("ui_box_left.png");
    }

    public static function getMeterBoxRightTexture():GTexture{
        return _gTextureAtlas.getSubTexture("ui_box_right.png");
    }

    public static function getMeterBoxCenterTexture():GTexture{
        return _gTextureAtlas.getSubTexture("ui_box_center.png");
    }

    public static function getResumeBtnOnTexture():GTexture{
        return _gTextureAtlas.getSubTexture("btn_play_on.png");
    }

    public static function getResumeBtnOffTexture():GTexture{
        return _gTextureAtlas.getSubTexture("btn_play_off.png");
    }

    public static function getPauseBtnOnTexture():GTexture{
        return _gTextureAtlas.getSubTexture("btn_pause_on.png");
    }

    public static function getPauseBtnOffTexture():GTexture{
        return _gTextureAtlas.getSubTexture("btn_pause_off.png");
    }

    public static function getCloseBtnOffTexture():GTexture{
        return _gTextureAtlas.getSubTexture("close_btn_off.png");
    }

    public static function getCloseBtnOnTexture():GTexture{
        return _gTextureAtlas.getSubTexture("close_btn_off.png");
    }

    public static function getBonusTexture():GTexture{
        return _gTextureAtlas.getSubTexture("bonus_box.jpg");
    }

    public static function getBonusBallsX3Texture():GTexture{
        return _gTextureAtlas.getSubTexture("bonus_ballX3.png");
    }

    public static function getBonusStarsX2Texture():GTexture{
        return _gTextureAtlas.getSubTexture("bonus_starsX2.png");
    }

    public static function getBallShadowTexture():GTexture{
        return _gTextureAtlas.getSubTexture("ball_shadow.png");
    }

    public static function getSpikesParticles():GTexture{
        return _gTextureAtlas.getSubTexture("spikes.png");
    }

    public static function getOrbParticle():GTexture{
        return _gTextureAtlas.getSubTexture("circle_particle.png");
    }

    public static function getBonusStarParticle():GTexture{
        return _gTextureAtlas.getSubTexture("star_particle.png");
    }

    public static function getCollisonParticle():GTexture{
        return _gTextureAtlas.getSubTexture("particle.png");
    }

    public static function getExplodeParticle():GTexture{
        return _gTextureAtlas.getSubTexture("explode_particle.png");
    }

	public static function geBtnOffTexture():GTexture {
		return _gTextureAtlas.getSubTexture("btn_off.png");
	}

	public static function geBtnOnTexture():GTexture {
		return _gTextureAtlas.getSubTexture("btn_on.png");
	}

	public static function getWallTexture():GTexture {
		return GTexture.getTextureById("wallTexture");
	}

	public static function getBallTexture():GTexture {
		return _gTextureAtlas.getSubTexture("ball.png");
	}

	public static function getCritterTexture():GTexture {
		return _gTextureAtlas.getSubTexture("critter.png");
	}

	public static function getPlatformRightTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_right.jpg");
	}

	public static function getPlatformLeftTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_left.jpg");
	}

	public static function getPlatformCenterTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_center.jpg");
	}

	public static function getBgTexture():GTexture {
		return GTexture.getTextureById("bgTexture");
	}

	public static function getArrowLeftTexture():GTexture {
		return _gTextureAtlas.getSubTexture("enemy_left.png");
	}

	public static function getStarTexture():GTexture {
		return _gTextureAtlas.getSubTexture("star.png");
	}

	public static function getShadowRightTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_shadow_right.png");
	}

	public static function getShadowLeftTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_shadow_left.png");
	}

	public static function getShadowCenterTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_shadow_center.png");
	}

	public static function getShadowDestructEndTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_shadow_destruct_end.png");
	}

	public static function getShadowDestructTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_shadow_destruct.png");
	}
}
}
