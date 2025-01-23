namespace Bubble;

using Godot;

public partial class PlayerMovement : CharacterBody2D
{
	[Export]
	public float Speed { get; set; } = 100;

	public void GetInput()
	{
		var inputDirection = Input.GetVector("left", "right", "up", "down");
		Velocity = inputDirection * Speed * Game.Instance.GameSpeed;
	}

	public override void _PhysicsProcess(double delta)
	{
		GetInput();
		// using MoveAndCollide
		var collision = MoveAndCollide(Velocity * (float)delta);
		if (collision != null)
		{
			Velocity = Velocity.Slide(collision.GetNormal());
		}
	}

	public void Fast(float multiplier) => Speed *= multiplier;
}
