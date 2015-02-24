/**
 * Created by lvdeluxe on 15-02-06.
 */
package com.deluxe.myballs.platforms {
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.game.GStar;
import com.deluxe.myballs.GameConstants;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

public class GStarsPlatform extends GPlatform{

	private var _stars:Vector.<GStar> = new Vector.<GStar>();

	public function GStarsPlatform() {
		super();
	}

	override public function init():void{
		super.init();
		setStars();
	}

	override public function deactivate():void{
		super.deactivate();
		for(var i:uint = 0 ; i < _stars.length ; i++){
			_stars[i].deactivate();
		}
	}

	override public function activate():void{
		super.activate();
		updateStars();
		for(var i:uint = 0 ; i < _stars.length ; i++){
			_stars[i].activate();
		}
	}

	private function setStars():void {
		var numStars:uint = (width - (GameConstants.TILE_SIZE * 2)) / GameConstants.TILE_SIZE;
		for(var i:uint = 0 ; i < numStars ; i++){
			var star:GStar = GNodeFactory.createNodeWithComponent(GStar) as GStar;
			_stars.push(star);
		}
	}

    override protected function setBonus():void {

    }

	public function updateStars():void{
		var startX:Number = x - ((width / 2) - GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE / 2);
		for(var i:uint = 0 ; i < _stars.length ; i++){
			_stars[i].x = startX;
			_stars[i].y = y - GameConstants.TILE_SIZE;
            Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_stars[i].node);
			startX += GameConstants.TILE_SIZE;
		}
	}
}
}
