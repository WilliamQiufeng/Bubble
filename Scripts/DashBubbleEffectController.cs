using Godot;

namespace Bubble;

public partial class DashBubbleEffectController : BubbleEffectController
{
    public override EffectType EffectType => EffectType.Dash;
    public override void _Ready()
    {
        base._Ready();
    }

    protected override void HandlePlayerEnter(PlayerMovement playerMovement)
    {
        playerMovement.CanDash = true;
    }

    protected override void HandlePlayerExit(PlayerMovement playerMovement)
    {
        playerMovement.CanDash = false;
    }
}