using Godot;

namespace Bubble;

[GlobalClass]
public partial class TheWorldBubbleEffectController : BubbleEffectController
{
    private const float GameSpeedMultiplier = 0.5f;
    public override EffectType EffectType => EffectType.TheWorld;
    protected override Color? BubbleColor => Color.FromHsv(201f / 360, 84 / 100f, 1);

    protected override void HandlePlayerEnter(PlayerMovement playerMovement)
    {
        Game.Instance.GameSpeed *= GameSpeedMultiplier;
        playerMovement.Fast(1 / GameSpeedMultiplier);
    }

    protected override void HandlePlayerExit(PlayerMovement playerMovement)
    {
        Game.Instance.GameSpeed /= GameSpeedMultiplier;
        playerMovement.Fast(GameSpeedMultiplier);
    }
}