using System;
using Godot;

namespace Bubble;

public partial class BubbleController : Area2D
{
    [Export] public Node2D Bubble { get; set; }
    [Export] public CollisionShape2D CollisionShape { get; set; }
    [Export] public EffectType EffectType { get; set; }
    public float Area => CollisionShape.Shape.GetRect().Area * Bubble.Scale.X;
    public void OnBubbleAreaEntered(Area2D area)
    {
        if (Bubble.IsQueuedForDeletion())
            return;
        if (area is not BubbleController otherBubbleController || otherBubbleController.EffectType != EffectType)
            return;
        otherBubbleController.Bubble.QueueFree();
        GD.Print("Previous area: " + Area);
        var scalingFactor = Mathf.Sqrt((otherBubbleController.Area + Area) / Area);
        Bubble.Scale = new Vector2(Bubble.Scale.X * scalingFactor, Bubble.Scale.Y * scalingFactor);
        GD.Print("Now area: " + Area);
    }

    public void OnBubbleAreaExited(Area2D area)
    {
    }
}