package;


import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;


/**
 * ...
 * @author 
 */
class Main extends Sprite 
{
	private var _tileset:Tileset;
	private var _tilemap:Tilemap;

	private var _tileSize:Int;
	
	private var _map:Array<Array<Int>>;
	
	private var entities:Array<TileEntity>;
	private var character:PlayerCharacter;
	
	private var keysHeld:Array<Bool>;
	
	public function new() 
	{
		super();
		
		var tilesBitmapData:BitmapData = Assets.getBitmapData("img/set.png");
		
		_tileset = new Tileset(tilesBitmapData);
		_tileset.addRect(new Rectangle(0, 0, 32, 32));
		_tileset.addRect(new Rectangle(32, 0, 32, 32));

		_tilemap = new Tilemap(stage.stageWidth, stage.stageHeight, _tileset);
		addChild(_tilemap);
		
		_tileSize = 32;
		
		_map = new Array<Array<Int>>();
		
		TileMap.create(_map);
		
		var tile:Tile;
		
		//Tearain
		for (row in 0..._map.length)
		{	
			for (cell in 0..._map[row].length)
			{
				tile = new Tile(_map[row][cell], _tileSize * cell, _tileSize * row);
				_tilemap.addTile(tile);
			}
		}
		
		character = new PlayerCharacter(_tileset);
		
		entities = new Array<TileEntity>();
		entities.push(character);
		
		// Entities
		var entityData:Array<Float>;
		for (entity in entities)
		{
			entityData = entity.draw();
			tile = new Tile( cast (entityData[2], Int), entityData[0], entityData[1]);
			_tilemap.addTile(tile);
		}
		
		//Game loop
		stage.addEventListener(Event.ENTER_FRAME, everyFrame);
		
		var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0x000000);
		addChild(fps_mem);
	}
	
	private function everyFrame(evt:Event):Void
	{
		
	}	
}
