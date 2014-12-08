
package ;

import flixel.FlxObject;
import flixel.group.FlxTypedGroup;

class Snapper 
{
	public var snapOffsetX:Float = 0;
    public var snapOffsetY:Float = 0;

    public var snapWidth:Float = 16;
    public var snapHeight:Float = 16;

    public function snapToGridGroup(group:FlxTypedGroup<FlxObject>):Void {
    	for (object in group.members) {
    		snapToGridObject(object);
    	}
    }

    public function snapToGridObject(object:FlxObject):Void {
        object.x = getSnapApproximation(object.x, snapWidth, snapOffsetX);
        object.y = getSnapApproximation(object.y, snapHeight, snapOffsetY);
    }

    public function snappedToGridObject(object:FlxObject):Bool {
        var diffX = getSnapApproximation(object.x, snapWidth, snapOffsetX) - object.x;
        var diffY = getSnapApproximation(object.y, snapHeight, snapOffsetY) - object.y;
        return Math.abs(diffX) < snapWidth / 8 && Math.abs(diffY) < snapHeight / 8;
    }

    private function getSnapApproximation(input:Float, snap:Float, ?offset:Float = 0):Float {
        input -= offset;
        var baseSnapValue:Float = Math.floor(input / snap) * snap;
        var diffValue = input - baseSnapValue;
        var result = baseSnapValue;
        if (diffValue > snap / 2) {
            result += snap;
        }

        return result + offset;
    }

}