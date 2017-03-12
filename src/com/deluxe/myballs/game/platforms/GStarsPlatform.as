/**
 * Created by lvdeluxe on 15-02-06.
 */
package com.deluxe.myballs.game.platforms {
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
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
		node.core.onUpdate.remove(update);
	}

	override protected function update(dt:Number):void{
		super.update(dt);
		for(var i:uint = 0 ; i < _stars.length ; i++) {
			_stars[i].oscillate(y);
		}
	}

	override public function activate():void{
		super.activate();
		updateStars();
		for(var i:uint = 0 ; i < _stars.length ; i++){
			_stars[i].activate();
		}
		node.core.onUpdate.add(update);
	}

	private function setStars():void {
		var numStars:uint = GameConstants.NUM_STARS_PER_PLATFORM;
		for(var i:uint = 0 ; i < numStars ; i++){
			var star:GStar = GNodeFactory.createNodeWithComponent(GStar) as GStar;
			_stars.push(star);
		}
	}

    override protected function setBonus():void {

    }

	public function updateStars():void{
		var even:Boolean = _stars.length % 2 == 0;
		var startX:Number;
		if(even)
			startX = x - (((_stars.length) / 2) * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE / 2);
		else
			startX = x - (((_stars.length - 1) / 2) * GameConstants.TILE_SIZE);
		for(var i:uint = 0 ; i < _stars.length ; i++){
			_stars[i].angle = (i*(360/_stars.length)) * GameConstants.RAD_TO_DEG;
			_stars[i].x = startX;
			_stars[i].y = y;
            Genome2D.getInstance().root.getChildAt(GNodeLayers.PLATFORM_LAYER).addChild(_stars[i].node);
			startX += GameConstants.TILE_SIZE;
			_stars[i].oscillate(y);
		}
	}
}
}
