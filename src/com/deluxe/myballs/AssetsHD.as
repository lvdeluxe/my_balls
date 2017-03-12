/**
 * Created by lvdeluxe on 15-04-24.
 */
package com.deluxe.myballs {
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.factories.GTextureFactory;

public class AssetsHD {

    [Embed(source="/assets/hd/fonts/impact_text.fnt", mimeType="application/octet-stream")]
    public static const ImpactTextXml:Class;
    [Embed(source="/assets/hd/fonts/impact_text.png")]
    public static const ImpactTextTexture:Class;
    [Embed(source="/assets/hd/fonts/impact_title.fnt", mimeType="application/octet-stream")]
    public static const ImpactTitleXml:Class;
    [Embed(source="/assets/hd/fonts/impact_title.png")]
    public static const ImpactTitleTexture:Class;
    [Embed(source="/assets/hd/fonts/impact_button.fnt", mimeType="application/octet-stream")]
    public static const ImpactButtonXml:Class;
    [Embed(source="/assets/hd/fonts/impact_button.png")]
    public static const ImpactButtonTexture:Class;
    [Embed(source="/assets/hd/fonts/impact_hud.fnt", mimeType="application/octet-stream")]
    public static const ImpactHUDXml:Class;
    [Embed(source="/assets/hd/fonts/impact_hud.png")]
    public static const ImpactHUDTexture:Class;
    [Embed(source="/assets/hd/fonts/impact_powerup.fnt", mimeType="application/octet-stream")]
    public static const ImpactPowerUpXml:Class;
    [Embed(source="/assets/hd/fonts/impact_powerup.png")]
    public static const ImpactPowerUpTexture:Class;

    [Embed(source="/assets/hd/sprites.xml", mimeType="application/octet-stream")]
    public static const AtlasXml:Class;
    [Embed(source="/assets/hd/sprites.png")]
    public static const AtlasTexture:Class;

    [Embed(source="/assets/hd/background_parallax_512.jpg")]
    public static const BackgroundParallax512Texture:Class;
    [Embed(source="/assets/hd/background_parallax_256.png")]
    public static const BackgroundParallax256Texture:Class;

    [Embed(source="/assets/hd/wall_tile.jpg")]
    public static const WallTexture:Class;
    [Embed(source="/assets/hd/moving_platform_wire.png")]
    public static const MovingPlatformWire:Class;

    [Embed(source="/assets/hd/splash.jpg")]
    public static const Splash:Class;

    public static var gTextureAtlas:GTextureAtlas;

    private static var _INC_MOVING:Number = 0;

    public static function init():void {

        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactText", new ImpactTextTexture().bitmapData,Xml.parse(new ImpactTextXml()));
        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactTitle", new ImpactTitleTexture().bitmapData,Xml.parse(new ImpactTitleXml()));
        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactButton", new ImpactButtonTexture().bitmapData,Xml.parse(new ImpactButtonXml()));
        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactHUD", new ImpactHUDTexture().bitmapData,Xml.parse(new ImpactHUDXml()));
        GTextureAtlasFactory.createFromBitmapDataAndFontXml("impactPowerUp", new ImpactPowerUpTexture().bitmapData,Xml.parse(new ImpactPowerUpXml()));

        gTextureAtlas = GTextureAtlasFactory.createFromEmbedded("atlas",AtlasTexture, AtlasXml);

        GTextureFactory.createFromEmbedded("wallTexture", WallTexture,1,true);
        GTextureFactory.createFromEmbedded("platformWire", MovingPlatformWire,1,true);
        GTextureFactory.createFromEmbedded("bgParallax256Texture", BackgroundParallax256Texture,1, true);
        GTextureFactory.createFromEmbedded("bgParallax512Texture", BackgroundParallax512Texture,1, true);

    }

    public static function getPlatformWireTexture():GTexture {
        return GTextureFactory.createFromEmbedded("platformWire" + (_INC_MOVING++).toString(), MovingPlatformWire,1,true);
    }
}
}
