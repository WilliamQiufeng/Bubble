using Godot;

namespace Bubble;

public partial class BubbleEffectController : Area2D
{
    [Export] public BubbleController BubbleController { get; set; }
    private void OnBubbleAreaEntered(Node2D body)
    {
        GD.Print("Bubble area entered");
        BubbleController.Movement.Speed /= 2;
    }
    private void OnBubbleAreaExited(Node2D body)
    {
        GD.Print("Bubble area exited");
        BubbleController.Movement.Speed *= 2;
    }
}