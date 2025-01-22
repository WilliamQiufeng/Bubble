namespace Bubble;

using Godot;

public partial class Movement : CharacterBody2D
{
	[Export]
	public int Speed { get; set; } = 100;

	public void GetInput()
	{
		var inputDirection = Input.GetVector("left", "right", "up", "down");
		Velocity = inputDirection * Speed;
	}

	public override void _PhysicsProcess(double delta)
	{
		GetInput();
		MoveAndSlide();
	}
}
