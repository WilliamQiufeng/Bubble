using System.Collections.Generic;
using Godot;

namespace Bubble;

public abstract partial class BubbleEffectController : Node
{
    public abstract EffectType EffectType { get; }
    protected abstract void HandlePlayerEnter(PlayerMovement playerMovement);
    protected abstract void HandlePlayerExit(PlayerMovement playerMovement);
    protected BubbleController BubbleController { get; set; }
    protected Sprite2D Sprite { get; private set; }
    protected virtual Color? BubbleColor => null;
    private readonly HashSet<Node2D> _deferredBodyEnters = new(); 
    public override void _Ready()
    {
        Sprite = GetNode<Sprite2D>("../CollisionShape2D/Bubble");
        if (BubbleColor.HasValue) 
            Sprite.Modulate = BubbleColor.Value;
        GD.Print($"Color = {Sprite.Modulate}");
        BubbleController = GetNode<BubbleController>("../CollisionShape2D/Area2D");
        BubbleController.BodyEntered += HandleBodyEnter;
        BubbleController.BodyExited += HandleBodyExit;
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        if (!BubbleController.EffectType.IsBullet() && _deferredBodyEnters.Count > 0)
        {
            foreach (var deferredBodyEnter in _deferredBodyEnters)
            {
                HandleBodyEnter(deferredBodyEnter);
            }
            _deferredBodyEnters.Clear();
        }
    }

    public void HandleBodyEnter(Node2D node)
    {
        if (BubbleController.EffectType.IsBullet())
        {
            _deferredBodyEnters.Add(node);
            return;
        }
        if (node is PlayerMovement playerMovement)
        {
            GD.Print($"Enter {node}");
            HandlePlayerEnter(playerMovement);
        }
    }
    public void HandleBodyExit(Node2D node)
    {
        if (BubbleController.EffectType.IsBullet())
        {
            _deferredBodyEnters.Remove(node);
            return;
        }
        if (node is PlayerMovement playerMovement)
        {
            GD.Print($"Exit {node}");
            HandlePlayerExit(playerMovement);
        }
    }
}