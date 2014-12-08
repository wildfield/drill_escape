
package;

import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.text.FlxText;

class PauseSubState extends FlxSubState
{
    override public function create():Void
    {
    	var pauseText = new FlxText(0, FlxG.height / 2, FlxG.width, "Paused. P to unpause", 30);
    	pauseText.alignment = "center";
    	add(pauseText);

        super.create();
    }

    override public function update():Void
    {
    	if (Controller.pausePressed()) {
    		close();
    	}

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}