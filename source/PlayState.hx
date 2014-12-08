package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.group.FlxTypedGroup;
import openfl.Assets;
import flixel.system.FlxSound;
import flixel.util.FlxDestroyUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private static inline var CenterToScreen = true;

	private static inline var TILE_WIDTH:Int = 12;
	private static inline var TILE_HEIGHT:Int = 12;
	// private static inline var HUD_WIDTH:Int = 150;
	private static inline var HUD_HEIGHT:Int = 70;

	private static var PathRefreshRate = 0.3;
	private static var DrillTime = 1.0;
	private static var MovementSpeed = TILE_WIDTH * 10;

	private var _map:FlxTilemap;
	private var _player:Player;
	private var _goal:Goal;
	private var _snapper:Snapper;
	private var _hud:Hud;

	private var _enemies:FlxTypedGroup<Enemy>;
	private var _enemiePositions:Array<FlxPoint>;

	private var _playerStartingPosition:FlxPoint;
	private var _goalPosition:FlxPoint;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{	


		FlxG.log.redirectTraces = true;

		loadHud();
		loadMap();
		initSnapper();
		loadPlayer();
		loadEnemies();
		loadGoal();
		setInitialPositions();
		refreshEnemyPaths();

		add(_player);
		add(_enemies);
		super.create();
	}

	private function loadHud():Void
	{
		_hud = new Hud();
		_hud.loadWithHeight(HUD_HEIGHT);
		add(_hud);

		_hud.addComponentsTo(this);
	}

	private function loadMap():Void {
		if (_map != null) {
			remove(_map);
		}

		var map = _map = new FlxTilemap();
		map.loadMap(Assets.getText("assets/data/map" + Reg.level + ".txt"), "assets/images/tiles.png", TILE_WIDTH, TILE_HEIGHT, 0, 1);

		var playerPositionIndex = map.getTileInstances(2)[0];
		_playerStartingPosition = pointFromMapIndex(playerPositionIndex);
		// trace("player position: " + _playerStartingPosition);
		map.setTileByIndex(playerPositionIndex, 0);

		_enemiePositions = new Array<FlxPoint>();
		for (i in 0...map.totalTiles) {
			if (map.getTileByIndex(i) == 3) {
				map.setTileByIndex(i, 0);
				_enemiePositions.push(pointFromMapIndex(i));
			}
		}

		var goalIndex = map.getTileInstances(4)[0];
		_goalPosition = pointFromMapIndex(goalIndex);
		map.setTileByIndex(goalIndex, 0);

		map.setTileProperties(0, FlxObject.NONE);
		map.setTileProperties(1, FlxObject.ANY);
		add(map);
	}

	private function pointFromMapIndex(index:Int):FlxPoint {
		var resultY = Math.floor(index / _map.widthInTiles);
		var resultX = index - resultY * _map.widthInTiles;
				
		return FlxPoint.get(resultX, resultY);
	}

	private function initSnapper():Void {
		var snapper = _snapper = new Snapper();

		snapper.snapWidth = TILE_WIDTH;
		snapper.snapHeight = TILE_HEIGHT;
	}

	private function loadPlayer():Void {
		var player = _player = new Player(TILE_WIDTH, TILE_HEIGHT);
		player.drawSprite(TILE_WIDTH, TILE_HEIGHT);
		player.speed = MovementSpeed;
		player.snapper = _snapper;
		player.drilledCallback = drillComplete;
		_hud.player = player;
	}

	private function loadGoal():Void {
		var goal = _goal = new Goal();
		goal.drawSprite(TILE_WIDTH, TILE_HEIGHT);

		add(goal);
	}

	private function loadEnemies():Void {
		_enemies = new FlxTypedGroup<Enemy>();

		var enemyPositions = enemyPositions();
		for (position in enemyPositions) {
			var enemy = new Enemy(1000, 1000);
			enemy.drawSprite(TILE_WIDTH, TILE_HEIGHT);
			enemy.speed = MovementSpeed;
			_enemies.add(enemy);
		}
	}

	private function enemyPositions():Array<FlxPoint> {
		// return [FlxPoint.get(8, 9),
		// 		FlxPoint.get(15, 12)];
		return _enemiePositions;
	}

	private function setInitialPositions():Void {
		//We have to add offset so things are in center
		var xOffset = xCenterOffset();
		var yOffset = yCenterOffset();

		applyOffsets([_map, _player, _goal], xOffset, yOffset);

		_player.x += _playerStartingPosition.x * TILE_WIDTH;
		_player.y += _playerStartingPosition.y * TILE_HEIGHT;

		_snapper.snapOffsetX = xOffset;
		_snapper.snapOffsetY = yOffset;

		// applyOffsets(_enemies.members, xOffset, yOffset);

		var enemyPositions = enemyPositions();
		for (i in 0...enemyPositions.length) {
			_enemies.members[i].x = enemyPositions[i].x * TILE_WIDTH + xOffset;
			_enemies.members[i].y = enemyPositions[i].y * TILE_HEIGHT + yOffset;
		}

		_goal.x += _goalPosition.x * TILE_WIDTH;
		_goal.y += _goalPosition.y * TILE_HEIGHT;
	}

	private function applyOffsets(objects:Array<Dynamic>, xOffset:Float, yOffset:Float):Void {
		for (val in objects) {
			val.x = xOffset;
			val.y = yOffset;
		}
	}

	private function refreshEnemyPaths() {
		for (enemy in _enemies.members) {
			enemy.player = _player;
			enemy.followPlayer(_map);
		}
	}

	private function xCenterOffset():Float {
		if (CenterToScreen) {
			var xOffset = (FlxG.width - _map.width) / 2;
			return xOffset;
		}
		else {
			return 0;
		}
	}

	private function yCenterOffset():Float {
		if (CenterToScreen) {
			var yOffset = HUD_HEIGHT + (FlxG.height - _map.height - HUD_HEIGHT) / 2;
			return yOffset;
		}
		else {
			return 0;
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		_map = FlxDestroyUtil.destroy(_map);

		super.destroy();
	}

	private var _pathRefreshTimer:Float = PathRefreshRate;
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (_player.isActive() && _pathRefreshTimer <= 0) {
			_pathRefreshTimer = PathRefreshRate;
			refreshEnemyPaths();
		}
		else {
			_pathRefreshTimer -= FlxG.elapsed;
		}

		if (!_player.isMoving()) {
			_snapper.snapToGridObject(_player);
			// _snapper.snapToGridGroup(cast _enemies);
		}

		if (Controller.isDrillPressed() && Controller.isDirectionPressed() && !_player.isDrilling()) {
			var targetCoord = mapPlayerCoordinates();

			if (Controller.isDrillUpPressed()) {
				targetCoord.y -= 1;
			}
			else if (Controller.isDrillDownPressed()) {
				targetCoord.y += 1;
			}
			else if (Controller.isDrillLeftPressed()) {
				targetCoord.x -= 1;
			}
			else if (Controller.isDrillRightPressed()) {
				targetCoord.x += 1;
			}

			trace("player coords: " + mapPlayerCoordinates());
			trace("target coords: " + targetCoord);

			if (targetCoord.x != 0 && 
				targetCoord.y != 0 && 
				targetCoord.x != _map.widthInTiles - 1 && 
				targetCoord.y != _map.heightInTiles - 1 &&
				_map.getTile(Math.floor(targetCoord.x), Math.floor(targetCoord.y)) == 1) {
				_player.startDrilling(Math.floor(targetCoord.x), 
									Math.floor(targetCoord.y));
			}

		}

		FlxG.overlap(_player, _goal, goalTouch);
		FlxG.overlap(_player, _enemies, enemyTouch);
		FlxG.collide(_player, _map);

		if (Controller.restartPressed()) {
			trace("reset2");
			restartLevel();
		}

		if (Controller.pausePressed()) {
			openSubState(new PauseSubState());
		}

		Reg.addTime(FlxG.elapsed);

		super.update();
	}

	private function drillComplete(x:Int, y:Int):Void {
		Util.drillSound.play();
		_map.setTile(x, y, 0);
	}

	private function mapPlayerCoordinates():FlxPoint {
		var resultX = Math.floor((_player.getMidpoint().x - xCenterOffset()) / TILE_WIDTH);
		var resultY = Math.floor((_player.getMidpoint().y - yCenterOffset()) / TILE_HEIGHT);
		return FlxPoint.get(resultX, resultY);
	}

	private function restartLevel():Void {
		// _player.cancelDrilling();
		// loadMap();
		// setInitialPositions();
		// refreshEnemyPaths();
		Reg.resetTime();
		FlxG.resetState();
	}

	private function enemyTouch(player:Player, enemy:Enemy):Void {
		Util.deathSound.play();
		restartLevel();
	}

	private function goalTouch(player:Player, goal:Goal):Void {
		Util.nextLevelSound.play();

		if (!Reg.maxLevelReached()) {
			Reg.nextLevel();

			trace("Next level");
			FlxG.switchState(new PlayState());
		}
		else {
			FlxG.switchState(new WinState());
		}
	}
}