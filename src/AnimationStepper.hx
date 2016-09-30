package;


/**
 * Handling of frame animation.
 * @author Kirill Poletaev
 */
class AnimationStepper
{
	public var frames:Array<Int>;
	public var frameDelay:Int;
	
	private var step:Int;
	private var frameCounter:Int;

	public function new(frames:Array<Int>, frameDelay:Int) 
	{
		this.frames = frames;
		this.frameDelay = frameDelay;
		frameCounter = 0;
		step = 0;
	}
	
	public function reset():Void 
	{
		step = 0;
		frameCounter = 0;
	}
	
	public function animate():Void 
	{	
		if (frameCounter >= 0) 
		{
			frameCounter = -frameDelay;
			step++;
			
			if (step == frames.length) 
			{
				step = 0;
			}
		}
		else
		{
			frameCounter++;
		}
	}
	
	public function getFrame():Int 
	{
		return frames[step];
	}
	
}