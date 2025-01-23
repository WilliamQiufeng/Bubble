using Godot;

namespace Bubble;

public partial class SupplementBubbleController : Node
{
    public SupplementBubbleController(Vector2 targetPosition)
    {
        TargetPosition = targetPosition;
    }

    public SupplementBubbleController()
    {
    }

    public Vector2 TargetPosition { get; set; }
    private const float Speed = 100f;
    [Export] public RigidBody2D RigidBody2D { get; set; }
    [Export] public Timer Timer { get; set; }
    public override void _Ready()
    {
        base._Ready();
        Timer.Timeout += TargetReached;
        Timer.Start();
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        var dp = TargetPosition - RigidBody2D.Position;
        if (dp.LengthSquared() < 5)
        {
            TargetReached();
            return;
        }
        RigidBody2D.ConstantForce = dp.Normalized() * Speed;
    }

    private void TargetReached()
    {
        RigidBody2D.LinearVelocity = Vector2.Zero;
        QueueFree();
    }
}