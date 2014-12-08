
package ;

import flixel.FlxG;

class Controller 
{
	static public function isUpPressed():Bool
	{
		return FlxG.keys.anyPressed(["UP", "W"]);
	}

	static public function isDownPressed():Bool
	{
		return FlxG.keys.anyPressed(["DOWN", "S"]);
	}

	static public function isLeftPressed():Bool
	{
		return FlxG.keys.anyPressed(["LEFT", "A"]);
	}

	static public function isRightPressed():Bool
	{
		return FlxG.keys.anyPressed(["RIGHT", "D"]);
	}

	static public function isDirectionPressed():Bool
	{
		return isUpPressed() || isDownPressed() || isRightPressed() || isLeftPressed();
	}

	static public function isMovingLeft():Bool
	{
		return !isDrillPressed() && isLeftPressed();
	}

	static public function isMovingRight():Bool
	{
		return !isDrillPressed() && isRightPressed();
	}

	static public function isMovingUp():Bool
	{
		return !isDrillPressed() && isUpPressed();
	}

	static public function isMovingDown():Bool
	{
		return !isDrillPressed() && isDownPressed();
	}

	static public function isMoving():Bool
	{
		return  Controller.isMovingLeft() ||
				Controller.isMovingRight() ||
				Controller.isMovingUp() ||
				Controller.isMovingDown();
	}

	static public function restartPressed():Bool {
		return FlxG.keys.anyJustPressed(["R"]);
	}

	static public function pausePressed():Bool {
		return FlxG.keys.anyJustPressed(["P"]);
	}

	static public function isDrillPressed():Bool {
		return FlxG.keys.anyPressed(["X"]);
	}

	static public function isDrillUpPressed():Bool {
		return isDrillPressed() && isUpPressed();
	}

	static public function isDrillDownPressed():Bool {
		return isDrillPressed() && isDownPressed();
	}

	static public function isDrillLeftPressed():Bool {
		return isDrillPressed() && isLeftPressed();
	}

	static public function isDrillRightPressed():Bool {
		return isDrillPressed() && isRightPressed();
	}
}