/**
 * Created by lvdeluxe on 14-12-31.
 */
package com.deluxe.myballs.states.game.obstacles {
import citrus.objects.CitrusSprite;

import com.deluxe.myballs.AssetsManager;

import starling.display.Image;
import starling.textures.TextureSmoothing;

public class ArrowContainer extends CitrusSprite{
	public function ArrowContainer(name:String, params:Object = null) {
		super(name, params);
		view = new Image(AssetsManager.getArrowContainerLeftTexture());
		group = 4;
		view.touchable = false;
		view.smoothing = TextureSmoothing.NONE;
	}
}
}
