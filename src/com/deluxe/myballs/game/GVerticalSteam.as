/**
 * Created by lvdeluxe on 15-02-06.
 */
package com.deluxe.myballs.game {
import com.deluxe.myballs.AssetsManager;
import com.deluxe.myballs.GNodeLayers;
import com.deluxe.myballs.GameConstants;
import com.deluxe.myballs.particles.VerticalSteamParticles;
import com.deluxe.myballs.physics.NapeCollisionTypes;
import com.deluxe.myballs.physics.NapeComponent;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;

import nape.phys.Body;

import nape.shape.Polygon;
import nape.shape.Shape;

public class GVerticalSteam extends NapeComponent{

	private var _view:GSprite;
    public var steamParticles:VerticalSteamParticles;

	public function GVerticalSteam() {
        super();
    }

    public function get body():Body{
        return _body;
    }

	override public function activate():void{
		super.activate();
        //steamParticles.node.transform.setPosition(x,y - 500);//(GameConstants.TILE_SIZE * 2));
        node.core.onUpdate.add(update);
        _view.node.transform.setPosition(x, y + (GameConstants.TILE_SIZE / 2));
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(steamParticles.node);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).addChild(_view.node);
	}

	override public function deactivate():void{
		super.deactivate();
        node.core.onUpdate.remove(update);
        _view.node.parent.removeChild(_view.node);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(steamParticles.node);
        Genome2D.getInstance().root.getChildAt(GNodeLayers.PARTICLES_LAYER).removeChild(_view.node);
	}

	override protected function getShape():Shape{

        var shape:Shape = new Polygon(Polygon.box(GameConstants.TILE_SIZE,height,true));
        shape.material = getMaterial();
        shape.sensorEnabled = true;
        shape.cbTypes.add(NapeCollisionTypes.STEAM_COLLISION);
		return shape;
	}

    public function get height():Number{
        return GameConstants.PLATFORM_OFFSET / 2 * GameConstants.ASSETS_SCALE;
    }

	override public function init():void{
		super.init();
        _view = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _view.texture = AssetsManager.getVerticalSteamPipeTexture();
        steamParticles = node.addComponent(VerticalSteamParticles) as VerticalSteamParticles;
//        steamParticles.texture = AssetsManager.getSteamParticle();
//        steamParticles.emission = new GCurve(75);
//        steamParticles.duration = GameConstants.STEAM_EMIT_TIME;
//        steamParticles.addInitializer(new SteamInitializer());
//        steamParticles.addAffector(new SteamAffector());
	}
}
}
