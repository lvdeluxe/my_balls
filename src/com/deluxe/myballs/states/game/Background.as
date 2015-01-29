/**
 * Created by lvdeluxe on 14-12-23.
 */
package com.deluxe.myballs.states.game {
import com.deluxe.myballs.*;

import citrus.objects.CitrusSprite;

import feathers.display.TiledImage;

import starling.display.BlendMode;
import starling.display.Image;
import starling.textures.TextureSmoothing;

public class Background extends CitrusSprite{
	public function Background(name:String, params:Object = null) {
		super(name, params);
		view = new Image(AssetsManager.getBgTexture());
		view.width = GameConstants.SCREEN_WIDTH;
		view.height = GameConstants.SCREEN_HEIGHT;
		group = 1;
//		view.smoothing = TextureSmoothing.NONE;
		view.touchable = false;
//		view.blendMode = BlendMode.NONE;
	}
}
}
