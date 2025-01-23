using Godot;

namespace Bubble;

[GlobalClass]
public partial class PlayerFastEffectController : EffectController
{
    private const float FastMultiplier = 1.3f;
    public override string BubbleGroupName => "FastBubble";
    [Export] public PlayerMovement PlayerMovement { get; set; }
    protected override void HandleBubbleCollisionEnter(Area2D area)
    {
        PlayerMovement.Fast(FastMultiplier);
    }

    protected override void HandleBubbleCollisionExit(Area2D area)
    {
        PlayerMovement.Fast(1 / FastMultiplier);
    }
}