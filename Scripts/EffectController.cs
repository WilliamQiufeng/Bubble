using Godot;

namespace Bubble;

public abstract partial class EffectController : Node
{
    public abstract string BubbleGroupName { get; }
    public void AreaEnter(Area2D area)
    {
        var groups = area.GetGroups();
        if (!groups.Contains(BubbleGroupName))
            return;
        GD.Print($"Hi {string.Join(",", groups)}");
        HandleBubbleCollisionEnter(area);
    }

    protected abstract void HandleBubbleCollisionEnter(Area2D area);

    public void AreaExit(Area2D area)
    {
        var groups = area.GetGroups();
        if (!groups.Contains(BubbleGroupName))
            return;
        GD.Print($"Bye {string.Join(",", groups)}");
        HandleBubbleCollisionExit(area);
        
    }
    
    protected abstract void HandleBubbleCollisionExit(Area2D area);
}