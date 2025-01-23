using Godot;

namespace Bubble;

public partial class BulletBubbleEffectController : BubbleEffectController
{
    public override EffectType EffectType => EffectType.Bullet;
    private CollisionShape2D CollisionShape2D { get; set; }
    public override void _Ready()
    {
        base._Ready();
        CollisionShape2D = GetNode<CollisionShape2D>("../CollisionShape2D");
        CollisionShape2D.ApplyScale(Vector2.One * 0.1f);
    }

    protected override void HandlePlayerEnter(PlayerMovement playerMovement)
    {
    }

    protected override void HandlePlayerExit(PlayerMovement playerMovement)
    {
    }
}