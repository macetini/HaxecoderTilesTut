package ;

import openfl.display.Tileset;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Player character's entity.
 * @author Kirill Poletaev
 */

enum Direction {
	Left;
	Right;
	Up;
	Down;
}

class PlayerCharacter extends TileEntity
{
	private var faceDown:Array<Int>;
	private var faceUp:Array<Int>;
	private var faceRight:Array<Int>;
	private var faceLeft:Array<Int>;
	
	private var direction:Array<Int>;
	
	private var walkingAnimation:Array<Int>;
	private var walkAnimStepper:AnimationStepper;
	
	public var position:Point;
	public var movementSpeed:Int;

	public function new(tileset:Tileset) 
	{
		faceDown = new Array<Int>();
		faceUp = new Array<Int>();
		faceRight = new Array<Int>();
		faceLeft = new Array<Int>();
		
		faceDown.push(tileset.addRect(new Rectangle(0, 32, 32, 32)));
		faceDown.push(tileset.addRect(new Rectangle(32, 32, 32, 32)));
		faceDown.push(tileset.addRect(new Rectangle(64, 32, 32, 32)));
		
		faceUp.push(tileset.addRect(new Rectangle(0, 64, 32, 32)));
		faceUp.push(tileset.addRect(new Rectangle(32, 64, 32, 32)));
		faceUp.push(tileset.addRect(new Rectangle(64, 64, 32, 32)));
		
		faceLeft.push(tileset.addRect(new Rectangle(0, 96, 32, 32)));
		faceLeft.push(tileset.addRect(new Rectangle(32, 96, 32, 32)));
		faceLeft.push(tileset.addRect(new Rectangle(64, 96, 32, 32)));
		
		faceRight.push(tileset.addRect(new Rectangle(0, 128, 32, 32)));
		faceRight.push(tileset.addRect(new Rectangle(32, 128, 32, 32)));
		faceRight.push(tileset.addRect(new Rectangle(64, 128, 32, 32)));
		
		position = new Point(128, 128);
		direction = faceDown;
		
		walkAnimStepper = new AnimationStepper([0, 1, 0, 2], 5);
		
		movementSpeed = 3;
	}
	
	override public function draw():Array<Float> 
	{
		var tile:Int = direction[walkAnimStepper.getFrame()];
		return [position.x, position.y, tile];
	}
	
	public function move(keysHeld:Array<Bool>): Point
	{
		var move:Point = new Point();
		
		if (keysHeld[38]) 
		{
			face(Up);
			move.y -= movementSpeed;
		}
		else if (keysHeld[39]) 
		{
			face(Right);
			move.x += movementSpeed;
		}
		else if (keysHeld[40]) 
		{
			face(Down);
			move.y += movementSpeed;
		} 
		else if (keysHeld[37]) 
		{
			face(Left);
			move.x -= movementSpeed;
		}
		else 
		{	
			resetAnim();
			
			return move;
		}
		
		animate();
		
		return move;
	}
	
	private function face(dir:Direction):Void
	{
		switch(dir) 
		{
			case Up: 
				direction = faceUp;
				
			case Down:
				direction = faceDown;
				
			case Right:
				direction = faceRight;
				
			case Left:
				direction = faceLeft;
		}
	}
	
	private function resetAnim():Void
	{
		walkAnimStepper.reset();
	}
	
	private function animate():Void
	{
		walkAnimStepper.animate();
	}
}