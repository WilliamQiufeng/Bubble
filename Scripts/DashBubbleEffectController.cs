using Godot;

namespace Bubble;

[GlobalClass]
public partial class DashBubbleEffectController : BubbleEffectController
{
	public override EffectType EffectType => EffectType.Dash;
	protected override Color? BubbleColor => Color.FromHsv(60f / 360, 90f / 100, 1);

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
