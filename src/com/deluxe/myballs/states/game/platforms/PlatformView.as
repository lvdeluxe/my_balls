/**
 * Created by lvdeluxe on 15-01-18.
 */
package com.deluxe.myballs.states.game.platforms {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GameConstants;

import feathers.display.Scale3Image;
import feathers.display.TiledImage;
import feathers.textures.Scale3Textures;

import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.TextureSmoothing;

public class PlatformView extends Sprite{

	public function PlatformView(pWidth:uint) {
		var textures:Scale3Textures = new Scale3Textures( AssetsManager.getPlatformTexture(), 10, 12, Scale3Textures.DIRECTION_HORIZONTAL );
		var img_left:Scale3Image = new Scale3Image(textures,1);
//		img_left.blendMode = BlendMode.NONE;
//		img_left.smoothing = TextureSmoothing.NONE;
		img_left.width = pWidth;
		addChild(img_left);
	}
}
}
