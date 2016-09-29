package ;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author Kirill Poletaev
 */

class TileCollisionDetector
{

	public static function detect(map:Array<Array<Int>>, position:Point, movementVector:Point, tileSize:Int):Void
	{
		// position coordinates on the grid
		var tileCoords:Point = new Point(0, 0);
		var approximateCoords:Point = new Point();
		
		position.y += movementVector.y;
		
		checkBottomCollision(tileCoords, approximateCoords, position, movementVector, tileSize, map);
		
		checkTopCollision(tileCoords, approximateCoords, position, movementVector, tileSize, map);
		
		position.x += movementVector.x;
		
		checkRightCollision(tileCoords, approximateCoords, position, movementVector, tileSize, map);
		
		checkLeftCollision(tileCoords, approximateCoords, position, movementVector, tileSize, map);
	}
	
	private static function checkBottomCollision(tileCoords:Point, approximateCoords:Point, position:Point, movementVector:Point, tileSize:Int, map:Array<Array<Int>>):Void {
		
		// Bottom collision
		if (movementVector.y >= 0) 
		{
			approximateCoords.x = position.x / tileSize;
			approximateCoords.y = position.y / tileSize;
			tileCoords.y = Math.ceil(approximateCoords.y);
			
			tileCoords.x = Math.floor(approximateCoords.x);
			
			if (isBlock(tileCoords, map)) 
			{
				position.y = (tileCoords.y - 1) * tileSize;
				movementVector.y = 0;
			}
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords, map)) 
			{
				position.y = (tileCoords.y - 1) * tileSize;
				movementVector.y = 0;
			}
		}
	}
	
	private static function checkTopCollision(tileCoords:Point, approximateCoords:Point, position:Point, movementVector:Point, tileSize:Int, map:Array<Array<Int>>):Void {
		
		// Top collision
		if (movementVector.y < 0) 
		{
			approximateCoords.x = position.x / tileSize;
			approximateCoords.y = position.y / tileSize;
			
			tileCoords.y = Math.floor(approximateCoords.y);
			
			tileCoords.x = Math.floor(approximateCoords.x);
			
			if (isBlock(tileCoords, map)) 
			{
				position.y = (tileCoords.y + 1) * tileSize;
				movementVector.y = 0;
			}
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords, map)) 
			{
				position.y = (tileCoords.y + 1) * tileSize;
				movementVector.y = 0;
			}
		}
	}
	
	private static function checkRightCollision(tileCoords:Point, approximateCoords:Point, position:Point, movementVector:Point, tileSize:Int, map:Array<Array<Int>>):Void {
		
		// Right collision
		if (movementVector.x > 0)
		{
			approximateCoords.x = position.x / tileSize;
			approximateCoords.y = position.y / tileSize;
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			tileCoords.y = Math.floor(approximateCoords.y);
			
			if (isBlock(tileCoords, map)) 
			{
				position.x = (tileCoords.x - 1) * tileSize;
				movementVector.x = 0;
			}
			
			tileCoords.y = Math.ceil(approximateCoords.y);
			
			if (isBlock(tileCoords, map)) 
			{
				position.x = (tileCoords.x - 1) * tileSize;
				movementVector.x = 0;
			}
		}
	}
	
	private static function checkLeftCollision(tileCoords:Point, approximateCoords:Point, position:Point, movementVector:Point, tileSize:Int, map:Array<Array<Int>>):Void {
		// Left collision
		if (movementVector.x <= 0)
		{
			approximateCoords.x = position.x / tileSize;
			approximateCoords.y = position.y / tileSize;
			
			tileCoords.x = Math.floor(approximateCoords.x);
			
			tileCoords.y = Math.floor(approximateCoords.y);
			
			if (isBlock(tileCoords, map)) 
			{
				position.x = (tileCoords.x + 1) * tileSize;
				movementVector.x = 0;
			}
			
			tileCoords.y = Math.ceil(approximateCoords.y);
			if (isBlock(tileCoords, map)) 
			{
				position.x = (tileCoords.x + 1) * tileSize;
				movementVector.x = 0;
			}
		}
	}
	
	private static function isBlock(coords:Point, map:Array<Array<Int>>):Bool 
	{
		return map[Math.round(coords.y)][Math.round(coords.x)] == 1;
	}
	
}