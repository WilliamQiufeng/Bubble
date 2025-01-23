namespace Bubble;

using Godot;

public partial class PlayerMovement : CharacterBody2D
{
	[Export]
	public float Speed { get; set; } = 100;
	[Export]
	public AnimatedSprite2D AnimatedSprite { get; set; }

	private Vector2 IdleDirection { get; set; } = Vector2.Down;

	public override void _Ready()
	{
		base._Ready();
		AnimatedSprite.Play("idle_towards");
	}

	public bool GetAnimationDirection(Vector2 direction, out string animation, out bool flipH)
	{
		if (direction.X != 0)
		{
			animation = "left";
			flipH = direction.X > 0;
			return true;
		} 
		if (direction.Y > 0)
		{
			animation = "towards";
			flipH = false;
			return true;
		}
		if(direction.Y < 0)
		{
			animation = "away";
			flipH = false;
			return true;
		}

		animation = "";
		flipH = false;

		return false;
	}

	public void GetInput()
	{
		var inputDirection = Input.GetVector("left", "right", "up", "down");
		Velocity = inputDirection * Speed * Game.Instance.GameSpeed;
		if (GetAnimationDirection(inputDirection, out var animation, out var flipH))
		{
			AnimatedSprite.Animation = $"walk_{animation}";
			AnimatedSprite.FlipH = flipH;
			IdleDirection = Velocity;
		}
		else
		{
			_ = GetAnimationDirection(IdleDirection, out var idleAnimation, out var _);
			AnimatedSprite.Animation = $"idle_{idleAnimation}";
		}
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
