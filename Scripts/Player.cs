using System;
using Godot;

namespace Bubble;

public partial class Player : Node
{
    private float _hp = 1;
    private float _mana = 1;

    [Export]
    public float Hp
    {
        get => _hp;
        set
        {
            var oldValue = _hp;
            _hp = Math.Clamp(value, 0, 1);
            EmitSignal(SignalName.HpChange, oldValue, _hp);
            if (Hp <= 0)
            {
                EmitSignal(SignalName.PlayerDeath);
            }
        }
    }

    [Export]
    public float Mana
    {
        get => _mana;
        set
        {
            var oldValue = _mana;
            _mana = Math.Clamp(value, 0, 1);
            EmitSignal(SignalName.ManaChange, oldValue, _mana);
        }
    }

    public override void _Ready()
    {
        base._Ready();
        // To refresh the hp and mana bar
        Hp = 1;
        Mana = 1;
    }

    [Signal]
    public delegate void PlayerDeathEventHandler();

    [Signal]
    public delegate void HpChangeEventHandler(float oldValue, float newValue);

    [Signal]
    public delegate void ManaChangeEventHandler(float oldValue, float newValue);
}