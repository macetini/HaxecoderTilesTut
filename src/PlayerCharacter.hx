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
	private var _faceDown:Array<Int>;
	private var _faceUp:Array<Int>;
	private var _faceRight:Array<Int>;
	private var _faceLeft:Array<Int>;
	
	private var _direction:Array<Int>;
	
	private var _walkingAnimation:Array<Int>;
	private var _walkAnimStepper:AnimationStepper;
	
	public var position:Point;
	public var movementSpeed:Int;

	public function new(tileset:Tileset) 
	{
		_faceDown = new Array<Int>();
		_faceUp = new Array<Int>();
		_faceLeft = new Array<Int>();
		_faceRight = new Array<Int>();
		
		_faceDown.push(tileset.addRect(new Rectangle(0, 32, 32, 32)));
		_faceDown.push(tileset.addRect(new Rectangle(32, 32, 32, 32)));
		_faceDown.push(tileset.addRect(new Rectangle(64, 32, 32, 32)));
		
		_faceUp.push(tileset.addRect(new Rectangle(0, 64, 32, 32)));
		_faceUp.push(tileset.addRect(new Rectangle(32, 64, 32, 32)));
		_faceUp.push(tileset.addRect(new Rectangle(64, 64, 32, 32)));
		
		_faceLeft.push(tileset.addRect(new Rectangle(0, 96, 32, 32)));
		_faceLeft.push(tileset.addRect(new Rectangle(32, 96, 32, 32)));
		_faceLeft.push(tileset.addRect(new Rectangle(64, 96, 32, 32)));
		
		_faceRight.push(tileset.addRect(new Rectangle(0, 128, 32, 32)));
		_faceRight.push(tileset.addRect(new Rectangle(32, 128, 32, 32)));
		_faceRight.push(tileset.addRect(new Rectangle(64, 128, 32, 32)));
		
		position = new Point(128, 128);
		
		_direction = _faceDown;
		_walkAnimStepper = new AnimationStepper([0, 1, 0, 2], 5);
		
		movementSpeed = 3;
	}
	
	override public function draw():Array<Float> 
	{
		var tile:Int = _direction[_walkAnimStepper.getFrame()];
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
				_direction = _faceUp;
				
			case Down:
				_direction = _faceDown;
				
			case Right:
				_direction = _faceRight;
				
			case Left:
				_direction = _faceLeft;
		}
	}
	
	private function resetAnim():Void
	{
		_walkAnimStepper.reset();
	}
	
	private function animate():Void
	{
		_walkAnimStepper.animate();
	}
}