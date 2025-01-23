using Godot;

namespace Bubble;

[GlobalClass]
public partial class PlayerTheWorldEffectController : EffectController
{
    private const float GameSpeedMultiplier = 0.5f;
    [Export] public PlayerMovement PlayerMovement { get; set; }
    public override string BubbleGroupName => "TheWorldBubble";
    protected override void HandleBubbleCollisionEnter(Area2D area)
    {
        Game.Instance.GameSpeed *= GameSpeedMultiplier;
        PlayerMovement.Fast(1 / GameSpeedMultiplier);
    }

    protected override void HandleBubbleCollisionExit(Area2D area)
    {
        Game.Instance.GameSpeed /= GameSpeedMultiplier;
        PlayerMovement.Fast(GameSpeedMultiplier);
    }
}