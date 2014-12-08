package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	public static var totalLevels:Int = 0;

	public static var startLevelTime:Float = 0;
	public static var totalTime:Float = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];

	public static function reset():Void
	{
		level = 1;
		totalLevels = 5;

		totalTime = 0;
		startLevelTime = 0;
	}

	public static function nextLevel():Void
	{
		level += 1;
		startLevelTime = totalTime;
	}

	public static function maxLevelReached():Bool
	{
		return level >= totalLevels;
	}

	public static function addTime(increment:Float):Void
	{
		totalTime += increment;
	}

	public static function resetTime():Void
	{
		totalTime = startLevelTime;
	}
}