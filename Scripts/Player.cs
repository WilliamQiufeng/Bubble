using System;
using Godot;

namespace Bubble;

public partial class Player : Node
{
    private float _hp = 100;
    private float _mana = 100;

    [Export]
    public float Hp
    {
        get => _hp;
        set
        {
            var oldValue = _hp;
            _hp = Math.Clamp(value, 0, MaxHp);
            EmitSignal(SignalName.HpChange, oldValue / MaxHp, _hp / MaxHp);
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
            _mana = Math.Clamp(value, 0, MaxMana);
            EmitSignal(SignalName.ManaChange, oldValue / MaxMana, _mana / MaxMana);
        }
    }

    public int MaxHp { get; set; } = 100;
    public int MaxMana { get; set; } = 100;

    public float ManaRegenRate { get; set; } = 3;
    public float HpRegenRate { get; set; } = 1;

    public override void _Ready()
    {
        base._Ready();
        // To refresh the hp and mana bar
        Hp = 100;
        Mana = 100;
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        Hp += (float)(HpRegenRate * delta / Game.Instance.GameSpeed);
        Mana += (float)(ManaRegenRate * delta / Game.Instance.GameSpeed);
    }

    [Signal]
    public delegate void PlayerDeathEventHandler();

    [Signal]
    public delegate void HpChangeEventHandler(float oldValue, float newValue);

    [Signal]
    public delegate void ManaChangeEventHandler(float oldValue, float newValue);
}