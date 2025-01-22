using System;
using Godot;

namespace Bubble;

public partial class Player : Node
{
    [Export] public float Hp { get; set; } = 1;
    [Export] public float Mp { get; set; } = 1;
    [Export] public AnimationProgressBar HpBar { get; set; }
    [Export] public AnimationProgressBar MpBar { get; set; }
    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        Mp = Math.Clamp(Mp - 0.001f, 0, 1);
        HpBar.SetProgress(Hp);
        MpBar.SetProgress(Mp);
        
    }
}