package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Goal extends FlxSprite
{
    public function new()
    {
        super();
    }

    public function drawSprite(?width:Int = 0, ?height:Int = 0):Void {
        makeGraphic(width, height, FlxColor.CHARTREUSE);
    }

    override public function update():Void
    {
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}