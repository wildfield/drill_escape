
package ;

import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.system.FlxSound;
import flixel.FlxG;

class Util 
{
	static public var drillSound:FlxSound;
	static public var deathSound:FlxSound;
	static public var nextLevelSound:FlxSound;

	static public function loadSounds():Void {
		drillSound = FlxG.sound.load("assets/sounds/drill.wav");
		deathSound = FlxG.sound.load("assets/sounds/death.wav");
		nextLevelSound = FlxG.sound.load("assets/sounds/next_level.wav");
	}

	static public function boolToInt(input:Bool):Int {
		return input ? 1 : 0;
	}
}