/**
 * Created by lvdeluxe on 15-01-06.
 */
package com.deluxe.myballs.states.game.platforms {
import citrus.objects.CitrusSprite;

import com.deluxe.myballs.AssetsManager;

import starling.display.BlendMode;
import starling.display.Image;

public class PlatformMarker extends CitrusSprite{

	public function PlatformMarker(name:String, params:Object = null) {
		super(name, params);
		view = new Image(AssetsManager.getPlatformTexture());
		view.visible = false;
		view.pivotX = view.width >> 1;
		view.pivotY = view.height >> 1;
		view.touchable = false;
		view.blendMode = BlendMode.NONE;
		group = 50;
	}
}
}
