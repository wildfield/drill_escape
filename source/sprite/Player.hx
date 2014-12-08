package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	public var speed:Float = 200;
    public var snapper:Snapper;
    public var drilledCallback:Int->Int->Void;

    static private var DrillTime = 0.5;
    private var _drillTimer = DrillTime;
    private var _drilling = false;
    private var _drillX = 0;
    private var _drillY = 0;

    public function new(?X:Float = 0, ?Y:Float = 0)
    {
        super(X, Y);
    }

    public function drawSprite(?width:Int = 0, ?height:Int = 0):Void {
        makeGraphic(width, height, FlxColor.BLUE);
    }

    override public function update():Void
    {
    	updateMovement();
        updateDrilling();

        super.update();
    }

    private function updateMovement():Void
	{
        if (Controller.isMoving()) {
            cancelDrilling();

            var up = Controller.isMovingUp();
            var down = Controller.isMovingDown();
            var left = Controller.isMovingLeft();
            var right = Controller.isMovingRight();

            var speedX = speed * Util.boolToInt(right) - 
                         speed * Util.boolToInt(left);
            var speedY = speed * Util.boolToInt(down) - 
                         speed * Util.boolToInt(up);

            velocity.x = speedX;
            velocity.y = speedY;
        }
        else if (snapper.snappedToGridObject(this)) {
            velocity.x = 0;
            velocity.y = 0;
        }
	}

    public function startDrilling(mapX:Int, mapY:Int):Void {
        _drilling = true;
        _drillTimer = DrillTime;

        _drillX = mapX;
        _drillY = mapY;
    }

    public function cancelDrilling():Void {
        _drilling = false;
    }

    private function updateDrilling():Void {
        if (_drilling) {
            _drillTimer -= FlxG.elapsed;

            if (_drillTimer <= 0) {
            _drilling = false;
                drilledCallback(_drillX, _drillY);
            }
        }
    }

    public function isDrilling():Bool {
        return _drilling;
    }

    public function drillingProgress():Float {
        return (DrillTime - _drillTimer) / DrillTime;
    }

    public function isMoving():Bool {
        return Controller.isMoving() || velocity.x > 0 || velocity.y > 0;
    }

    public function isActive():Bool {
        return Controller.isMoving() || _drilling;
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}