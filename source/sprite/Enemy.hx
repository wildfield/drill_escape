package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.FlxObject;
import flixel.util.FlxPoint;

class Enemy extends FlxSprite
{
	private var _path:FlxPath;

	public var speed:Float = 200;
	public var player:Player;

    public function new(?X:Float = 0, ?Y:Float = 0)
    {
    	_path = new FlxPath();

        super(X, Y);
    }

    public function drawSprite(?width:Int = 0, ?height:Int = 0):Void {
        makeGraphic(width, height, FlxColor.RED);
    }

    override public function update():Void
    {
    	if (!_path.finished && player.isActive()) {
    		_path.speed	= speed;
    	}
    	else {
    		_path.speed	= 0;
    		velocity = FlxPoint.get(0, 0);
    	}

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function followPlayer(map:FlxTilemap):Void {
    	var pathPoints:Array<FlxPoint> = map.findPath(getMidpoint(), player.getMidpoint());
    	

    	if (pathPoints != null) {
    		_path.start(this, pathPoints, 0);
    	}
    	else {
    		trace("path is invalid for" + this.getMidpoint());
    	}
    }
}