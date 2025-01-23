using Godot;

namespace Bubble;

public abstract partial class BubbleEffectController : Node
{
    protected abstract EffectType EffectType { get; }
    protected abstract void HandlePlayerEnter(PlayerMovement playerMovement);
    protected abstract void HandlePlayerExit(PlayerMovement playerMovement);

    public void HandleBodyEnter(Node2D node)
    {
        if (node is PlayerMovement playerMovement)
        {
            HandlePlayerEnter(playerMovement);
        }
    }
    public void HandleBodyExit(Node2D node)
    {
        if (node is PlayerMovement playerMovement)
        {
            HandlePlayerExit(playerMovement);
        }
    }
}