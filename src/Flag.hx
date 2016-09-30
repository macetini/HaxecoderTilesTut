package;

import flash.geom.Rectangle;
import openfl.display.Tileset;
import openfl.geom.Point;

/**
 * Collectible flag entity.
 * @author Kirill Poletaev
 */
class Flag extends TileEntity
{
	public var position:Point;
	private var tileid:Int;
	private var entities:Array<TileEntity>;
	public var radius:Int;

	public function new(gridX:Int, gridY:Int, tileSize:Int, tileset:Tileset, entities:Array<TileEntity>) 
	{
		position = new Point(gridX * tileSize, gridY * tileSize);
		
		this.tileid = tileset.addRect(new Rectangle(64, 0, 32, 32));
		
		this.entities = entities;
		
		radius = tileSize;
	}
	
	override public function draw():Array<Float> {
		return [position.x, position.y, tileid];
	}
	
	override public function collide(object:TileEntity):Void {
		if (Std.is(object, PlayerCharacter)) {
			entities.remove(this);
		}
	}
	
}