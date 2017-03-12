/**
 * Created by lvdeluxe on 15-02-08.
 */
package com.deluxe.myballs.ui {
import com.deluxe.myballs.AssetsManager;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;

public class GSocialButton extends GButton{

    public static const FACEBOOK:String = "facebook";
    public static const TWITTER:String = "twitter";
    public static const GAME_CENTER:String = "gameCenter";

    private var _logo:GSprite;

    public function GSocialButton() {
        super();
    }

    override public function init():void{
        super.init();
    }

    public function setLogo(pId:String):void{
        _logo = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _logo.texture = AssetsManager.getLogoById(pId);
        var offset:Number = height - _logo.texture.height;
        _logo.node.transform.setPosition((_logo.texture.width / 2) + (offset / 2), height / 2);
        node.addChild(_logo.node);
    }

}
}
