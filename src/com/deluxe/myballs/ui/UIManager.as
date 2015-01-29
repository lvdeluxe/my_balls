/**
 * Created by lvdeluxe on 15-01-01.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.AssetsManager;

import feathers.controls.Button;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.core.ITextRenderer;
import feathers.display.Scale9Image;
import feathers.skins.StyleNameFunctionStyleProvider;
import feathers.text.BitmapFontTextFormat;
import feathers.textures.Scale9Textures;

import flash.geom.Rectangle;
import flash.text.TextFormatAlign;

import starling.textures.Texture;

public class UIManager {
	public function UIManager() {

	}

	public static function init():void{
		var defaultSkin:Function = function(button:Button):void{
			var texturesOff:Scale9Textures = new Scale9Textures(AssetsManager.geBtnOffTexture(),new Rectangle(12,12,76,76));
			button.defaultSkin = new Scale9Image(texturesOff);
			button.defaultSkin.width = 200;
			button.defaultSkin.height = 50;
			var texturesOn:Scale9Textures = new Scale9Textures(AssetsManager.geBtnOnTexture(),new Rectangle(12,12,76,76));
			button.downSkin = new Scale9Image(texturesOn);
			button.downSkin.width = 200;
			button.downSkin.height = 50;
			button.labelFactory = function():ITextRenderer{
				var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.textFormat = new BitmapFontTextFormat( "Futura32", 32, 0xffffff, TextFormatAlign.CENTER );
				return textRenderer;
			};
		};

		var buttonStyleProvider:StyleNameFunctionStyleProvider = new StyleNameFunctionStyleProvider();
		buttonStyleProvider.defaultStyleFunction = defaultSkin;
		Button.globalStyleProvider = buttonStyleProvider;
	}
}
}
