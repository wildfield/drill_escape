package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	private var _btnPlay:FlxButton;

	override public function create():Void
	{
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		_btnPlay.x = (FlxG.width - _btnPlay.width) / 2;
		_btnPlay.y = FlxG.height - 100;
		add(_btnPlay);

		var titleText = new FlxText(0, 100, FlxG.width, "Drill Escape", 26);
		titleText.alignment = "center";
		add(titleText);

		var creditsText = new FlxText(20, FlxG.height - 30, FlxG.width - 40, "game made by .field for Ludum Dare 31", 9);
		creditsText.alignment = "right";
		add(creditsText);

		Util.loadSounds();

		super.create();
	}

	private function clickPlay():Void
	{
		Reg.reset();

	    FlxG.switchState(new PlayState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);

		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}