using System;
using Godot;

namespace Bubble;

public abstract record Effect(EffectType Type);
public record TheWorldEffect() : Effect(EffectType.TheWorld);
public record TeleportEffect(Timer Cooldown, Vector2 Position) : Effect(EffectType.Teleport);
public record FastEffect() : Effect(EffectType.Fast);

[Flags]
public enum EffectType
{
    None = 0,
    TheWorld = 1 << 0,
    Teleport = 1 << 1,
    Fast = 1 << 2,
    Bullet = 1 << 30
}

public static class EffectTypeHelper
{
    public static bool IsBullet(this EffectType effectType) => effectType.HasFlag(EffectType.Bullet);
    public static EffectType RemoveBullet(this EffectType effectType) => effectType & ~EffectType.Bullet;
    public static bool IsSameType(this EffectType effectType, EffectType otherEffectType) => 
        effectType.RemoveBullet() == otherEffectType.RemoveBullet();
}