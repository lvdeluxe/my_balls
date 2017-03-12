/**
 * Created by lvdeluxe on 15-03-18.
 */
package com.deluxe.myballs.utils {
public class TweenTarget {

    private var _x:Number;
    private var _y:Number;

    public function TweenTarget(pX:Number, pY:Number) {
        _x = pX;
        _y = pY;
    }

    public function get x():Number {
        return _x;
    }

    public function set x(value:Number):void {
        _x = value;
    }

    public function get y():Number {
        return _y;
    }

    public function set y(value:Number):void {
        _y = value;
    }
}
}
