/**
 * Created by lvdeluxe on 14-12-10.
 */
package com.deluxe.myballs {
import com.deluxe.myballs.ui.GSocialButton;
import com.genome2d.components.renderables.text.GText;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.textures.GTextureFontAtlas;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.factories.GTextureFactory;

import flash.display.Bitmap;

import flash.display.BitmapData;

public class AssetsManager {


	[Embed(source="/assets/shattered_glass.png")]
	public static const ShatteredGlassTexture:Class;
	[Embed(source="/assets/social_logo.png")]
	public static const SocialLogo:Class;

    private static var _gTextureAtlas:GTextureAtlas;


    private static var _socialLogo:BitmapData;



	public static function init():void{
//        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactText", new ImpactTextTexture().bitmapData,Xml.parse(new ImpactTextXml()));
//        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactTitle", new ImpactTitleTexture().bitmapData,Xml.parse(new ImpactTitleXml()));
//        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactButton", new ImpactButtonTexture().bitmapData,Xml.parse(new ImpactButtonXml()));
//        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactHUD", new ImpactHUDTexture().bitmapData,Xml.parse(new ImpactHUDXml()));
//        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactPowerUp", new ImpactPowerUpTexture().bitmapData,Xml.parse(new ImpactPowerUpXml()));
//
//        _gTextureAtlas = GTextureAtlasFactory.createFromEmbedded("atlas",AtlasTexture, AtlasXml);
//
//        GTextureFactory.createFromEmbedded("wallTexture", WallTexture,1,true);
//        GTextureFactory.createFromEmbedded("platformWire", MovingPlatformWire,1,true);
//        GTextureFactory.createFromEmbedded("bgParallax256Texture", BackgroundParallax256Texture,1, true);
//        GTextureFactory.createFromEmbedded("bgParallax512Texture", BackgroundParallax512Texture,1, true);

        if(GameConstants.ASSETS_SCALE == 1){
            AssetsSD.init();
            _gTextureAtlas = AssetsSD.gTextureAtlas;
        }else{
            AssetsHD.init();
            _gTextureAtlas = AssetsHD.gTextureAtlas;
        }

        GTextureFactory.createFromEmbedded("shatteredGlass", ShatteredGlassTexture,1, true);

        _socialLogo = new SocialLogo().bitmapData;
	}

    public static function GetSocialLogo():BitmapData{
        return _socialLogo;
    }

    public static function getTutorialArrowTexture():GTexture{
        return _gTextureAtlas.getSubTexture("tuto_arrow.png");
    }

    public static function getTutorialHandTexture():GTexture{
        return _gTextureAtlas.getSubTexture("tuto_hand.png");
    }

    public static function getTutorialTargetTexture():GTexture{
        return _gTextureAtlas.getSubTexture("tuto_target.png");
    }

    public static function getBallExplodeParticle():GTexture{
        return _gTextureAtlas.getSubTexture("smoke.png");
    }

    public static function getElectricPoleTexture():GTexture{
        return _gTextureAtlas.getSubTexture("electric_pole.png");
    }

    public static function getElectricParticlesBySize(size:Number):GTexture{
        return _gTextureAtlas.getSubTexture("electric_" + size.toString() + ".png");
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

    public static function getLogoTexture():GTexture{
        return _gTextureAtlas.getSubTexture("logo.png");
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
        return _gTextureAtlas.getSubTexture("bonus_box.png");
    }

    public static function getBonusBallsX3Texture():GTexture{
        return _gTextureAtlas.getSubTexture("bonus_ballX3.png");
    }

    public static function getGravityStarsX2Texture():GTexture{
        return _gTextureAtlas.getSubTexture("bonus_gravity.png");
    }

    public static function getBonusStarsX2Texture():GTexture{
        return _gTextureAtlas.getSubTexture("bonus_starsX2.png");
    }

    public static function getBallShadowTexture():GTexture{
        return _gTextureAtlas.getSubTexture("ball_shadow.png");
    }

    public static function getVerticalSteamPipeTexture():GTexture{
        return _gTextureAtlas.getSubTexture("steam_pipe_vertical.png");
    }

    public static function getHorizontalSteamPipeTexture():GTexture{
        return _gTextureAtlas.getSubTexture("steam_pipe_horizontal.png");
    }

    public static function getSteamParticle():GTexture{
        return _gTextureAtlas.getSubTexture("smoke.png");
    }

    public static function getOrbParticle():GTexture{
        return _gTextureAtlas.getSubTexture("tesla.png");
    }

    public static function getBonusStarParticle():GTexture{
        return _gTextureAtlas.getSubTexture("orb_powerup.png");
    }

    public static function getCollisonParticle():GTexture{
        return _gTextureAtlas.getSubTexture("particle.png");
    }

    public static function getExplodeParticle():GTexture{
        return _gTextureAtlas.getSubTexture("explode_particle.png");
    }

	public static function getWallTexture():GTexture {
		return GTexture.getTextureById("wallTexture");
	}

	public static function getPlatformWireTexture():GTexture {
//		return GTexture.getTextureById("platformWire");
//		return GTextureFactory.createFromEmbedded("platformWire" + (_INC_MOVING++).toString(), AssetsSD.MovingPlatformWire,1,true);
        if(GameConstants.ASSETS_SCALE == 1)
            return AssetsSD.getPlatformWireTexture();
        else
            return AssetsHD.getPlatformWireTexture();
	}

	public static function getBallTexture():GTexture {
		return _gTextureAtlas.getSubTexture("ball.png");
	}

	public static function getCritterTexture():GTexture {
		return _gTextureAtlas.getSubTexture("critter.png");
	}

	public static function getPlatformRightTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_right.png");
	}

	public static function getPlatformLeftTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_left.png");
	}

	public static function getPlatformCenterTexture():GTexture {
		return _gTextureAtlas.getSubTexture("platform_center.png");
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

	public static function getButtonLeftTexture():GTexture {
		return _gTextureAtlas.getSubTexture("btn_left.png");
	}

	public static function getButtonRightTexture():GTexture {
		return _gTextureAtlas.getSubTexture("btn_right.png");
	}

	public static function getButtonCenterTexture():GTexture {
		return _gTextureAtlas.getSubTexture("btn_center.png");
	}

	public static function getButtonOnLeftTexture():GTexture {
		return _gTextureAtlas.getSubTexture("btn_left_on.png");
	}

	public static function getButtonOnRightTexture():GTexture {
		return _gTextureAtlas.getSubTexture("btn_right_on.png");
	}

	public static function getButtonOnCenterTexture():GTexture {
		return _gTextureAtlas.getSubTexture("btn_center_on.png");
	}

	public static function getRestartButtonOnTexture():GTexture {
		return _gTextureAtlas.getSubTexture("restart_btn_on.png");
	}

	public static function getRestartButtonOffTexture():GTexture {
		return _gTextureAtlas.getSubTexture("restart_btn_off.png");
	}

    public static function getLogoById(id:String):GTexture{
        switch(id){
            case GSocialButton.FACEBOOK:
                return _gTextureAtlas.getSubTexture("facebook.png");
                break;
            case GSocialButton.GAME_CENTER:
                return _gTextureAtlas.getSubTexture("gamecenter.png");
                break;
            case GSocialButton.TWITTER:
                return _gTextureAtlas.getSubTexture("twitter.png");
                break;
        }
        return null;
    }

	public static function getToggleOnTexture():GTexture {
		return _gTextureAtlas.getSubTexture("checkmark_on.png");
	}

	public static function getToggleOffTexture():GTexture {
		return _gTextureAtlas.getSubTexture("checkmark_off.png");
	}

	public static function getCoilTexture():GTexture {
		return _gTextureAtlas.getSubTexture("coil.png");
	}

	public static function getTeslaTexture():GTexture {
		return _gTextureAtlas.getSubTexture("tesla.png");
	}

    public static function getForegroundTexture():GTexture {
        return _gTextureAtlas.getSubTexture("shadow_gradient.png");
    }

    public static function getDamageBoxTexture():GTexture {
        return _gTextureAtlas.getSubTexture("damage_meter_bg.png");
    }

    public static function getDamageBarTexture():GTexture {
        return _gTextureAtlas.getSubTexture("damage_meter.png");
    }

    public static function getPowerupParticleTexture():GTexture {
        return _gTextureAtlas.getSubTexture("powerup.png");
    }

    public static function getGearWireLeftTexture():GTexture {
        return _gTextureAtlas.getSubTexture("gear_wire_left.png");
    }

    public static function getGearWireCenterTexture():GTexture {
        return _gTextureAtlas.getSubTexture("gear_wire_center.png");
    }

    public static function getGearWireRightTexture():GTexture {
        return _gTextureAtlas.getSubTexture("gear_wire_right.png");
    }

    public static function getHUDBoxLeftTexture():GTexture {
        return _gTextureAtlas.getSubTexture("hud_bar_left.png");
    }

    public static function getHUDBoxCenterTexture():GTexture {
        return _gTextureAtlas.getSubTexture("hud_bar_center.png");
    }

    public static function getHUDBoxRightTexture():GTexture {
        return _gTextureAtlas.getSubTexture("hud_bar_right.png");
    }

    public static function GetHUDBgTexture():GTexture {
        return _gTextureAtlas.getSubTexture("hud_bg.png");
    }

    public static function GetTitleBgLeftTexture():GTexture {
        return _gTextureAtlas.getSubTexture("title_bg_left.png");
    }

    public static function GetTitleBgRightTexture():GTexture {
        return _gTextureAtlas.getSubTexture("title_bg_right.png");
    }

    public static function GetTitleBgCenterTexture():GTexture {
        return _gTextureAtlas.getSubTexture("title_bg_center.png");
    }

    public static function GetDestructiblePlatformTexture():GTexture {
        return _gTextureAtlas.getSubTexture("platform_destructible.png");
    }

    public static function getTutoPopupBgTopLeftTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_left_up.png");
    }

    public static function getTutoPopupBgTopTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_up.png");
    }

    public static function getTutoPopupBgTopRightTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_right_up.png");
    }

    public static function getTutoPopupBgLeftTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_left.png");
    }

    public static function getTutoPopupBgCenterTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_center.png");
    }

    public static function getTutoPopupBgRightTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_right.png");
    }

    public static function getTutoPopupBgBottomLeftTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_left_down.png");
    }

    public static function getTutoPopupBgBottomTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_down.png");
    }

    public static function getTutoPopupBgBottomRightTexture():GTexture {
        return _gTextureAtlas.getSubTexture("popup_tutorial_right_down.png");
    }

    public static function getOKButtonOffTexture():GTexture {
        return _gTextureAtlas.getSubTexture("btn_ok_off.png");
    }

    public static function getOKButtonOnTexture():GTexture {
        return _gTextureAtlas.getSubTexture("btn_ok_on.png");
    }

    public static function getSplashScreen():Bitmap {
        if(GameConstants.ASSETS_SCALE == 1)
            return new AssetsSD.Splash();
        else
            return new AssetsHD.Splash();
    }
}
}
