using System;
using Godot;

namespace Bubble;

[Flags]
public enum EffectType
{
    None = 0,
    TheWorld = 1 << 0,
    Teleport = 1 << 1,
    Fast = 1 << 2,
    Dash = 1 << 3,
    Bullet = 1 << 30
}

public enum BulletType
{
    None,
    Tiny,
    Supplement
}

public static class EffectTypeHelper
{
    public static bool IsBullet(this EffectType effectType) => effectType.HasFlag(EffectType.Bullet);
    public static EffectType RemoveBullet(this EffectType effectType) => effectType & ~EffectType.Bullet;
    public static bool IsSameType(this EffectType effectType, EffectType otherEffectType) => 
        effectType.RemoveBullet() == otherEffectType.RemoveBullet();
}