package;

import flash.Lib;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Kirill Poletaev
 */

class Main extends Sprite 
{
	private var _inited:Bool;
	
	private var _tileset:Tileset;
	
	private var _terrainTilemap:Tilemap;
	private var _entitesTilemap:Tilemap;

	private var _tileSize:Int;
	
	private var _map:Array<Array<Int>>;
	
	private var _entities:Array<TileEntity>;
	private var _character:PlayerCharacter;
	
	private var _keysHeld:Array<Bool>;
	
	private var _terrainCanvas:Sprite;
	private var _entitiesCanvas:Sprite;
	
	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
	
	function resize(e) 
	{
		if (!_inited) init();
		// else (resize or orientation change)
	}
	
	public function init() 
	{
		if (_inited) 
		{
			return;
		}
		
		_inited = true;
		
		initTileset();
		
		initTerrain();		
		drawTerrain();
		
		initEntities();
		
		//Game loop
		stage.addEventListener(Event.ENTER_FRAME, everyFrame);
		
		initKeyboardListeners();
		
		addProfiler();
	}
	
	private function initTileset(): Void
	{
		var tilesBitmapData:BitmapData = Assets.getBitmapData("img/set.png");
		
		_tileset = new Tileset(tilesBitmapData);
		_tileset.addRect(new Rectangle(0, 0, 32, 32));
		_tileset.addRect(new Rectangle(32, 0, 32, 32));
	}
	
	private function initTerrain(): Void
	{
		_terrainCanvas = new Sprite();
		addChild(_terrainCanvas);

		_terrainTilemap = new Tilemap(stage.stageWidth, stage.stageHeight, _tileset);
		_terrainCanvas.addChild(_terrainTilemap);
		
		_tileSize = 32;
		_map = new Array<Array<Int>>();
		TileMap.create(_map);
	}
	
	private function drawTerrain(): Void
	{
		var tile:Tile;
		
		//Tearain
		for (row in 0..._map.length)
		{	
			for (cell in 0..._map[row].length)
			{
				tile = new Tile(_map[row][cell], _tileSize * cell, _tileSize * row);
				_terrainTilemap.addTile(tile);
			}
		}
	}
	
	private function initEntities():Void 
	{
		_entitesTilemap = new Tilemap(stage.stageWidth, stage.stageHeight, _tileset);
		
		_entitiesCanvas = new Sprite();		
		_entitiesCanvas.addChild(_entitesTilemap);
		
		addChild(_entitiesCanvas);
		
		_character = new PlayerCharacter(_tileset);
		
		_entities = new Array<TileEntity>();
		_entities.push(_character);
		
		_entities.push(new Flag(10, 10, _tileSize, _tileset, _entities));
		_entities.push(new Flag(2, 2, _tileSize, _tileset, _entities));
		_entities.push(new Flag(4, 12, _tileSize, _tileset, _entities));
		_entities.push(new Flag(22, 10, _tileSize, _tileset, _entities));
		_entities.push(new Flag(20, 3, _tileSize, _tileset, _entities));
	}
	
	private function initKeyboardListeners(): Void
	{
		_keysHeld = new Array<Bool>();
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
	private function everyFrame(evt:Event):Void
	{
		var move:Point = _character.move(_keysHeld);
		
		//trace("x: " + move.x + " y: " + move.y);
		
		TileCollisionDetector.detect(_map, _character.position, move, _tileSize);
		
		// player-flag collisions
		detectFlagCoallision();
		
		drawEntities();
	}	
	
	private function drawEntities():Void 
	{
		var tile:Tile;
		
		_entitesTilemap.removeTiles();
		
		var entityData:Array<Float>;
		for (entity in _entities)
		{
			entityData = entity.draw();
			tile = new Tile( cast (entityData[2], Int), entityData[0], entityData[1]);
			_entitesTilemap.addTile(tile);
		}
	}
	
	private function detectFlagCoallision():Void
	{
		for (entity in _entities) 
		{
			if (Std.is(entity, Flag)) 
			{
				var flag:Flag = cast(entity, Flag);
				
				if (Point.distance(_character.position, flag.position) <= flag.radius) 
				{
					flag.collide(_character);
				}
			}
		}
	}
	
	private function keyDown(evt:KeyboardEvent):Void 
	{
		_keysHeld[evt.keyCode] = true;
	}
	
	private function keyUp(evt:KeyboardEvent):Void 
	{
		_keysHeld[evt.keyCode] = false;
	}
	
	private function addProfiler(): Void
	{
		var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0x000000);
		addChild(fps_mem);
	}
}
