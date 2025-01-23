using System;
using Godot;

namespace Bubble;

public partial class PlayerWeaponState : Node
{
    private Player Player { get; set; }
    public BulletType CurrentBulletType { get; private set; }
    public EffectType CurrentEffectType { get; private set; }

    public readonly BulletType[] AvailableBulletTypes = { BulletType.Tiny, BulletType.Supplement };
    public readonly EffectType[] AvailableEffectTypes = { EffectType.TheWorld, EffectType.Fast, EffectType.Dash };
    private int _selectedBulletTypeIndex;
    private int _selectedEffectTypeIndex;

    public int SelectedBulletTypeIndex
    {
        get => _selectedBulletTypeIndex;
        set
        {
            while (value < 0) value += AvailableBulletTypes.Length;
            _selectedBulletTypeIndex = value % AvailableBulletTypes.Length;
            CurrentBulletType = AvailableBulletTypes[_selectedBulletTypeIndex];
            GD.Print($"Selected Bullet Type = {CurrentBulletType}");
        }
    }

    public int SelectedEffectTypeIndex
    {
        get => _selectedEffectTypeIndex;
        set
        {
            while (value < 0) value += AvailableEffectTypes.Length;
            _selectedEffectTypeIndex = value % AvailableEffectTypes.Length;
            CurrentEffectType = AvailableEffectTypes[_selectedEffectTypeIndex];
            GD.Print($"Selected Effect Type = {CurrentEffectType}");
        }
    }

    public override void _Ready()
    {
        base._Ready();
        Player = GetNode<Player>("../PlayerController");
        SelectedBulletTypeIndex = SelectedEffectTypeIndex = 0;
    }
}