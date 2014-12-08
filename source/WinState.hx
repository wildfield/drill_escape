
package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class WinState extends FlxState
{
    override public function create():Void
    {
    	var congText = new FlxText(30, 30, FlxG.width - 60, "Congratulations! You Won!", 22);
    	congText.alignment = "center";
    	add(congText);

    	var timeText = new FlxText(30, FlxG.height - 250, FlxG.width - 60, "Total time taken: " + Math.floor(Reg.totalTime * 100) / 100 + " sec", 14);
    	timeText.alignment = "center";
    	add(timeText);

    	var restartText = new FlxText(20, FlxG.height - 20, FlxG.width - 20, "Game Made for Ludum Dare 31. Press R to Restart", 8);
    	restartText.alignment = "right";
    	add(restartText);

        super.create();
    }

    override public function update():Void
    {
    	if (Controller.restartPressed()) {
    		FlxG.switchState(new MenuState());
    	}

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}