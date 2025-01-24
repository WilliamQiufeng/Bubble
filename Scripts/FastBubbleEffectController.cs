using Godot;

namespace Bubble;

[GlobalClass]
public partial class FastBubbleEffectController : BubbleEffectController
{
	private const float FastMultiplier = 1.3f;
	public override EffectType EffectType => EffectType.Fast;
	protected override Color? BubbleColor => Color.FromHsv(279 / 360f, 77 / 100f, 1);

	protected override void HandlePlayerEnter(PlayerMovement playerMovement)
	{
		playerMovement.Fast(FastMultiplier);
	}

	protected override void HandlePlayerExit(PlayerMovement playerMovement)
	{
		playerMovement.Fast(1 / FastMultiplier);
	}
}
