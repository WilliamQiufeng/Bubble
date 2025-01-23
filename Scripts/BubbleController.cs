using System;
using System.Linq;
using Godot;

namespace Bubble;

public partial class BubbleController : Area2D
{
    private Node2D Bubble { get; set; }
    [Export] public Node2D ScaleNode { get; set; }
    [Export] public CollisionShape2D CollisionShape { get; set; }

    public EffectType EffectType
    {
        get
        {
            var effectControllers = Bubble.GetChildren().Where(c => c is BubbleEffectController)
                .Cast<BubbleEffectController>();
            var effectType = effectControllers.Aggregate(EffectType.None,
                (current, effectController) => current | effectController.EffectType);
            return effectType;
        }
    }

    public override void _Ready()
    {
        base._Ready();
        Bubble = Owner as Node2D;
    }

    public float Area
    {
        get => CollisionShape.Shape.GetRect().Area * ScaleNode.Scale.X;
        set
        {
            var scalingFactor = Mathf.Sqrt(value / Area);
            ScaleNode.Scale = new Vector2(ScaleNode.Scale.X * scalingFactor, ScaleNode.Scale.Y * scalingFactor);
        }
    }

    public void OnBubbleAreaEntered(Area2D area)
    {
        if (Bubble.IsQueuedForDeletion())
            return;
        if (area is not BubbleController otherBubbleController)
            return;
        GD.Print($"{EffectType} hit with {otherBubbleController.EffectType}");
        if (!otherBubbleController.EffectType.IsSameType(EffectType) ||
            EffectType.IsBullet())
            return;
        otherBubbleController.Bubble.QueueFree();
        GD.Print("Previous area: " + Area);
        Area += otherBubbleController.Area;
        GD.Print("Now area: " + Area);
    }

    public void OnBubbleAreaExited(Area2D area)
    {
    }
}