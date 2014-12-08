
package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

class Hud extends FlxSprite
{
	private var _drillingText:FlxText;
	private var _levelText:FlxText;
	private var _timeText:FlxText;

	public var player:Player;

    public function new()
    {
        super();
    }

    public function loadWithHeight(height:Int):Void
    {
    	var width = FlxG.width;

    	makeGraphic(width, height, FlxColor.GRAY);
    	// x = FlxG.width - width;
    	x = 0;
    	y = 0;

		_drillingText = new FlxText(x + 20, y + 20, 0, "Drilling: 0%", 12);
		_levelText = new FlxText(_drillingText.x + 60 + _drillingText.width, y + 20, 0, "Level: " + Reg.level, 12);
		_timeText = new FlxText(_levelText.x + 30 + _levelText.width, y + 20, 0, "Time: 0 seconds", 12);
    }

    public function addComponentsTo(group:FlxGroup):Void {
    	group.add(_drillingText);
    	group.add(_levelText);
    	group.add(_timeText);
    }	

    override public function update():Void
    {
    	if (!player.isDrilling()) {
    		_drillingText.text = "[X] Drill Standby";
    	}
    	else {
    		_drillingText.text = "Drilling: " + Math.floor(player.drillingProgress() * 10) + "0%";
    	}

    	_timeText.text = "Time: " + Math.floor(Reg.totalTime * 10) / 10 + " sec";

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}