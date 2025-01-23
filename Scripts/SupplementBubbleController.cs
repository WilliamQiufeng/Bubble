using Godot;

namespace Bubble;

public partial class SupplementBubbleController : BubbleEffectController
{
    private Bubble Bubble { get; set; }
    public SupplementBubbleController(Vector2 targetPosition)
    {
        TargetPosition = targetPosition;
    }

    public SupplementBubbleController()
    {
    }

    private Vector2 TargetPosition { get; set; }
    private const float Speed = 100f;
    private Timer _timer = new();
    public override EffectType EffectType => EffectType.Bullet;
    protected override void HandlePlayerEnter(PlayerMovement playerMovement)
    {
    }

    protected override void HandlePlayerExit(PlayerMovement playerMovement)
    {
    }

    public override void _Ready()
    {
        base._Ready();
        AddChild(_timer);
        Bubble = GetParent<Bubble>();
        _timer.WaitTime = 5;
        _timer.OneShot = true;
        _timer.Timeout += TargetReached;
        _timer.Start();
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        var dp = TargetPosition - Bubble.Position;
        if (dp.LengthSquared() < 25)
        {
            TargetReached();
            return;
        }
        Bubble.ConstantForce = dp.Normalized() * Speed;
    }

    private void TargetReached()
    {
        Bubble.LinearVelocity = Vector2.Zero;
        Bubble.ConstantForce = Vector2.Zero;
        QueueFree();
    }
}